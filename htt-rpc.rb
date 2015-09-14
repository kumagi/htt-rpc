# -*- coding: utf-8 ruby -*-
#!/bin/env ruby

# utilities
class String
  def to_camel()
    words = self.split("_")
    words.map{|w| w[0] = w[0].upcase; w}.join("")
  end
  def to_snake()
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end


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

### validation process

# not implemented yet!!

### output process
templates = ["", "_server", "_server_impl"]
filename = file.sub(/\.rpcdef$/, "")
templates.each{|t|
  filepath = "templates/#{params['l']}#{t}.erb"
  template = nil
  begin
    file_handle = File.open(filepath, "r")
    template = file_handle.read
  rescue => e
    puts "#{filepath} open failed #{e}"
  end

  erb = ERB.new(template, nil, '-')
  result = erb.result(binding)
  outfile = nil
  if params['o']
    outfile = params['o']
  else
    outfile = "#{filename}#{t}.rb"
  end

  if /impl/ =~ t and File.exists? outfile
    puts "Implementation file already exist, I won't overwrite."
    puts "If you want to initialize it, delete '#{outfile}'"
  else
    File.open(outfile, "w").write(result)
    puts "wrote file #{outfile}"
  end
}
