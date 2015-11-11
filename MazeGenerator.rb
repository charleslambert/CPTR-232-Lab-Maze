#!/usr/bin/env ruby

require_relative "GrowingTree.rb"

class MazeGenerator

	def initialize
		@grid = nil
	end

	def generate(width, height, type)
		@grid = GrowingTree.new(width, height, type).grid
		addOpening(width, height)
	end

	def addOpening(width, height)
		a = []
		for i in (0..width-1)
			if @grid[1][i] == " "
				a << i
			end
		end
		@grid[0][a.sample] = " "

		a = []
		for i in (0..width-1)
			if @grid[height-2][i] == " "
				a << i
			end
		end
		@grid[height-1][a.sample] = " "
	end

	def Myprint
		puts @grid.map {|row| row.join("")}
	end

	def grid
		return @grid
	end
end