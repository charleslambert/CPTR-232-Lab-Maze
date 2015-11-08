require 'Qt'

class MazeWindow < Qt::Widget

	def initialize
		super

		initUI

		setFixedSize(80,80)

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
        painter.drawRect(0,0,5,5)
    end
end

