#!/usr/bin/env ruby

require_relative "MyWidgets.rb"
require_relative "MazeGenerator.rb"
require 'Qt'

class MazeUI < Qt::Widget

	slots('fileRead()','primms()','backtrack()','oldest()','writeFile()')

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
		@generator = MazeGenerator.new
	end

	def widgets
		@file = MyValueBox.new("File:")
		@delay = MyValueBox.new("Delay:")
		@wGen = MyValueBox.new("Width:")
		@hGen = MyValueBox.new("Height:")
		@export = Qt::PushButton.new("Export")
		@dropDownButton = Qt::PushButton.new("Type",self)
		@primms = Qt::Action.new("Primms", @dropDownButton)
		@backTrack = Qt::Action.new("Backtrack",@dropDownButton)
		@oldest = Qt::Action.new("Oldest",@dropDownButton)
    	@menu = Qt::Menu.new(@dropDownButton) do |i|
    		i.addAction(@primms)
    		i.addAction(@backTrack)
    		i.addAction(@oldest)
    	end
    	@dropDownButton.menu = @menu
		@import = Qt::PushButton.new("Import")
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
		mazeGen = Qt::HBoxLayout.new do |i|
			i.addWidget(Qt::Label.new("Generate Maze"))
			i.addWidget(@wGen)
			i.addWidget(@hGen)
			i.addWidget(@dropDownButton)
		end

		mazeRead = Qt::HBoxLayout.new do |i|
			i.addWidget(@import)
			i.addWidget(@export)
			i.addWidget(@file)
		end

		runMaze = Qt::HBoxLayout.new do |i|
			i.addWidget(@rMaze)
			i.addWidget(@rrMaze)
			i.addWidget(@delay)
		end

		searchMode = Qt::HBoxLayout.new do |i|
			i.addWidget(@bFS)
			i.addWidget(@dFS)
		end

	

		Qt::VBoxLayout.new(self) do |i|
			i.addLayout(mazeGen)
			i.addLayout(mazeRead)
			i.addLayout(runMaze)
			i.addLayout(searchMode)
			i.addWidget(@mazeWin)
		end
	end

	def connections
		connect(@import, SIGNAL('clicked()'), self, SLOT(:fileRead))
		connect(@export, SIGNAL('clicked()'), self, SLOT(:writeFile))
		connect(@primms, SIGNAL('triggered()'), self, SLOT(:primms))
		connect(@oldest, SIGNAL('triggered()'), self, SLOT(:oldest))
		connect(@backTrack, SIGNAL('triggered()'), self, SLOT(:backtrack))
	end

	def generate(open, x, y, type)
		if x != 0 && y != 0
			puts [x,y]
			@generator.generate(1, x, y, type)
			maze = @generator.grid
			@mazeWin.maze = maze
			@mazeWin.repaint()
		end
	end

	def primms()
		generate(1, @wGen.value.to_i, @hGen.value.to_i, "Primms")
	end

	def oldest()
		generate(1, @wGen.value.to_i, @hGen.value.to_i, "Oldest")
	end

	def backtrack()
		generate(1, @wGen.value.to_i, @hGen.value.to_i, "Backtrack")
	end

	def fileRead()
		if @file.value != ""
			@maze = []
			file = File.open("#{@import.value}", 'r')
			file.each_line {|line|
				@maze << line.chomp.split("")}
			file.close
			@mazeWin.maze = @maze
		end
	end

	def writeFile()
		if @file.value != ""
			puts @file.value
			puts "\n"
			fp = File.open(@file.value, "w")
			fp.puts @mazeWin.maze.map {|row| row.join("")}
			fp.close
		end
	end
end