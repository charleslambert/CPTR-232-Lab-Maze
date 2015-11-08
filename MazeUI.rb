#!/usr/bin/env ruby

require_relative "MyWidgets.rb"
require 'Qt'

class MazeUI < Qt::Widget


	def initialize
		super

		setWindowTitle("MyMaze")

		initUI
		connections

		resize(720,480)
		move(300,300)

		show
	end

	def initUI
		mazeWin = MazeWindow.new
	end

	def connections
	end
end