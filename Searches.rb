class Solver

	def dFS(g, s)

		clearGraph(g)

		s.color = "g"
		q = []
		q.push(s)
		yield g

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
					yield g
				end
			end
			# u color set to Blue
			u.color = "b"
			nowEnd = checkEnd(g, u, q)
			yield g

			break if nowEnd
		end
	end

	def bFS(g, s)
		
		clearGraph(g)

		s.color = "g"
		q = Queue.new
		q.enqueue(s)
		yield g
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
					yield g
				end
			end
			
			u.color = "b"
			nowEnd = checkEnd(g, u, q.que)
			yield g

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
