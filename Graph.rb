SGraph = Struct.new(:vertexs,:edges, :maze)
Node = Struct.new(:posx, :posy, :dist, :color, :parent)

N = [0,1]
S = [0,-1]
E = [1,0]
W = [-1,0]

class Graph
	attr_reader :vertexs, :edges, :maze
	def initialize(maze)
		@graph = SGraph.new(makeVertexs(maze),makeEdges(maze), maze)
		@vertexs = @graph.vertexs
		@edges = @graph.edges
		@maze = maze
	end

	def makeVertexs(maze)
		vertexs = {}
		for y in (0...maze.length)
			for x in (0...maze[0].length)
				if maze[y][x] == " "
					vertexs["#{x},#{y}".to_sym] = Node.new(x, y, 0, " ", nil)
				end
			end
		end
		return vertexs
	end

	def makeEdges(maze)
		edges = {}
		for y in (0...maze.length)
			for x in (0...maze[0].length)
				if maze[y][x] == " "
					edges["#{x},#{y}".to_sym] = []
				end
			end
		end

		for y in (0...maze.length)
			for x in (0...maze[0].length)
				[S,E,W,N].each do |dir|
					dx = dir[0]
					dy = dir[1]
					if checkPos(x,y,dx,dy,maze)
						edges["#{x},#{y}".to_sym].push([x+dx,y+dy])
					end
				end
			end
		end

		return edges
	end

	def checkPos(x, y, dx, dy, maze)
		(y+dy).between?(0,(maze.length-1)) && (x+dx).between?(1,(maze[0].length-1)) && maze[dy+y][dx+x] == " " && maze[y][x] == " "
	end
end