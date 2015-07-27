#!/usr/bin/env ruby

require_relative 'terminal.rb'

=begin
Scan these items in this order: ABCDABAA; Verify the total price is $32.40.
    Scan these items in this order: CCCCCCC; Verify the total price is $7.25.
    Scan these items in this order: ABCD; Verify the total price is $15.40.
=end

terminal = Terminal.new

terminal.set_pricing("regular")

puts "test one"
terminal.scan("A")
terminal.scan("B")
terminal.scan("C")
terminal.scan("D")
terminal.scan("A")
terminal.scan("B")
terminal.scan("A")
terminal.scan("A")
result = terminal.total
puts "total: #{result}"
raise "total incorrect for test 1:actual:#{result}:supposed:32.40" unless result == 32.40
terminal.new_order #reset register for new order

puts "test two"
terminal.scan("C")
terminal.scan("C")
terminal.scan("C")
terminal.scan("C")
terminal.scan("C")
terminal.scan("C")
terminal.scan("C")
result = terminal.total
puts "total: #{result}"
raise "total incorrect for test 2:actual:#{result}:supposed:7.25" unless result == 7.25

terminal.new_order #reset register for new order

puts "test three"
terminal.scan("A")
terminal.scan("B")
terminal.scan("C")
terminal.scan("D")
result = terminal.total
puts "total: #{result}"
raise "total incorrect for test 3:actual:#{result}:supposed:15.40" unless result == 15.40

terminal.new_order #reset register for new order
