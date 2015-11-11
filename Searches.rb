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
end