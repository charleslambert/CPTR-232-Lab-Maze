Node = Struct.new(:posx, :posy, :dist, :color, :parent)

N = [0,1]
S = [0,-1]
E = [1,0]
W = [-1,0]

class Graph
	attr_reader :vertexs, :edges, :maze
	def initialize(maze)
		@vertexs = self.class.makeVertexs(maze)
		@edges = self.class.makeEdges(maze)
		@maze = maze
	end

	def self.makeVertexs(maze)
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

	def self.makeEdges(maze)
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

	def self.checkPos(x, y, dx, dy, maze)
		(y+dy).between?(0,(maze.length-1)) && 
		(x+dx).between?(1,(maze[0].length-1)) && 
		maze[dy+y][dx+x] == " " && maze[y][x] == " "
	end

	def solve(type, maze)
		s = findStart(maze.m)

		if type == :bFS
			self.bFS(self,s) {yield}
		elsif type == :dFS
			self.dFS(self,s) {yield}
		end
	end

	def findStart(maze)
		for i in 1...maze[0].length
			if maze[0][i] != "w"
				s = self.vertexs["#{i},#{0}".to_sym]
				break
			end
		end

		return s
	end

	def dFS(g, s)

		clearGraph(g)

		s.color = "g"
		q = []
		q.push(s)
		yield

		until q.empty?
			#dequeue u
			u = q.pop
			#check vertices around u
			[S,E,W,N].each do |dir|
				x = dir[0]
				y = dir[1]
				#and if not visted set to gray
				#enquege v
				if checkVisit(u.posx,u.posy,x,y,g)
					visist(x,y,u,g) {|v| q.push(v)}
					yield
				end
			end
			# u color set to Blue
			u.color = "b"
			nowEnd = checkEnd(g, u, q)
			yield

			break if nowEnd
		end
	end

	def bFS(g, s)
		
		clearGraph(g)

		s.color = "g"
		q = Queue.new
		q.enqueue(s)
		yield
		#iterate through queue
		until q.empty
			#dequeue u
			u = q.dequeue
			#check vertices around u
			[S,E,W,N].shuffle.each do |dir|
				x = dir[0]
				y = dir[1]
		
				if checkVisit(u.posx,u.posy,x,y,g)
					visist(x,y,u,g) {|v| q.enqueue(v)}
					yield
				end
			end
			
			u.color = "b"
			nowEnd = checkEnd(g, u, q.que)
			yield

			break if nowEnd
		end
	end

	def clearGraph(g)
		g.vertexs.values.each do |v|
			v.color = " "
		end
	end

	def visist(dx,dy,u,g)
		v = g.vertexs["#{dx+u.posx},#{dy+u.posy}".to_sym]
		v.dist = u.dist + 1
		v.parent = u
		v.color = "g"
		yield v
	end		


	def checkVisit(x,y,dx,dy,g)
		return g.edges["#{x},#{y}".to_sym].include?([dx+x,dy+y]) && g.vertexs["#{dx+x},#{dy+y}".to_sym].color == " "
	end

	def checkEnd(g, node, q)
		if node.posy == g.maze.length-1
			correctRoute(node, q, g)
			foundEnd = true
		elsif endPath(g, node)
			dacPath(node, q, g)
			foundEnd = false
		end

		return foundEnd
	end

	def dacPath(node, q, g)
		until node == nil or checkActive(node, g)
			node.color = "G"
			node = node.parent
		end
	end

	def correctRoute(node, q, g)
		q.each do |n|
			dacPath(n, q, g)
			n.color = "G"
		end
		(node.dist+1).times do 
			node.color = "r"
			node = node.parent
		end
	end

	def checkActive(node, g)
		t = 0
		g.edges["#{node.posx},#{node.posy}".to_sym].each do |n|
			if g.vertexs["#{n[0]},#{n[1]}".to_sym].color != "G"
				t += 1
			end
		end
		if t > 1
			return true
		else  
			return false
		end
	end

	def endPath(g, node)
		if g.edges["#{node.posx},#{node.posy}".to_sym].count == 1 && node.posy != 0
			return true
		else
			return false
		end
	end
end

class Queue
	attr_reader :que
	def initialize
		@que =[]
	end

	def enqueue(value)
		@que.unshift(value)
	end

	def dequeue
		return @que.pop
	end

	def empty
		return @que.empty?
	end
end

