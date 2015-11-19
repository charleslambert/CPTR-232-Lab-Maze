require_relative "GrowingTree.rb"

class Maze 
	attr_reader :m, :height, :width
	def initialize(string = nil)

		@m = to_m(string)
			
		if @m
			@height = @m.length
			@width  = @m[0].length
		else
			@heigt = nil
			@width = nil
		end
	end

	def set_m(string)
		@m = to_m(string)
	end

	def to_m(string)
	#convert string into 2d array rep of maze
		m = []
		if string
			string.each_line {|line|
				m << line.chomp.split("")
			}
		else
			m = nil
		end

		return m
	end

	def to_s(maze)
	#convert 2d array rep of maze to a string
		return maze.map{|row| row.join("")}
	end

	def generate(x,y,type)
		if x > 80
			x = 80
		elsif y > 80
			y = 80
		end

		if x < 5
			x = 5
		elsif y < 5
			y = 5
		end

		@m = GrowingTree.new(x,y,type).maze
	end
end
