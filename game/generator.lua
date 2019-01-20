--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 13/1/2019
-- Time: 3:15 PM
-- To change this template use File | Settings | File Templates.
--

local gen = {}

function gen.generateMap(height, width)
	local astray = require('lib/astray')

	-- This maze generator can only generate uneven maps.
	-- To get a 399x399 maze you need to Input
	--local height, width = 400, 400
	--	Astray:new(width/2-1, height/2-1, changeDirectionModifier (1-30), sparsenessModifier (25-70), deadEndRemovalModifier (70-99) ) | RoomGenerator:new(rooms, minWidth, maxWidth, minHeight, maxHeight)
	local generator = astray.Astray:new(height/2-1, width/2-1, 30, 70, 50, astray.RoomGenerator:new(7, 2, 10, 2, 10) )
	local dungeon = generator:Generate()
	return generator:CellToTiles(dungeon)
end

function gen.generateActorsForMap(tileMap)
	local actors

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