#!/usr/bin/env ruby

require_relative "MazeUI.rb"
require 'Qt'

app = Qt::Application.new(ARGV)
MazeUI.new
app.exec