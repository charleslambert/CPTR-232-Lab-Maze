#!/usr/bin/env ruby

require_relative "MyWidgets.rb"
require_relative "MazeGenerator.rb"
require_relative "Searches.rb"
require_relative "Graph.rb"
require 'Qt'

class MazeUI < Qt::Widget

	slots('fileRead()','primms()','backtrack()','oldest()','writeFile()', 'solve()','onTimeout()', 'updateDelay()')

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
		@timer = Qt::Timer.new
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
		@delayLabel = Qt::Label.new("Delay:")
		@dSlider = Qt::Slider.new(Qt::Horizontal) do |i|
			i.setRange(0,100)
			i.setValue(0)
		end
		@dDelay = Qt::LCDNumber.new(3)
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

		mDelay = Qt::HBoxLayout.new do |i|
			i.addWidget(@delayLabel)
			i.addWidget(@dSlider)
			i.addWidget(@dDelay)
		end

		runMaze = Qt::HBoxLayout.new do |i|
			i.addWidget(@rMaze)
			i.addWidget(@rrMaze)
			i.addLayout(mDelay)
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
		connect(@timer, SIGNAL('timeout()'), self, SLOT(:onTimeout))
		connect(@dSlider, SIGNAL('valueChanged(int)'), self, SLOT(:updateDelay))
		connect(@dSlider, SIGNAL('valueChanged(int)'), @dDelay, SLOT('display(int)'))
	end

	def solve()
		#find the entrance
		@graph = Graph.new(@maze)

		for i in 1...@maze[0].length
			if @maze[0][i] == " " or @maze[0][i] == "b"
				s = @graph.vertexs["#{i},#{0}".to_sym]
				break
			end
		end

		@searchTime = Fiber.new {
			if @bFS.checked == true
				@solver.bFS(@graph, s) {|graph| 
					updateWin(@graph)
					Fiber.yield
				}
			else
				@solver.dFS(@graph, s) {|graph| 
					updateWin(@graph)
					Fiber.yield
				}
			end
		}
		@timer.start
	end

	def updateWin(graph)
		graph.vertexs.values.each do |node|
		 	@maze[node.posy][node.posx] = node.color
		end
		@mazeWin.repaint()
	end

	def onTimeout
		begin
		@searchTime.resume  
		rescue FiberError
			@timer.stop
		end
	end

	def updateDelay
		@timer.interval = @dSlider.value
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