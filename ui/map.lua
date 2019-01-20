--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 13/1/2019
-- Time: 9:10 PM
-- To change this template use File | Settings | File Templates.
--
local Map = {}

local mapKey, actorKey = require("res/mapKey"), require("res/actorKey")

function Map.getTilesOnScreen(camera)
	-- find world coords that define screen limits
	local minX, minY = camera:worldCoords(-TILE_SIZE, -TILE_SIZE)
	local maxX, maxY = camera:worldCoords(WINDOW_WIDTH, WINDOW_HEIGHT)

	local minCol = math.max(1, math.floor(minX / TILE_SIZE))
	local minRow = math.max(1, math.floor(minY / TILE_SIZE))

	local maxCol = math.floor(maxX / TILE_SIZE)
	local maxRow = math.floor(maxY / TILE_SIZE)

	return minCol, minRow, maxCol, maxRow
end

function Map.drawTiles(tiles, minCol, minRow, maxCol, maxRow)
	-- loop through only tiles that could be visible
	for row = minRow, math.min(#tiles, maxRow) do
		for col = minCol, math.min(#tiles[row], maxCol) do
			local x = col * TILE_SIZE
			local y = row * TILE_SIZE

			local c = tiles[row][col]
			local key = mapKey[c]
			love.graphics.draw(key, x, y, 0, 1, 1)
		end
	end
end

function Map.drawActors(actors, minCol, minRow, maxCol, maxRow)
	for key, actor in ipairs(actors) do
		if actor.xPos >= minCol and actor.xPos <= maxCol and actor.yPos >= minRow and actor.yPos <= maxRow then
			local key = actorKey[actor.type]

			local x = actor.xPos * TILE_SIZE
			local y = actor.yPos * TILE_SIZE

			love.graphics.draw(key, x, y, 0, 1, 1)
			love.graphics.setColor(1, 0, 0)
			love.graphics.rectangle("fill", x, y + TILE_SIZE, TILE_SIZE, 8)
			love.graphics.setColor(0, 1, 0)
			love.graphics.rectangle("fill", x, y + TILE_SIZE, TILE_SIZE * (actor.hp / actor.maxHp), 8)
			love.graphics.setColor(1, 1, 1)
		end
	end
end

function Map.drawMap(camera, tiles, actors)
	camera:attach()

	local minCol, minRow, maxCol, maxRow = Map.getTilesOnScreen(camera)

	Map.drawTiles(tiles, minCol, minRow, maxCol, maxRow)
	Map.drawActors(actors, minCol, minRow, maxCol, maxRow)

	camera:detach()
end

return Map
