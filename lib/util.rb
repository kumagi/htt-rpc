require 'fileutils'

module Kantera

  # prepare directory
  def make_dir(path)
    if File.exists? path
      if File.directory? path
        puts "output directory #{path} is already exists"
      else
        puts "output #{path} is already exists as file, not directory"
        puts "rename or delete #{path}"
        exit 1
      end
    else
      FileUtils.mkdir_p path
    end
  end

end
