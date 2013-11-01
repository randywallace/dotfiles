#!/usr/bin/env ruby
 
require 'rubygems' # 1.8.7
require 'optparse'
require 'json'

options = Hash.new
options[:color] = false

optparse = OptionParser.new do |opts|

  opts.banner = "Usage: <process outputting JSON> | json.rb [options]"

  opts.on '-h', '--help', 'This Help Message' do
    puts opts
    exit
  end

  opts.on '-c', '--color', 'Colorize the output' do
    options[:color] = true
  end

  opts.on '-d DATA', '--data DATA', 'Ruby Array notation to retrieve data' do |data|
    options[:data] = data
  end

  if STDIN.tty?
    puts opts
    exit
  end
end

optparse.parse!

input = JSON.parse(STDIN.read)

if options.key? :data
  eval "puts input#{options[:data]}"
  exit
end

if options[:color] == true
  require 'awesome_print'
  ap input
else
  puts JSON.pretty_generate input
end
