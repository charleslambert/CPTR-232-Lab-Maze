DX         = { :E => 1, :W => -1, :N =>  0, :S => 0, :NE => 1, :SW => -1, :NW => -1, :SE => 1}
DY         = { :E => 0, :W =>  0, :N => -1, :S => 1, :NE => -1, :SW => 1, :NW => -1, :SE => 1}
OPPOSITE   = { :E => :W, :W =>  :E, :N =>  :S, :S => :N }
OPP1	   = {:N => :NW, :S => :SW, :E => :SE, :W => :SW}
OPP2	   = {:N => :NE, :S => :SE, :E => :NE, :W => :NW}

class GrowingTree
	attr_accessor :grid

	def initialize(width, height)
		#create grid of unvisited cells
		@grid = Array.new(height) {Array.new(width) {"?"}}

		run(width, height)
		setWall(width, height)
	end

	def run(width, height)
		#add first cell to active set
		x, y = rand(1...width-1), rand(1...height-1)
		cells = []

		cells << [x,y]

		until cells.empty?
			#select
			index = 0#cells.length-1#rand(cells.length)
 			x, y = cells[index]

 			#check neighbors
 			[:N,:S,:E,:W].shuffle.each do |dir|
 				dx, dy = x+DX[dir], y+DY[dir]

 				if dx.between?(1,width-2) && dy.between?(1,height-2) && @grid[dy][dx] == "?" && check(dir, dx, dy)
 					#if neighbor is not visited add to active set
 					@grid[y][x] = " "
 					@grid[dy][dx] = " "
 					cells << [dx,dy]
 					index = nil
					break
 				end
 			end
 			#If cell has no neighbors remove the cell from the active set
 			cells.delete_at(index) if index
 		end
	end

	def check(dir, x, y)

		status = []

		#check that the cell is surrounded by unvisited cells
		[:N,:S,:E,:W,:NE,:NW,:SW,:SE].each {|d| 
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

	def setWall(width,height)
		#replace unvisited cells with walls
	 	for y in 0...height
	 		for x in 0...width
	 			if @grid[y][x] == "?"
	 				@grid[y][x] = "w"
	 			end
	 		end
	 	end
	end
end