require 'Qt'
require_relative "extraWidgets.rb"
require_relative "Maze.rb"
require_relative "MazeWindow.rb"

class MazeUI < Qt::Widget

	slots('fileRead()','primms()','backtrack()','oldest()','fileWrite()', 'solve()', 'updateDelay()', 'reRun()')

	def initialize
		super

		setWindowTitle("MyMaze")

		initUI
		connections

		move(300,300)

		show
	end

	def initUI
		objects
		widgets
		layout
	end

	def objects
		@maze = Maze.new
	end

	def widgets
		@mazeWin = MazeWindow.new

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
		connect(@export, SIGNAL('clicked()'), self, SLOT(:fileWrite))
		connect(@primms, SIGNAL('triggered()'), self, SLOT(:primms))
		connect(@oldest, SIGNAL('triggered()'), self, SLOT(:oldest))
		connect(@backTrack, SIGNAL('triggered()'), self, SLOT(:backtrack))
		connect(@rMaze, SIGNAL('clicked()'), self, SLOT(:solve))
		connect(@dSlider, SIGNAL('valueChanged(int)'), self, SLOT(:updateDelay))
		connect(@dSlider, SIGNAL('valueChanged(int)'), @dDelay, SLOT('display(int)'))
		connect(@rrMaze, SIGNAL('clicked()'), self, SLOT(:reRun))
	end

	def primms
		@maze.generate(@wGen.value.to_i, @hGen.value.to_i, "Primms")
		@mazeWin.setMaze(@maze.m)
		@rrMaze.enabled = false
	end

	def oldest
		@maze.generate(@wGen.value.to_i, @hGen.value.to_i, "Oldest")
		@mazeWin.setMaze(@maze.m)
		@rrMaze.enabled = false
	end

	def backtrack
		@maze.generate(@wGen.value.to_i, @hGen.value.to_i, "Backtrack")
		@mazeWin.setMaze(@maze.m)
		@rrMaze.enabled = false
	end

	def solve
		if 	@bFS.checked == true	
			@mazeWin.solve(:bFS,@maze)
		else	
			@mazeWin.solve(:dFS,@maze)
		end
		@rrMaze.enabled = true
	end

	def reRun
		@mazeWin.correctPath
	end

	def updateDelay
		@mazeWin.setDelay(@dSlider.value)
	end

	def fileRead
		if File.file?(@file.value)
			file = File.open("#{@file.value}", 'r')
			@maze.set_m(file.read)
			@mazeWin.maze = @maze.m
			file.close
		end
		@rrMaze.enabled = false
	end

	def fileWrite
		if @file.value != ""
			fp = File.open(@file.value, "w")
			fp.puts @maze.to_s(@maze.m)
			fp.close
		end
	end
end