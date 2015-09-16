require 'treetop'
require './util'
require './kantera'

def parse(data)
  if data.respond_to? :read
    data = data.read
  end

  parser = KanteraParser.new
  ast = parser.parse data
  d = Kantera::Document.new

  ast.build(d)
  puts "### "
  d.dump
  puts " ###"

  if ast
    puts "finish!"
  else
    puts "error at #{parser.failure_line}, #{parser.failure_column}"
    puts data.lines.to_a[parser.failure_line - 1]
    puts "#{'~' * (parser.failure_column - 1)}^"
    parser.failure_reason =~ /^(Expected .+) after/m
    puts "#{$1.gsub("\n", '')}:"
  end
end

data = File.open("example.rpcdef", "r").read
a = parse(data)
