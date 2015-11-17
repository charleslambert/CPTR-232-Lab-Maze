#Node = Struct.new(:posx, :posy, :dist, :parent)
#
#N = [0,1]
#S = [0,-1]
#E = [1,0]
#W = [-1,0]

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
			yield g
		end
		return u
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
			# u color set to Black
			u.color = "b"
			yield g
		end
		return u
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
