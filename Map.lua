require "Utils"
Map = Class{}

-- File specific globals
-- index for spritesheet
local TILE_BRICK = 1
local TILE_EMPTY = 4

local SCROLL_SPEED = 62

function Map:init()
	-- load spritesheet
	self.spriteSheet = love.graphics.newImage("graphics/spritesheet.png")
	-- hight and width of tiles in spritesheet
	self.tileWidth = 16
	self.tileHeight = 16
	-- how many tiles the map has
	self.mapWidth = 30
	self.mapHeight = 28
	-- pixels size of map
	self.mapWidthPixels = self.mapWidth * self.tileWidth
	self.mapHeightPixels = self.mapHeight * self.tileHeight
	-- camera position to translate quardinates
	self.camX = 0
	self.camY = -3
	-- dict to store tiles ( map variable )
	self.tiles = {}
	-- genarates a dict with all the tiles in spritesheet
	self.tileSprites = genarateQuads(
		self.spriteSheet, self.tileWidth , self.tileHeight
	)

	-- Fill map with empty tiles
	for y = 1, self.mapHeight / 2 do
		for x = 1, self.mapWidth do
			-- sets the self.tiles variable
			self:setTile(x, y, TILE_EMPTY)
		end
	end
	-- Fill bottom half with bricks
	for y = self.mapHeight / 2, self.mapHeight do
		for x = 1, self.mapWidth do
			self:setTile(x, y, TILE_BRICK)
		end
	end
end

function Map:setTile(x, y, tile)
	-- I't a 1D array representing a 2D array
	self.tiles[(y - 1) * self.mapWidth + x] = tile
end

function Map:getTile(x , y)
	-- Returns the tiles index in self.spriteSheet for (x, y)
	-- used for drawing
	return self.tiles[(y - 1) * self.mapWidth + x]
end

function Map:update(dt)
	-- translate the map acording to camX and camY
	-- g_JoyKey is set by Joystick in Android devices
	-- so it can be played with those buttons
		-- math.min and max clamps the camera to map
	if love.keyboard.isDown('w') or 
		string.find(g_JoyKey, 'w') then
		self.camY = math.max(0, self.camY + -SCROLL_SPEED * dt)	
	end	

	if love.keyboard.isDown('s') 
		or string.find(g_JoyKey, 's')  then
		self.camY = math.min(self.mapHeightPixels - VIRTUAL_HEIGHT, 
			self.camY + SCROLL_SPEED * dt)
	end	

	if love.keyboard.isDown('a') 
		or string.find(g_JoyKey, 'a')  then
		self.camX = math.max(0, self.camX + -SCROLL_SPEED * dt)
	end	

	if love.keyboard.isDown('d') 
		or string.find(g_JoyKey, 'd')  then
		self.camX = math.min(self.mapWidthPixels - VIRTUAL_WIDTH, 
			self.camX + SCROLL_SPEED * dt)
	end	
end


function Map:render()
	-- translate the map
	love.graphics.translate(math.floor(-self.camX + 0.5) ,
		math.floor(-self.camY + 0.5))
	-- draw map with self.spriteSheet and self.tiles
	for y = 1, self.mapHeight do
		for x = 1, self.mapWidth do
			love.graphics.draw(self.spriteSheet,
				self.tileSprites[self:getTile(x, y)],
				(x - 1) * self.tileWidth , (y - 1) * self.tileHeight)
		end
	end	
	-- trsnslate the screen back so other overlays aren't affected
	love.graphics.translate(math.floor(self.camX) , math.floor(self.camY))
end

