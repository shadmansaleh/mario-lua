------------------------
--  Global variables  --
------------------------

WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions() --1280, 720

VIRTUAL_WIDTH, VIRTUAL_HEIGHT = 432, 243

android = love.system.getOS() == "Android"

--------------------
--  Import files  --
--------------------
-- library
push = require 'push'
Class = require 'class'

-- mine
require "Utils"
require 'Map'
if android then
	require "Joystick"	
	g_JoyKey = ""
end
---------------------------
--  Initialize the game  --
---------------------------
love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()
--Create map instance
	map = Map()
	if android then
		joystick = Joystick()
	end

-- Setup screan
	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT,
		WINDOW_WIDTH, WINDOW_HEIGHT,		
		{
			fullscreen = true,
			resizeable = true,
			vsync = true,
			pixelperfact = true,
		})
end

----------------------------
--  Update game contents  --
----------------------------

function love.update(dt)
	if android then
		joystick:update(dt)
	end
	map:update(dt)	
end

-------------------------------
--  Draw contents on screen  --
-------------------------------

function love.draw()
-- Start push library management
	push:apply("start")
-- clear screen with background blue color
	love.graphics.clear(100 / 255, 140 / 255, 1, 1)
-- render the map
	map:render()
	if android then
		joystick:render()
	end
-- End push library management
	push:apply("end")
end

function love.resize(w, h)
	push:resize(w, h)
end
