-- create a joystick
Joystick = Class{}

-- import Button
require "Button"

function Joystick:init()
	-- X value for left buttons
	self.centerX1 = VIRTUAL_WIDTH * 0.15
	-- X value for right buttons
	self.centerX2 =  VIRTUAL_WIDTH * 0.85
	-- Y value for buttons
	self.centerY = VIRTUAL_HEIGHT * 0.7 
	-- Button size
  self.buttonSize = VIRTUAL_WIDTH * 0.12
	-- Distance between two buttons
	self.buttonDistance = VIRTUAL_WIDTH * 0.03
	-- left button
	self.L = Button({
		-- left button is in left of centerX
		x = self.centerX1 - self.buttonDistance / 2 - self.buttonSize,
		-- all the Y are similar
		y = self.centerY,
		-- height and width are buttonSize
		height = self.buttonSize,
		width  = self.buttonSize,
		-- bool to draw button differently when pressed
		pressed = false,
		-- custom draw function
		draw = function(self)
			-- draw a triangle pointing left
			love.graphics.polygon(self.pressed and 'fill' or 'line'
			, {
			self.x + self.width, self.y,
			self.x + self.width, self.y + self.height,
			self.x, self.y + self.height / 2,
		})
			self.pressed = false
		end,
		-- onClick function
		onClick = function(self)
			self.pressed = true
			-- go left
			g_JoyKey = g_JoyKey .. 'a'
		end
})	
	self.R = Button({
		x = self.centerX1 + self.buttonDistance / 2,
		y = self.centerY,
		height = self.buttonSize,
		width  = self.buttonSize,
		pressed = false,
		draw = function(self)
			love.graphics.polygon(self.pressed and 'fill' or 'line'
			, {
			self.x, self.y,
			self.x, self.y + self.height,
			self.x + self.height, self.y + self.height / 2,
		})
			self.pressed = false
		end,
		onClick = function(self)
			self.pressed = true
			g_JoyKey = g_JoyKey .. 'd'
		end
})	
	
	self.U = Button({
		x = self.centerX2,
		y = self.centerY,
		height = self.buttonSize,
		width  = self.buttonSize,
		pressed = false,
		draw = function(self)
			love.graphics.polygon(self.pressed and 'fill' or 'line'
			, {
			self.x, self.y + self.height,
			self.x + self.width / 2, self.y,
			self.x + self.width, self.y + self.height,
		})
			self.pressed = false
		end,
		onClick = function(self)
			self.pressed = true
			g_JoyKey = g_JoyKey .. 'w'
		end
})	
	self.D = Button({
		x = self.centerX2 - self.buttonSize,
		y = self.centerY,
		height = self.buttonSize,
		width  = self.buttonSize,
		pressed = false,
		draw = function(self)
			love.graphics.polygon(self.pressed and 'fill' or 'line'
			, {
			self.x, self.y,
			self.x + self.width, self.y,
			self.x + self.width / 2, self.y + self.height,
		})
			self.pressed = false
		end,
		onClick = function(self)
			self.pressed = true
			g_JoyKey = g_JoyKey .. 's'
		end
})	
end

function Joystick:update(dt)
	-- reset g_JoyKey
	g_JoyKey = ""
	-- check if any button was pressed
	self.L:pressed()
	self.R:pressed()
	self.U:pressed()
	self.D:pressed()	
end

function Joystick:render()
	--render the buttons
	self.L:render()
	self.R:render()
	self.U:render()
	self.D:render()	
end


