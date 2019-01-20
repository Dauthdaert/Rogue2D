--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 13/1/2019
-- Time: 3:35 PM
-- To change this template use File | Settings | File Templates.
--
local mapKey = {}

--Wall
mapKey["#"] = love.graphics.newImage("res/textures/tiles/wall.png")

--Floor
mapKey["."] = love.graphics.newImage("res/textures/tiles/floor.png")

--Doors (Closed)
mapKey["|"] = love.graphics.newImage("res/textures/tiles/door_vertical.png")
mapKey["-"] = love.graphics.newImage("res/textures/tiles/door_horizontal.png")

--Doors (Open)
mapKey["/"] = love.graphics.newImage("res/textures/tiles/door_vertical_open.png")
mapKey["\\"] = love.graphics.newImage("res/textures/tiles/door_horizontal_open.png")

--Stairs
mapKey["u"] = love.graphics.newImage("res/textures/tiles/stairs.png")
mapKey["d"] = love.graphics.newImage("res/textures/tiles/stairs.png")


return mapKey