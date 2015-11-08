require 'Qt'

class MazeWindow < Qt::Widget

	def initialize(width, height)
		super()

    @scale = 5
    @height = height
    @width  = width 

		initUI

		setFixedSize(width*@scale,height*@scale)

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
        painter.drawRect(0,0,@scale,@scale)
    end
end

