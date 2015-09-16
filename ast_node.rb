module Kantera
  class Document
    def initialize()
      @settings = {}
      @options = {}
      @package = nil
      @messages = {}
      @services = {}
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
        @messages.each{|key, value|
          puts "#{sp}  #{key}: ["
          value.dump(indent + 4)
          puts "#{sp}  ]"
        }
        puts "#{sp}}"
      end
      unless @services.empty?
        puts "#{sp}services: {"
        @services.each{|service|
          service.dump(indent + 2)
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
    def initialize(name)
      @name = nil
      @nodes = []
      @messages = {}
      @enums = {}
    end
    def dump(indent = 0)
      sp = " " * indent
      puts "#{sp}#{@name}: ["
      @nodes.each{|node|
        node.dump(indent + 2)
      }
      unless @messages.empty?
        puts "#{sp}  inner messages: ["
        @messages.each{|key, value|
          puts key
          value.dump(indent + 4)
        }
        puts "#{sp}  ]"
      end
      unless @enums.empty?
        puts "#{sp}  inner enums: ["
        @enums.each{|key, value|
          puts key
          value.dump(indent + 4)
        }
        puts "#{sp}  ]"
      end
      puts "#{sp}]"
    end
    attr_accessor :name, :nodes, :messages, :enums
  end

  class Argument
    def initilize(name, type)
      @name = name
      @type = type
    end

    def dump(indent)
      puts "#{type} #{name}"
    end
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
