
N, S, E, W = 1, 2, 3, 4
NE, SW= 5, 6
NW, SE= 9, 10
DX         = { E => 1, W => -1, N =>  0, S => 0, NE => 1, SW => -1, NW => -1, SE => 1}
DY         = { E => 0, W =>  0, N => -1, S => 1, NE => -1, SW => 1, NW => -1, SE => 1}
OPPOSITE   = { E => W, W =>  E, N =>  S, S => N }
OPP1	   = {N => NW, S => SW, E => SE, W => SW}
OPP2	   = {N => NE, S => SE, E => NE, W => NW}

class GrowingTree
	attr_accessor :grid

	def initialize(width,height)
		#create grid of unvisited cells
		@width, @height = width, height
		@grid = Array.new(@height) {Array.new(@width) {"?"}}

		print "\e[2J"
		sleep 0.02
		run(@width, @height)
		setWall
	end

	def run(width, height)
		x, y = rand(1...width-1), rand(1...height-1)
		cells = []

		cells << [x,y]

		until cells.empty?
			#select
			index = cells.length-1

 			x, y = cells[index]
 			[N,S,E,W].shuffle(random: Random.new(Math::PI)).each do |dir|
 				dx, dy = x+DX[dir], y+DY[dir]

 				if dx > 0 && dx < @width-1 && dy > 0 && dy < @height-1 && @grid[dy][dx] == "?" && check(dir, dx, dy)
 					@grid[y][x] = " "
 					@grid[dy][dx] = " "
 					cells << [dx,dy]
 					index = nil

 					myPrint
 					sleep 0.02

 					break
 				end
 			end
 			cells.delete_at(index) if index
 		end
 		myPrint
	end

	def check(dir, x, y)

		status = []
		[N,S,E,W,NE,NW,SW,SE].each {|d| 
			if d != OPPOSITE[dir] &&  d != OPP1[OPPOSITE[dir]] && d != OPP2[OPPOSITE[dir]]
				dx, dy = x+DX[d],y+DY[d]
				if @grid[dy][dx] == "?"
					status << true
				else
					status << false
				end
			end
		}
		if status.include?(false)
			return false
		else
			return true
		end
	end

	def myPrint
		puts @grid.map {|row| row.join("")}
	end

	def setWall
	 	for y in 0...@height
	 		for x in 0...@width
	 			if @grid[y][x] == "?"
	 				@grid[y][x] = "w"
	 			end
	 		end
	 	end
	end
end