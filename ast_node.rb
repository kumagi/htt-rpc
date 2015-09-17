module Kantera
  class Document
    def initialize()
      @settings = {}
      @options = {}
      @package = nil
      @messages = []
      @services = []
    end
    def dump(indent = 0)
      sp = " " * indent
      puts "#{sp}settings: #{@settings}"
      puts "#{sp}package: #{@package}"
      unless @options.empty?
        puts "#{sp}options: ["
        @options.each{|key, value|
          puts "#{sp}  #{key} => #{value}"
        }
        puts "#{sp}]"
      end
      unless @messages.empty?
        puts "#{sp}messages: {"
        @messages.each{|m|
          m.dump(indent + 4)
        }
        puts "#{sp}}"
      end
      unless @services.empty?
        puts "#{sp}services: {"
        @services.each{|m|
          m.dump(indent + 2)
        }
        puts "#{sp}]"
      end
    end
    attr_accessor :settings, :package, :options, :messages, :services
  end

  class Enum
    def initialize(name, nodes)
      @name = name
      @nodes = nodes
    end
    def dump(indent = 0)
      sp = " " * indent
      puts "#{sp}#{@name} : ["
      @nodes.each {|node|
        node.dump(indent + 2)
      }
      puts "#{sp}]"
    end
    attr_accessor :name, :nodes
  end

  class Node
    def initialize(name, type, node_id, attr)
      @name = name
      @type = type
      @node_id = node_id
      @attribute = attr
    end
    def dump(indent = 0)
      sp = " " * indent
      print "#{sp}#{@node_id}: #{@name}(#{@type})"
      unless @attribute.nil?
        puts "@#{attribute}"
      else
        puts ""
      end
    end
    attr_accessor :name, :type, :node_id, :attribute
  end

  class EnumNode
    def initialize(name, node_id)
      @name = name
      @node_id = node_id
    end
    def dump(indent = 0)
      sp = " " * indent
      puts "#{sp}#{@node_id}: #{@name}"
    end
    attr_accessor :name, :node_id
  end

  class Message
    def initialize()
      @name = nil
      @nodes = []
      @messages = []
      @enums = []
    end
    def add_element(elm)
      case(elm)
      when(Message)
        @messages << elm
      when(Enum)
        @enums << elm
      when(Node)
        @nodes << elm
      else
        puts "invalid num"
      end
    end
    def dump(indent = 0)
      sp = " " * indent
      puts "#{sp}#{@name}: ["
      @nodes.each{|node|
        node.dump(indent + 2)
      }
      unless @messages.empty?
        puts "#{sp}  inner messages: ["
        @messages.each{|m|
          m.dump(indent + 4)
        }
        puts "#{sp}  ]"
      end
      unless @enums.empty?
        puts "#{sp}  inner enums: ["
        @enums.each{|m|
          m.dump(indent + 4)
        }
        puts "#{sp}  ]"
      end
      puts "#{sp}]"
    end
    attr_accessor :name, :nodes, :messages, :enums
  end

  class Argument
    def initilize
      @name = nil
      @type = nil
    end

    def to_s
      "#{type} #{name}"
    end
    attr_accessor :name, :type
  end

  class Procedure
    def initialize(name, arguments, returns, input_stream, output_stream)
      @name = name
      @arguments = arguments
      @returns = returns
      @input_stream = input_stream
      @output_stream = output_stream
    end
    def dump(indent)
      sp = ' ' * indent
      puts "#{sp}#{@name}(#{@arguments.map{|a| a.to_s}.join(", ")}) -> #{@returns}"
    end
    attr_accessor :name, :arguments, :returns, :input_stream, :output_stream
  end

  class Service
    def initialize()
      @name = nil
      @procedures= []
    end
    def dump(indent)
      sp = ' ' * indent
      puts "#{sp}#{@name}: ["
      @procedures.each{|procedure|
        procedure.dump(indent + 2)
      }
      puts "#{sp}]"
    end
    attr_accessor :name, :procedures
  end

  class Setting
    def initialize(key, value)
      @key = key
      @value = value
    end
    def dump(indent)
      sp = " " * indent
      print "#{sp}#{@key} => #{}"
    end
    attr_accessor :name
  end
  class Option
    def initialize()
      @name = nil
      @parameter = nil
    end
    def dump(indent = 0)
      sp = " " * indent
      puts "#{sp}#{@name}: #{@parameter}"
    end
    attr_accessor :name, :parameter
  end
  class Package
    def initialize()
      @name = nil
    end
    attr_accessor :name
  end
end
