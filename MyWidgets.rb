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

class DropDownMenu < Qt::Widget
  def initialize(buttonName, *actions)
    super()

    button = Qt::PushButton.new("#{buttonName}",self)
    menu = Qt::Menu.new(self)
    actions.each do |action|
      menu.addAction("#{action}")
    end
    button.menu = menu
  end
end