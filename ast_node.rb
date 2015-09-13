module HTT_RPC
  class Global
    def initialize()
      @syntax = nil
      @package = nil
      @options = []
      @messages = []
      @services = []
    end
    def dump(indent = 0)
      sp = " " * indent
      puts "#{sp}syntax: #{@syntax.name}"
      puts "#{sp}package: #{@package.name}"
      unless options.empty?
        puts "#{sp}options: ["
        @options.each{|option|
          option.dump(indent + 2)
        }
      puts "#{sp}]"
      end
      unless messages.empty?
        puts "#{sp}messages: ["
        @messages.each{|message|
          message.dump(indent + 2)
        }
      end
      unless services.empty?
        puts "#{sp}services: ["
        @services.each{|service|
          service.dump(indent + 2)
        }
      end
      puts "#{sp}]"
    end
    attr_accessor :syntax, :package, :options, :messages, :services
  end

  class Enum
    def initialize()
      @name = nil
      @nodes = []
      def initialize()
        @name = nilp
        @nodes = []
      end
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
    def initialize()
      @name = nil
      @type = nil
      @node_id = nil
      @attribute = nil
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
    def initialize()
      @name = nil
      @node_id = nil
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
      @message_defs = []
      @enum_defs = []
    end
    def dump(indent = 0)
      sp = " " * indent
      puts "#{sp}#{@name}: ["
      @nodes.each{|node|
        node.dump(indent + 2)
      }
      unless @message_defs.empty?
        puts "#{sp}  inner messages: ["
        @message_defs.each{|message_def|
          message_def.dump(indent + 4)
        }
        puts "#{sp}  ]"
      end
      unless @enum_defs.empty?
        puts "#{sp}  inner enums: ["
        @enum_defs.each{|enum_def|
          enum_def.dump(indent + 4)
        }
        puts "#{sp}  ]"
      end
      puts "#{sp}]"
    end
    attr_accessor :name, :nodes, :message_defs, :enum_defs
  end

  class Procedure
    def initialize()
      @name = nil
      @arguments = []
      @returns = nil
      @input_stream = nil
      @output_stream = nil
    end
    def dump(indent)
      sp = ' ' * indent
      puts "#{sp}#{@name}(#{@arguments.join(",")}) -> #{@returns}"
    end
    attr_accessor :name, :arguments, :returns, :input_stream, :output_stream
  end

  class Service
    def initialize()
      @name = nil
      @procedures = []
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

  class Syntax
    def initialize()
      @name = nil
    end
    def dump(indent)
      sp = " " * indent
      print "#{sp}#{@name}"
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
