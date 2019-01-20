local class = require("lib/30log")

local Map = class("Map")
local Grid = require ("lib/jumper.grid") -- The grid class
local Pathfinder = require ("lib/jumper.pathfinder") -- The pathfinder

local instance = Map()

local WALKABLE_TILE = 0

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
	if xPos == 0 or yPos == 0 then return true end

	return self.collisionMap[yPos][xPos] == 1
end

function Map:getCollisionWithActors(xPos, yPos)
	for key, actor in ipairs(Game.getInstance().actors) do
		if actor.xPos == xPos and actor.yPos == yPos then return true end
	end

	return false
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
	end
end

--------------------------------------------------------------------------------------------------

function Map:update(x, y)
	self.camera:lockPosition(self:getNextCameraPos(x, y))
end

return Map