--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 13/1/2019
-- Time: 3:15 PM
-- To change this template use File | Settings | File Templates.
--

local private = {}
local gen = {}

function gen.generateMap(height, width)
	local astray = require('lib/astray')

	-- This maze generator can only generate uneven maps.
	-- To get a 399x399 maze you need to Input (local height, width = 400, 400)
	-- RoomGenerator:new(rooms, minWidth, maxWidth, minHeight, maxHeight)
	local changeDirectionModifier = 30 --(1-30)
	local sparsenessModifier = 70 --(25-70)
	local deadEndRemovalModifier = 80 --(70-99)

	local roomMinNumber = 10
	local roomMinWidth = 2
	local roomMinHeight = 2
	local roomMaxNumber = 20
	local roomMaxWidth = 10
	local roomMaxHeight = 10
	local roomGenerator = astray.RoomGenerator:new(love.math.random(roomMinNumber, roomMaxNumber), roomMinWidth, roomMaxWidth, roomMinHeight, roomMaxHeight)

	local generator = astray.Astray:new(height/2-1, width/2-1, changeDirectionModifier, sparsenessModifier, deadEndRemovalModifier, roomGenerator)
	local dungeon = generator:Generate()
	local tiles = generator:CellToTiles(dungeon)
	tiles = private.generateEntranceExit(tiles)

	return tiles
end

function private.generateEntranceExit(tileMap)
	local xPos, yPos

	repeat
		xPos = love.math.random(#tileMap[1])
		yPos = love.math.random(#tileMap)
	until(tileMap[yPos][xPos] == ".")

	tileMap[yPos][xPos] = "u"

	repeat
		xPos = love.math.random(#tileMap[1])
		yPos = love.math.random(#tileMap)
	until(tileMap[yPos][xPos] == ".")

	tileMap[yPos][xPos] = "d"

	return tileMap
end

function gen.generateActorsForMap(tileMap)
	local actors = {}

	for i = 1, 10 do
		table.insert(actors, gen.generateNewActor(tileMap))
	end

	return actors
end

function gen.generateNewActor(tileMap)
	local map = Map:getInstance()
	local collisionMap = map:loadCollisionMapFromTiles(tileMap)

	local xPos
	local yPos

	repeat
		xPos = love.math.random(#collisionMap[1])
		yPos = love.math.random(#collisionMap)
	until(collisionMap[yPos][xPos] == 0 and map:getCollisionWithActors(yPos, xPos) == false)

	local actor = require("obj/Rat")(xPos, yPos)

	return actor
end

return gen