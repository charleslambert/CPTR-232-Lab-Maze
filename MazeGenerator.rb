#!/usr/bin/env ruby

require_relative "GrowingTree.rb"

class MazeGenerator
	attr_accessor :grid

	def initialize
		@grid = nil
	end

	def generate(openings, width, height, type)
		@grid = GrowingTree.new(width, height, type)
		toFile("testfile.txt")

	end

	def Myprint
		puts @grid.map {|row| row.join("")}
	end

	def toFile(filename)
		fp = File.open(filename, "w")
		fp.puts @grid.grid.map {|row| row.join("")}
		fp.close
	end
end


MazeGenerator.new.generate(1,40,40,"Oldest")