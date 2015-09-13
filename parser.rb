require 'yaml'
IDENTIFIERS = YAML.load_file("reserved_identifiers.yaml")

def is_attr?(ident)
  not (/.*_attr/ =~ ident).nil?
end
def is_type?(ident)
  not (/.*_type/ =~ ident).nil?
end
def maybe_node?(ident)
  is_attr?(ident) or is_type?(ident)
end

def parse_message(tokens)
  # returns HTT_RPC::Message
  ret = HTT_RPC::Message.new
  ret.name = tokens.shift
  should_brace_open = IDENTIFIERS[tokens.shift]
  if should_brace_open != "brace_open"
    puts "expected { after message name"
    exit(1)
  end
  loop do
    token = tokens.shift
    if token.nil?
      puts "unexpected EOF"
      exit(1)
    end
    if IDENTIFIERS.include? token
      if IDENTIFIERS[token] == "brace_close"
        return ret
      end
      if IDENTIFIERS[token] == "enum"
        ret.enum_defs << parse_enum(tokens)
        next
      end
      if IDENTIFIERS[token] == "message"
        ret.message_defs << parse_message(tokens)
        next
      end
      if maybe_node?(IDENTIFIERS[token])
        node = HTT_RPC::Node.new
        if is_attr? IDENTIFIERS[token]
          node.attribute = IDENTIFIERS[token]
          token = tokens.shift
        end
        node.type = token
        node.name = tokens.shift
        should_equal = IDENTIFIERS[tokens.shift]
        if should_equal != "equals"
          puts "= expected after type name"
          exit(1)
        end
        node.node_id = tokens.shift.to_i
        should_semicolon = IDENTIFIERS[tokens.shift]
        if should_semicolon != "semicolon"
          puts "semicolon is expected after member id"
        end
        ret.nodes << node
      end
    end
  end
end
def parse_package(tokens)
  ret = HTT_RPC::Package.new
  ret.name = tokens.shift
  ret
end
def parse_enum(tokens)
  # returns HTT_RPC::Enum
  ret = HTT_RPC::Enum.new
  ret.name = tokens.shift
  should_brace_open = IDENTIFIERS[tokens.shift]
  if should_brace_open != "brace_open"
    puts "expected { after enum name"
    exit(1)
  end

  loop do
    token = tokens.shift
    if token.nil?
      puts "unexpected EOF"
      exit(1)
    end
    if IDENTIFIERS[token] == "brace_close"
      return ret
    end
    new_node = HTT_RPC::EnumNode.new
    new_node.name = token
    should_equal = tokens.shift
    if IDENTIFIERS[should_equal] != "equals"
      puts "enum context requires '=' after name but '#{should_equal}' given"
    end
    new_node.node_id = tokens.shift.to_i
    should_semicolon = IDENTIFIERS[tokens.shift]
    if should_semicolon != "semicolon"
      puts "semicolon is expected after enum id"
    end
    ret.nodes << new_node
  end
end
def parse_option(tokens)
  ret = HTT_RPC::Option.new
  ret.name = tokens.shift
  should_equal = IDENTIFIERS[tokens.shift]
  if should_equal != "equals"
    puts "syntax context requires '=' after syntax"
  end
  ret.parameter = tokens.shift
  ret
end
def parse_syntax(tokens)
  should_equal = IDENTIFIERS[tokens.shift]
  if should_equal != "equals"
    puts "syntax context requires '=' after syntax"
  end
  ret = HTT_RPC::Syntax.new
  ret.name = tokens.shift
  ret
end

def parse_procedure(tokens)
  ret = HTT_RPC::Procedure.new
  ret.name = tokens.shift
  should_bracket_open = IDENTIFIERS[tokens.shift]
  if should_bracket_open != "bracket_open"
    puts "expected ( after rpc name"
    exit(1)
  end

  token = tokens.shift
  if IDENTIFIERS[token] == "stream"
    ret.input_stream = true
    token = tokens.shift
  end
  ret.arguments << token

  should_bracket_close = IDENTIFIERS[tokens.shift]
  if should_bracket_close != "bracket_close"
    puts "expected ) after rpc name"
    exit(1)
  end

  should_returns = IDENTIFIERS[tokens.shift]
  if should_returns != "returns"
    puts "expected 'returns' after argument"
    exit(1)
  end

  should_bracket_open = IDENTIFIERS[tokens.shift]
  if should_bracket_open != "bracket_open"
    puts "expected ( after rpc name"
    exit(1)
  end

  token = tokens.shift
  if IDENTIFIERS[token] == "stream"
    ret.output_stream = true
    token = tokens.shift
  end
  ret.returns = token

  should_bracket_close = IDENTIFIERS[tokens.shift]
  if should_bracket_close != "bracket_close"
    puts "expected ) after rpc name"
    exit(1)
  end

  token = tokens.shift
  should_brace_open = IDENTIFIERS[token]
  if should_brace_open != "brace_open"
    puts "expected { after close bracket but given #{token}"
    exit(1)
  end

  # TODO: rpc detail configuration parse

  loop do
    token = tokens.shift
    if token.nil?
      puts "unexpected EOF"
      exit(1)
    end
    if IDENTIFIERS.include? token
      if IDENTIFIERS[token] == "brace_close"
        return ret
      end
    end
  end
end

def parse_service(tokens)
  # returns HTT_RPC::Service
  ret = HTT_RPC::Service.new
  ret.name = tokens.shift
  token = tokens.shift
  should_brace_open = IDENTIFIERS[token]
  if should_brace_open != "brace_open"
    puts "expected { after service name but given #{token}"
    exit(1)
  end
  loop do
    token = tokens.shift
    if token.nil?
      puts "unexpected EOF"
      exit(1)
    end
    if IDENTIFIERS.include? token
      if IDENTIFIERS[token] == "brace_close"
        return ret
      end
    end
    if IDENTIFIERS[token] != "rpc"
      puts "expected rpc method"
    end
    ret.procedures << parse_procedure(tokens)
  end
end
require './tokenizer'

def parse_global(tokens)
  # returns HTT_RPC::Global
  global = HTT_RPC::Global.new
  until tokens.empty?
    token = tokens.shift
    if IDENTIFIERS.include? token
      type = IDENTIFIERS[token]
      case(type)
      when "message"
        global.messages << parse_message(tokens)
      when "syntax"
        global.syntax = parse_syntax(tokens)
      when "package"
        global.package = parse_package(tokens)
      when "option"
        global.options << parse_option(tokens)
      when "service"
        global.services << parse_service(tokens)
      end
    else
      puts "unexpected token '#{token}'"
    end
  end
  global
end

def parse_text(text)
  parse_global(tokenize(text))
end
