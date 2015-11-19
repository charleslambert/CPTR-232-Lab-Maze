require 'Qt'
require_relative "Graph.rb"

class MazeWindow < Qt::Widget
	attr_accessor :maze, :graph

	slots('paintGraph()', 'onTimeout()')
	def initialize(maze = nil)
		super()

		@maze = maze
		@scale = 7
    	height = 80
    	width = 80
		makeGraph(@maze)
		@timer = Qt::Timer.new
		@timer.interval = 0
		connections

		setFixedSize(width*@scale, height*@scale)
	end

	def connections
		connect(@timer, SIGNAL('timeout()'), self, SLOT(:onTimeout))
	end

	def paintEvent(event)
	    painter = Qt::Painter.new(self)
	    drawShapes(painter)
	    painter.end
	end
	
	def drawShapes(painter)
		update()
		painter.setRenderHint Qt::Painter::Antialiasing
	  	if @maze
			for i in 0...@maze.length
	    		for j in 0..@maze[0].length
	    	  		case @maze[i][j]
	    	  		when "w"
	    	   			painter.setBrush Qt::Brush.new(Qt::black)
	    	   			painter.drawRect(j*@scale,i*@scale,@scale,@scale)
	    	  		when "g"
	    	   			painter.setBrush Qt::Brush.new(Qt::green)
	    	   			painter.drawRect(j*@scale,i*@scale,@scale,@scale)
	    	  		when "b"
	    	  			painter.setBrush Qt::Brush.new(Qt::blue)
	    	  			painter.drawRect(j*@scale,i*@scale,@scale,@scale)
	    	  		when "G"
	    	   			painter.setBrush Qt::Brush.new(Qt::gray)
	    	   			painter.drawRect(j*@scale,i*@scale,@scale,@scale)
	    	  		when "r"
	    	   			painter.setBrush Qt::Brush.new(Qt::red)
	    	   			painter.drawRect(j*@scale,i*@scale,@scale,@scale)
	    	  		end
	    		end
	  		end
		end
	end


	def setMaze(maze)
		@maze = maze
		@graph = Graph.new(maze)
	end

	def makeGraph(maze)
		if maze
			@graph = Graph.new(maze)
		end
	end

	def paintGraph
		if @graph
			@graph.vertexs.values.each do |node|
			 	@maze[node.posy][node.posx] = node.color
			end
		end
	end

	def solve(type,maze)
		@searchTime = Fiber.new {
			@graph.solve(type,maze) {|g| 
				paintGraph
				Fiber.yield
			}
		}
		@timer.start
	end

	def onTimeout
		begin
			@searchTime.resume
		rescue FiberError
			@timer.stop
		end
	end

	def setDelay(interval)
		@timer.interval = interval
	end
end