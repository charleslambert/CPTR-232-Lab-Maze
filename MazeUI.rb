#!/usr/bin/env ruby

require_relative "MyWidgets.rb"
require 'Qt'

class MazeUI < Qt::Widget


	def initialize
		super

		setWindowTitle("MyMaze")

		initUI
		connections

		setFixedSize(720,480)
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
		@bFS = Qt::PushButton.new("Breadth First Search")
		@dFS = Qt::PushButton.new("Depth First Search")
		@bFS.checkable = true
		@dFS.checkable = true
		@bFS.checked = true
		Qt::ButtonGroup.new(self) do |i|
			i.addButton(@bFS)
			i.addButton(@dFS)
		end
		@mazeWin = MazeWindow.new(80,80)
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
	end
end