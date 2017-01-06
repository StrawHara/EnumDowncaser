#!/usr/bin/env ruby

unless ARGV.count >= 2
  puts "Usage: #{File.basename(__FILE__)} ProjectName EnumPrefix."
  exit 1
end

require 'find'

project_name = ARGV[0]
prefix = ARGV[1]

pathes = []
# Find.find("/tmp") do |f|

Find.find("#{project_name}") do |path|
  pathes << path unless FileTest.directory?(path)
end

sorted_pathes = []
pathes.each do |path|
  if path[-6, 6] == ".swift"
    sorted_pathes << path
  end
end

total_downcased = 0

sorted_pathes.each do |path|

  file = File.open(path, "r")
  file_content = file.read()

  new_content = ""
  downcased = 0

  file_content.each_line do |line|
    index = line.index(prefix)
    if index.is_a? Integer
      line[index + prefix.length] = line[index + prefix.length].downcase
      downcased += 1
    end
    new_content << line
  end

  total_downcased += downcased
  downcased = 0
  file = File.open(path, "w")
  file.puts new_content

end

puts "#{total_downcased} downcased entities"
