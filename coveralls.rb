#!/usr/bin/env ruby

##
# Copyright (c) 2013, Oliver Drobnik
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice, this
# list of conditions and the following disclaimer in the documentation and/or
# other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
##

require 'etc'
require 'fileutils'
require 'find'
require 'optparse'

# arraw of source subfolders to exclude
excludedFolders = []
extensionsToProcess = []
coveralls_cmd = "coveralls"

excludeHeaders = false

# create option parser
opts = OptionParser.new
opts.banner = "Usage: coveralls.rb [options]"

opts.on('-e', '--exclude-folder FOLDER', 'Folder to exclude') do |v|
    excludedFolders << v
    coveralls_cmd.concat(" -e #{v}")
end

opts.on('-h', '--exclude-headers', 'Ignores headers') do |v|
    excludeHeaders = true
end

opts.on('-x', '--extension EXT', 'Source file extension to process') do |v|
    extensionsToProcess << v
    coveralls_cmd.concat(" -x #{v}")
end

opts.on_tail("-?", "--help", "Show this message") do
    puts opts
    exit
end

# parse the options
begin
    opts.parse!(ARGV)
    rescue OptionParser::InvalidOption => e
    puts e
    puts opts
    exit(1)
end

# the folders
workingDir = Dir.getwd
derivedDataDir = "#{Etc.getpwuid.dir}/Library/Developer/Xcode/DerivedData/"
outputDir = workingDir + "/gcov"

# create gcov output folder
FileUtils.mkdir outputDir

# pattern to get source file from first line of gcov file
GCOV_SOURCE_PATTERN = Regexp.new(/Source:(.*)/)

# enumerate all gcda files underneath derivedData
Find.find(derivedDataDir) do |gcda_file|
    
    if gcda_file.match(/\.gcda\Z/)
        
        #get just the folder name
        gcov_dir = File.dirname(gcda_file)
        
        # cut off absolute working dir to get relative source path
        relative_input_path = gcda_file.slice(derivedDataDir.length, gcda_file.length)
        puts "\nINPUT: #{relative_input_path}"
        
        #process the file
        result = %x( gcov '#{gcda_file}' -o '#{gcov_dir}' )
        
        # filter the resulting output
        Dir.glob("*.gcov") do |gcov_file|
            
            firstLine = File.open(gcov_file).readline
            match = GCOV_SOURCE_PATTERN.match(firstLine)
            
            if (match)
                
                source_path = match[1]
                
                puts "source: #{source_path} - #{workingDir}"
                
                if (source_path.start_with? workingDir)
                    
                    # cut off absolute working dir to get relative source path
                    relative_path = source_path.slice(workingDir.length+1, source_path.length)
                    
                    extension = File.extname(relative_path)
                    extension = extension.slice(1, extension.length-1)
                    
                    puts "#{extension}"
                    
                    # get the path components
                    path_comps = relative_path.split(File::SEPARATOR)
                    
                    shouldProcess = false
                    exclusionMsg =""
                    
                    if (excludedFolders.include?(path_comps[0]))
                        exclusionMsg = "excluded via option"
                        else
                        if (excludeHeaders == true && extension == 'h')
                            exclusionMsg = "excluded header"
                            else
                            if (extensionsToProcess.count == 0 || extensionsToProcess.include?(extension))
                                shouldProcess = true
                                else
                                exclusionMsg = "excluded extension"
                                shouldProcess = false
                            end
                        end
                    end
                    
                    if (shouldProcess)
                        puts "   - process: #{relative_path}"
                        FileUtils.mv(gcov_file, outputDir)
                        else
                        puts "   - ignore:  #{relative_path} (#{exclusionMsg})"
                        FileUtils.rm gcov_file
                    end
                    else
                    puts "   - ignore:  #{gcov_file} (outside source folder)"
                    FileUtils.rm gcov_file
                end
            end
        end
    end
end

#call the coveralls, exclude some files
system coveralls_cmd

#clean up
FileUtils.rm_rf outputDir