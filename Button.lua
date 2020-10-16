Button = Class{}

function Button:init(arg_dict)
	--[[
	--	In arg_dict
	--		
	--		DIMENTION SCSIFIC
	--		x (num) = x cordinate   default(0)
	--		y (num) = y cordinate   default(0)
	--		width (num) = width of button   default(0)
	--		height (num) = heigh of button  default(0)
	--
	--		DRAWING SPECIFIC
	--		visible (bool) = is button visible   default(true)
	--		drawMode (string) [filled/line]= is filled			default(false)
	--		color (table with r,g,b,a values) = color to draw 
	--																							(already set color)	
	--		font (love.graphics.Font) = Font to use (already set font)
	--		text (string) = name pf button default(nil)
	--		textColor (table with r,g,b,a values) = color to draw the text
	--
	--		
	--		onClick (function) = function invoked when Button:clicked() is used
	--]]
	--
	-- Implement defaults
	if arg_dict.x == nil then
		arg_dict.x = 0
	end

	if arg_dict.y == nil then
		arg_dict.y = 0
	end

	if arg_dict.height == nil then
		arg_dict.height = 0
	end

	if arg_dict.width == nil then
		arg_dict.width = 0
	end

	if arg_dict.visible == nil then
		arg_dict.visible = true
	end

	if arg_dict.drawMode == nil then
		arg_dict.drawMode = 'line'
	end

	self.args = arg_dict
	self.was_updated = true
end

function Button:render()
	-- use custom draw if it was provided
	if self.args.draw ~= nil then
		self.args.draw(self.args)
	else	
		-- check if the button is visible
		-- hide the buttun if button was not checked for pressed
		if self.args.visible and self.was_updated then
			-- Change color and font if nessery
			if self.args.color ~= nil then
				local r, g, b, a = love.graphics.getcolor()			
				love.graphics.setcolor(self.args.color)
			end
			if self.args.font ~= nil then
				local font = love.graphics.getFont()
				love.graphics.setFont(self.args.font)
			end

			-- draw outer square
			love.graphics.rectangle(self.args.drawMode,
				self.args.x, self.args.y,
				self.args.width, self.args.height
			)

			-- draw text
			if self.args.text ~= nil then
				if self.args.textColor ~= nil then
					local tr, tg, tb, ta = love.graphics.getcolor()			
					love.graphics.setcolor(self.args.textColor)			
				end

				love.graphics.printf(self.args.text,
					self.args.x, (self.args.y + self.args.height / 2),
					self.args.width, 'center')

				if self.args.color ~= nil then
					love.graphics.setColor(tr, tg, tb, ta)
				end
			end

			--restore color and font if it was changed
			if self.args.color ~= nil then
				love.graphics.setColor(r, g, b, a)
			end
			if self.args.font ~= nil then
				love.graphics.setFont(font)
			end
			self.was_updated = false
		end
	end
end

function Button:buttonPressed(touch_id, onClick)
	-- get touch position
	x, y = love.touch.getPosition(touch_id)
	-- transform the touch to VIRTUAL screen location
	x = x * VIRTUAL_WIDTH / WINDOW_WIDTH
	y = y * VIRTUAL_HEIGHT / WINDOW_HEIGHT
	-- see if touch x is not in button boundary
	if x < self.args.x or
		x > (self.args.x + self.args.width)then
		return false
	-- see if touch y is not in button boundary
	elseif y < self.args.y or
		y > (self.args.y + self.args.height) then
		return false
	-- If past two were fakse that means button was clicked
	-- run onClick()
	else
		if self.args.onClick ~= nil then
			self.args.onClick(self.args)
		end
		if onClick ~= nil then
			onClick(self.args)
		end
		return true
	end
end

function Button:mousePressed(onClick)
	-- same just to make buttons work eith mouce presses too
	if love.mouse.isDown(1) then
		x = love.mouse.getX()
		y = love.mouse.getY()

		-- transform the touch to VIRTUAL screen location
		x = x * VIRTUAL_WIDTH / WINDOW_WIDTH
		y = y * VIRTUAL_HEIGHT / WINDOW_HEIGHT

		-- see if touch x is not in button boundary
		if x < self.args.x  or
			x > self.args.x + self.args.width then
			return false
		-- see if touch y is not in button boundary
		elseif y < self.args.y or
			y > self.args.y + self.args.height then
			return false

		-- If past two were fakse that means button was clicked
		-- run onClick()
		else
			if self.args.onClick ~= nil then
				self.args.onClick()
			end
			if onClick ~= nil then
				onClick()
			end
			return true
		end

	end
	return false
end

function Button:pressed(onClick)
	-- it checks for both touch and mouse presses
	-- trun on render as Button was checked
	self.was_updated = true
	-- get all the touches and loop through them to see if 
	-- button was touched
	touches = love.touch.getTouches()
	touch_state = false
	for i, touch_id in ipairs(touches) do
		if onClick ~= nil then
			touch_state = self:buttonPressed(touch_id, onClick)
		else
			touch_state =  self:buttonPressed(touch_id)
		end
		if touch_state == true then
			return true
		end
	end
	-- If it wasn't touched check for mouse click
	if touch_state == false then
		if onClick ~= nil then
			return self:mousePressed(onClick)
		else
			return self:mousePressed()
		end	
	end
end


