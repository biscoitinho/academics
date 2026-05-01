require_relative 'koans'
require_relative 'about_truthiness'
require_relative 'about_symbols'
require_relative 'about_strings'
require_relative 'about_hashes'
require_relative 'about_data_structures'
require_relative 'about_enumerables'
require_relative 'about_blocks'
require_relative 'about_oop'
require_relative 'about_modules'

puts "\nRuby Koans — path to enlightenment"
puts "Source: documentation in ruby/"
puts "Usage:  replace __ with the correct value, then run again\n"

Koans::Runner.run
