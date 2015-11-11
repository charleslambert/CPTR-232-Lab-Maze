Node = Struct.new(:posx, :posy, :dist, :parent)
N = [0,1]
S = [0,-1]
E = [1,0]
W = [-1,0]

class Solver
	def initialize(disWindow)
		@disWindow = disWindow
	end

	def dFS(g, sx, sy, time)
		#clear the Setup G
		#all vertexs set to white
		g.map! {|row| row.map! {|elem| if elem != "w" then elem = " " else elem = "w" end}}

		#set begining vertex s
		s = Node.new
		s[:posx] = sx
		s[:posy] = sy
		g[s[:posy]][s[:posx]] = "g"
		s[:dist] = 0
		s[:parent] = nil
		#enqueue s
		q = []

		q.push(s)
		if time
			@disWindow.repaint()
			sleep(time)
		end
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
				if checkPos(u[:posx],u[:posy], x, y,g) && g[y+u[:posy]][x+u[:posx]] == " "
					v = Node.new
					v[:posx] = x+u[:posx]
					v[:posy] = y+u[:posy]
					g[v[:posy]][v[:posx]] = "g"
					v[:dist] = u[:dist] + 1
					v[:parent] = u
					q.push(v)
					if time
						@disWindow.repaint()
						sleep(time)
					end
				end
			end
			# u color set to Black
			g[u[:posy]][u[:posx]] = "b"
		end
		
	end

	def bFS(g, sx, sy, time)
		#clear the Setup G
		#all vertexs set to white
		g.map! {|row| row.map! {|elem| if elem != "w" then elem = " " else elem = "w" end}}

		#set begining vertex s
		s = Node.new
		s[:posx] = sx
		s[:posy] = sy
		g[s[:posy]][s[:posx]] = "g"
		s[:dist] = 0
		s[:parent] = nil
		#enqueue s
		q = Queue.new

		q.enqueue(s)
		if time
			@disWindow.repaint()
			sleep(time)
		end
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
				if checkPos(u[:posx],u[:posy], x, y,g) && g[y+u[:posy]][x+u[:posx]] == " "
					v = Node.new
					v[:posx] = x+u[:posx]
					v[:posy] = y+u[:posy]
					g[v[:posy]][v[:posx]] = "g"
					v[:dist] = u[:dist] + 1
					v[:parent] = u
					q.enqueue(v)
					if time
						@disWindow.repaint()
						sleep(time)
					end
				end
			end
			# u color set to Black
			g[u[:posy]][u[:posx]] = "b"
		end
	end

	def checkPos(x, y, dx, dy,g)
		(y+dy).between?(0,(g.length-1)) && (x+dx).between?(1,(g[0].length-1))
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
