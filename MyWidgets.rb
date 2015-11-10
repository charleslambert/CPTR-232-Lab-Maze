require 'Qt'
#require_relative "MazeGenerator.rb"

class MazeWindow < Qt::Widget
  attr_accessor :maze
	def initialize
		super

    @maze = nil
    @scale = 7
    height = 80
    width = 80

		initUI

		setFixedSize(width*@scale,height*@scale)

	end

	def initUI
	end

	def paintEvent(event)
          painter = Qt::Painter.new(self)
          drawShapes(painter)
          painter.end
    end

    def drawShapes(painter)
    	update()
    	painter.setRenderHint Qt::Painter::Antialiasing
    	painter.setBrush Qt::Brush.new Qt::Color.new(150,150,150)
      if @maze
        for i in 0...@maze.length
          for j in 0..@maze[0].length
            if @maze[i][j] == "w"
              painter.drawRect(j*@scale,i*@scale,@scale,@scale)
            end
          end
        end
      end
    end
end

