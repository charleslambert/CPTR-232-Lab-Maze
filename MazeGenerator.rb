#!/usr/bin/env ruby

require_relative "GrowingTree.rb"

class MazeGenerator

	def initialize
		@grid = nil
	end

	def generate(openings, width, height, type)
		@grid = GrowingTree.new(width, height, type)
	end

	def Myprint
		puts @grid.map {|row| row.join("")}
	end

	def toFile(filename)
		fp = File.open(filename, "w")
		fp.puts @grid.grid.map {|row| row.join("")}
		fp.close
	end

	def grid
		return @grid.grid
	end
end