define N 1
define 

class GrowingTree
	attr_accessor :grid

	def initialize(width,height)
		@grid = Array.new(height) {Array.new(width) {"w"}}


		run(width, height)

	end

	def run(width, height)
		x, y = rand(1...width), rand(1...height)
		cells = []

		cells << [x,y]

		until cells.empty?

		index = 


	end

	
end