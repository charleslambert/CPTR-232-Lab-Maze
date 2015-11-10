#!/usr/bin/env ruby

class MazeGenerator
	attr_accessor :grid

	def initialize(openings, width, height)
		@grid = Array.new(height) { Array.new(width) {" "}}

		edgeWalls(openings, width, height)
		#chamberDiv(0,width-1,0,height-1, 3)
		
		@grid[1][0] = " "
		growingTree(width,height)
		
		toFile("testfile.txt")
		
		growingTree(width,height)
	end

	def edgeWalls(openings, width, height)
		for i in 0..width-1
			@grid[0][i] = "w"
			@grid[height-1][i] = "w"
		end
		for i in 0..height-1
			@grid[i][0] = "w"
			@grid[i][width-1] = "w"
		end
	end

	def chamberDiv(x1,x2,y1,y2,minSize)
		if ((x2-x1) > minSize) and ((y2-y1) > minSize)
			#cut the chamber into four subchambers
			xran = rand((x1+1)...x2)
			yran = rand((y1+1)...y2)
			for i in y1..y2
				@grid[i][xran] = "w"
			end
			for	i in x1..x2
				@grid[yran][i] = "w"
			end
	
			#cut an opening into the walls created
			xran2 = rand((x1+1)...x2)
			yran2 = rand((y1+1)...y2)
			if xran2 != xran
				@grid[yran][xran2] = " "
			else
				@grid[yran][xran2+1] = " "
			end
			if yran != yran2
				@grid[yran2][xran] = " "
			else
				@grid[yran2+1][xran] = " "
			end
			chamberDiv(x1,xran,y1,yran,minSize)
			chamberDiv(x1,xran,yran,y2,minSize)
			chamberDiv(xran,x2,y1,yran,minSize)
			chamberDiv(xran,x2,yran,y2,minSize)
		end
	end

	def growingTree(width,height)
		x, y = rand(1...width), rand(1...height)
	end

	def print
		puts @grid.map {|row| row.join("")}
	end

	def toFile(filename)
		fp = File.open(filename, "w")
		fp.puts @grid.map {|row| row.join("")}
		fp.close
	end
end


MazeGenerator.new(1,10,10)