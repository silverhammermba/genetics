#!/usr/bin/env ruby

path = File.dirname($0)
['gene'].each { |dependency| require File.join('.', *path, dependency) }

g1 = Gene.new *Array.new(2) { Alele::pool.sample }
g2 = Gene.new *Array.new(2) { Alele::pool.sample }
g3 = g1 + g2

puts g1
puts g2
puts g3
