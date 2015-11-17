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
end

class MyValueBox < Qt::Widget
  def initialize(label)
    super()

    @label = Qt::Label.new(label, self)
    @box = Qt::LineEdit.new(self)

    hbox = Qt::HBoxLayout.new(self) do |i|
        i.addWidget(@label)
        i.addWidget(@box)
    end
  end

  def value(*set)
    case set.length
    when 0
      value = @box.text
      return value
    when 1
      set = set.first
      @box.text = set
    end
  end
end