#!/usr/bin/env ruby

require_relative "MyWidgets.rb"
require_relative "MazeGenerator.rb"
require 'Qt'

class MazeUI < Qt::Widget

	slots('fileRead()')

	def initialize
		super

		setWindowTitle("MyMaze")

		initUI
		connections

		move(300,300)

		show
	end

	def initUI
		widgets
		layout
	end

	def widgets
		@file = Qt::LineEdit.new
		@delay = Qt::LineEdit.new
		@dLabel = Qt::Label.new("Delay")
		@cMaze = Qt::PushButton.new("initialize Maze")
		@rMaze = Qt::PushButton.new("Run Maze")
		@rrMaze = Qt::PushButton.new("Rerun Maze")
		@rrMaze.enabled = false
		@bFS = Qt::PushButton.new("Breadth First Search")
		@dFS = Qt::PushButton.new("Depth First Search")
		@bFS.checkable = true
		@dFS.checkable = true
		@bFS.checked = true
		Qt::ButtonGroup.new(self) do |i|
			i.addButton(@bFS)
			i.addButton(@dFS)
		end
		@mazeWin = MazeWindow.new
	end

	def layout
		vbox1 = Qt::VBoxLayout.new do |i|
			i.addWidget(@file)
			i.addWidget(@cMaze)
			i.addWidget(@rMaze)
			i.addWidget(@bFS)
		end

		vbox2 = Qt::VBoxLayout.new do |i|
			i.addWidget(@delay)
			i.addWidget(@dLabel)
			i.addWidget(@rrMaze)
			i.addWidget(@dFS)
		end

		hbox = Qt::HBoxLayout.new do |i|
			i.addLayout(vbox1)
			i.addLayout(vbox2)
		end

		Qt::VBoxLayout.new(self) do |i|
			i.addLayout(hbox)
			i.addWidget(@mazeWin)
		end
	end

	def connections
		connect(@cMaze, SIGNAL('clicked()'), self, SLOT(:fileRead))
	end

	def fileRead()
		@maze = []
		file = File.open("#{@file.text}", 'r')

		file.each_line {|line|
			@maze << line.chomp.split("")}
		file.close
		@mazeWin.maze = @maze
	end
end