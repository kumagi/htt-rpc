# -*- coding: utf-8 ruby -*-
#!/bin/env ruby


## input validations

if ARGV.length < 1
  puts "call with target file like "
  puts " $ ruby htt-rpc.rb"
  puts ""
  exit(1)
end

require './ast_node'
require './parser'
require 'optparse'
require 'erb'
params = ARGV.getopts('i:o:l:v')
# i -> input file
# o -> output file # default input-file with language
# l -> language
# v -> verbose

unless params.include? "l"
  puts "output language needed via -l option"
  exit(1)
end

filepath = "templates/#{params['l']}.erb"
unless File.exist?(filepath)
  puts "language #{params['l']} is not supported yet"
  exit(1)
end

### parse process

file = params["i"]
puts "read #{file}"
ast = parse_text(File.open(file, "r").read)
if params["v"]
  ast.dump(2)
end

# validation process

## not implemented yet!!

## output process
template = nil
begin
  file_handle = File.open(filepath, "r")
  template = file_handle.read
rescue => e
  puts "#{filepath} open failed #{e}"
end

class String
  def to_camel()
    words = self.split("_")
    words.map{|w| w[0] = w[0].upcase; w}.join("")
  end
end

erb = ERB.new(template, nil, '-')
result = erb.result(binding)

outfile = nil
if params['o']
  outfile = params['o']
else
  outfile = file.sub(/\.rpcdef$/, "_def.rb")
end

File.open(outfile, "w").write(result)
puts "wrote file #{outfile}"
