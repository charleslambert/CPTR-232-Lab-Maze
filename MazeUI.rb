#!/usr/bin/env ruby

require_relative "MyWidgets.rb"
require_relative "MazeGenerator.rb"
require_relative "Searches.rb"
require_relative "Graph.rb"
require 'Qt'

class MazeUI < Qt::Widget

	slots('fileRead()','primms()','backtrack()','oldest()','writeFile()', 'solve()')

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
		@solver = Solver.new
	end

	def widgets
		#Maze generation buttons and text boxes
		@wGen = MyValueBox.new("Width:")
		@hGen = MyValueBox.new("Height:")
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

    	#file import and export buttons and text box
		@file = MyValueBox.new("File:")
		@import = Qt::PushButton.new("Import")
		@export = Qt::PushButton.new("Export")

		#Maze running buttons
		@delay = MyValueBox.new("Delay:")
		@rMaze = Qt::PushButton.new("Run Maze")
		@rrMaze = Qt::PushButton.new("Rerun Maze")
		@rrMaze.enabled = false
		
		#BFS DFS buttons
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
		connect(@rMaze, SIGNAL('clicked()'), self, SLOT(:solve))
	end

	def solve()
		#find the entrance
		@graph = Graph.new(@maze)
		puts @graph
		p @graph.vertexs.keys
		p @graph.vertexs.values
		p @graph.edges.keys
		p @graph.edges.values

		#for i in 1...@maze[0].length
		#	if @maze[0][i] == " " or @maze[0][i] == "b"
		#		s = :"#{i},#{0}"
		#		break
		#	end
		#end
#
		#if @bFS.checked == true
		#	@solver.bFS(@maze, @solver.nodeMap(@maze), s) {delay(@delay.value.to_f)}
		#else
		#	@solver.dFS(@maze, @solver.nodeMap(@maze), s) {delay(@delay.value.to_f)}
		#end
	end

	def delay(time)
		@mazeWin.repaint()
		sleep(time)
	end

	def generate(x, y, type)
		if not (x <= 4) and not (y <= 4)
			if x > 80 
				x = 80
			end
			if y > 80
				y = 80
			end
			@generator.generate(x, y, type)
			@maze = @generator.grid
			@mazeWin.maze = @maze
		end
	end

	def primms()
		generate(@wGen.value.to_i, @hGen.value.to_i, "Primms")
	end

	def oldest()
		generate(@wGen.value.to_i, @hGen.value.to_i, "Oldest")
	end

	def backtrack()
		generate(@wGen.value.to_i, @hGen.value.to_i, "Backtrack")
	end

	def fileRead()
		if @file.value != ""
			@maze = []
			file = File.open("#{@file.value}", 'r')
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