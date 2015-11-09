require 'Qt'
require_relative "MazeGenerator.rb"

class MazeWindow < Qt::Widget

	def initialize(width, height)
		super()

    @scale = 5
    @height = height
    @width  = width 

		initUI

		setFixedSize(width*@scale,height*@scale)
    @grid = MazeGenerator.new(1,80,80)

		show
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
      for i in 0...@grid.grid.length
        for j in 0..@grid.grid[0].length
          if @grid.grid[i][j] == "w"
            painter.drawRect(i*@scale,j*@scale,@scale,@scale)
          end
        end
      end
    end
end

