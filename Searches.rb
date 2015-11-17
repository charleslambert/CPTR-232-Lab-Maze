class Solver

	def dFS(g, s)

		#set begining vertex s
		s.color = "g"
		#enqueue s
		q = []
		q.push(s)
		yield g
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
				if g.edges["#{u.posx},#{u.posy}".to_sym].include?([x+u.posx,y+u.posy]) && g.vertexs["#{x+u.posx},#{y+u.posy}".to_sym].color == " "
					v = g.vertexs["#{x+u.posx},#{y+u.posy}".to_sym]
					v.dist = u.dist + 1
					v.parent = u
					v.color = "g"
					q.push(v)
					yield g
				end
			end
			# u color set to Black
			u.color = "b"
			nowEnd = checkEnd(g, u, q)
			yield g

			if nowEnd
				break
			end
		end
	end

	def bFS(g, s)
		#set begining vertex s
		s.color = "g"
		#enqueue s
		q = Queue.new
		q.enqueue(s)
		yield g
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
				if g.edges["#{u.posx},#{u.posy}".to_sym].include?([x+u.posx,y+u.posy]) && g.vertexs["#{x+u.posx},#{y+u.posy}".to_sym].color == " "
					v = g.vertexs["#{x+u.posx},#{y+u.posy}".to_sym]
					v.dist = u.dist + 1
					v.parent = u
					v.color = "g"
					q.enqueue(v)
					yield g
				end
			end
			# u color set to Blue
			u.color = "b"
			nowEnd = checkEnd(g, u, q.que)
			yield g

			if nowEnd
				break
			end
		end
	end

	def checkEnd(g, node, q)
		if node.posy == g.maze.length-1
			correctRoute(node, q)
			foundEnd = true
		elsif endPath(g, node)
			dacPath(node, q)
			foundEnd = false
		end

		return foundEnd
	end

	def dacPath(node, q)
		until not node or q.include?(node)
			node.color = "G"
			node = node.parent
		end
	end

	def correctRoute(node, q)
		q.each do |n|
			dacPath(n, q)
			n.color = "G"
		end
		(node.dist+1).times do 
			node.color = "r"
			node = node.parent
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
