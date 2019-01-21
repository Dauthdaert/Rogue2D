local class = require("lib/30log")

local Map = class("Map")
local Grid = require ("lib/jumper.grid") -- The grid class
local Pathfinder = require ("lib/jumper.pathfinder") -- The pathfinder

local instance = Map()

local WALKABLE_TILE = 0
local STAIRS_UP = "u"
local STAIRS_DOWN = "d"

function Map.new()
	error('Cannot instantiate from a Singleton class') 
end

function Map.extend() 
  error('Cannot extend from a Singleton class')
end

function Map.getInstance()
  return instance
end

--------------------------------------------------------------------------------------------------

function Map:getCamera()
	return self.camera
end

function Map:attachCamera(x, y)
	local Camera = require("lib/camera")

	local camera = Camera(self:getNextCameraPos(x, y))
	camera.smoother = Camera.smooth.damped(10)
	self.camera = camera
end

function Map:getNextCameraPos(xPos, yPos)
	local x, y = (xPos + 1) * TILE_SIZE, (yPos + 1) * TILE_SIZE

	x = math.max(WINDOW_WIDTH / 2 + TILE_SIZE, x)
	x = math.min((self.width + 1) * TILE_SIZE - WINDOW_WIDTH / 2, x)

	y = math.max(WINDOW_HEIGHT / 2 + TILE_SIZE, y)
	y = math.min((self.height + 1) * TILE_SIZE - WINDOW_HEIGHT / 2, y)

	return x, y
end

--------------------------------------------------------------------------------------------------

function Map:load(tiles)
	self.tileMap = tiles
	self.width = #self.tileMap[1]
	self.height = #self.tileMap

	self.entrance = {}
	self.exit = {}

	self.entrance.x, self.entrance.y = self:loadEntranceFromTiles(self.tileMap)
	self.exit.x, self.exit.y = self:loadExitFromTiles(self.tileMap)

	self.collisionMap = self:loadCollisionMapFromTiles(self.tileMap)
	self.pathfinder = self:loadPathfinder()
end

function Map:loadCollisionMapFromTiles(tileMap)
	local collisionKey = require("map/collisionKey")

	local collisionMap = {}

	for row = 1, #tileMap do
		collisionMap[row] = {}

		for col = 1, #tileMap[row] do
			local c = tileMap[row][col]
			collisionMap[row][col] = collisionKey[c]
		end
	end

	return collisionMap
end

function Map:loadEntranceFromTiles(tileMap)
	for row = 1, #tileMap do
		for col = 1, #tileMap[row] do
			local c = tileMap[row][col]
			if c == STAIRS_UP then return col, row end
		end
	end

	return 1, 1
end

function Map:loadExitFromTiles(tileMap)
	for row = 1, #tileMap do
		for col = 1, #tileMap[row] do
			local c = tileMap[row][col]
			if c == STAIRS_DOWN then return col, row end
		end
	end

	return 1, 1
end

function Map:loadPathfinder()
	local grid = Grid(self.collisionMap)

	local pathfinder = Pathfinder(grid, 'JPS', WALKABLE_TILE)
	pathfinder:setMode("ORTHOGONAL")

	return pathfinder
end

--------------------------------------------------------------------------------------------------

function Map:getTileMap()
	return self.tileMap
end

function Map:getTileAtPos(xPos, yPos)
	if yPos == 0 or xPos == 0 or yPos > #self.tileMap or xPos > #self.tileMap[yPos] then return nil end

	return self.tileMap[yPos][xPos]
end

--------------------------------------------------------------------------------------------------

function Map:getActorAtPos(xPos, yPos)
	for key, actor in ipairs(Game.getInstance().actors) do
		if actor.xPos == xPos and actor.yPos == yPos then return actor end
	end

	return nil
end

--------------------------------------------------------------------------------------------------

function Map:getCollisionMap()
	return self.collisionMap
end

function Map:getCollisionWithTiles(xPos, yPos)
	if yPos == 0 or xPos == 0 or yPos > #self.tileMap or xPos > #self.tileMap[yPos] then return true end

	return self.collisionMap[yPos][xPos] == 1
end

function Map:getCollisionWithActors(xPos, yPos)
	for key, actor in ipairs(Game.getInstance().actors) do
		if actor.xPos == xPos and actor.yPos == yPos then return true end
	end

	return false
end

--------------------------------------------------------------------------------------------------

function Map:getEntrancePos()
	return self.entrance.x, self.entrance.y
end

function Map:getExitPos()
	return self.exit.x, self.exit.y
end

--------------------------------------------------------------------------------------------------

function Map:getPathToPlayer(startX, startY)
	local hero = Game:getInstance():getHero()
	local path = self.pathfinder:getPath(startX, startY, hero.xPos, hero.yPos)

	if path then
		path:fill()
		for node, index in path:nodes() do
			if index == 2 then return node.x, node.y end
		end
	else
		return startX + love.math.random(-1, 1), startY + love.math.random(-1, 1)
	end
end

function Map:actorIsCloseToPlayer(actor)
	local hero = Game:getInstance():getHero()

	return math.abs(hero.xPos - actor.xPos) < 15 or math.abs(hero.yPos - actor.yPos) < 15
end

--------------------------------------------------------------------------------------------------

function Map:update(x, y)
	self.camera:lockPosition(self:getNextCameraPos(x, y))
end

return Map