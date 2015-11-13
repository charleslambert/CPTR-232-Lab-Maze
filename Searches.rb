Node = Struct.new(:posx, :posy, :dist, :parent)
N = [0,1]
S = [0,-1]
E = [1,0]
W = [-1,0]

class Solver

	def nodeMap(mArray)
		nMap = Hash.new

		for y in (0...mArray.length)
			for x in (0...mArray.first.length)
				if mArray[y][x] == " "
					nMap["#{x},#{y}".to_sym] = Node.new(x, y, 0, nil)
				end
			end
		end

		return nMap
	end

	def dFS(g, m, s)
		#clear the Setup G
		#all vertexs set to white
		clearGraph(g)

		#set begining vertex s
		s = m[s]
		g[s.posy][s.posx] = "g"
		#enqueue s
		q = []
		q.push(s)
		yield
		#iterate through queue
		until q.empty?
			#dequeue u
			u = q.pop
			#check vertices around u
			[S,E,W,N].each do |dir|
				x = dir[0]
				y = dir[1]
				#and if not visted set to gray
				#enquege v
				if checkPos(u.posx, u.posy, x, y, g)
					v = m["#{x+u.posx},#{y+u.posy}".to_sym]
					v.dist = u.dist + 1
					v.parent = u
					g[v.posy][v.posx] = "g"
					q.push(v)
					yield
				end
			end
			# u color set to Black
			g[u.posy][u.posx] = "b"
		end
		return u
	end

	
	def bFS(g, m, s)
		#clear the Setup G
		#all vertexs set to white
		clearGraph(g)
		#set begining vertex s
		s = m[s]
		g[s.posy][s.posx] = "g"
		#enqueue s
		q = Queue.new
		q.enqueue(s)
		yield
		#iterate through queue
		until q.empty
			#dequeue u
			u = q.dequeue
			#check vertices around u
			[S,E,W,N].each do |dir|
				x = dir[0]
				y = dir[1]
				#and if not visted set to gray
				#enquege v
				if checkPos(u.posx, u.posy, x, y, g)
					v = m["#{x+u.posx},#{y+u.posy}".to_sym]
					v.dist = u.dist. + 1
					v.parent = u
					g[v.posy][v.posx] = "g"
					q.enqueue(v)
					yield
				end
			end
			# u color set to Black
			g[u.posy][u.posx] = "b"
		end
		return u
	end

	def checkPos(x, y, dx, dy, g)
		(y+dy).between?(0,(g.length-1)) && (x+dx).between?(1,(g[0].length-1)) && g[dy+y][dx+x] == " "
	end
	
	def clearGraph(g)
		g.map! {|row| row.map! {|elem| if elem != "w" then elem = " " else elem = "w" end}}
	end
end

class Queue
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
