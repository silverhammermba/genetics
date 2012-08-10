#!/usr/bin/env ruby

path = File.dirname($0)
['gene', 'person'].each { |dependency| require File.join('.', *path, dependency) }

g1 = Person.sample
g2 = Person.sample
g3 = g1 + g2

puts g1
puts g2
puts g3
