--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 19/1/2019
-- Time: 10:53 PM
-- To change this template use File | Settings | File Templates.
--

local WALKABLE = 0
local UNWALKABLE = 1

local collisionKey = {}

--Wall
collisionKey["#"] = UNWALKABLE

--Floor
collisionKey["."] = WALKABLE

--Doors (Closed)
collisionKey["|"] = UNWALKABLE
collisionKey["-"] = UNWALKABLE

--Doors (Open)
collisionKey["/"] = WALKABLE
collisionKey["\\"] = WALKABLE

--Stairs
collisionKey["u"] = WALKABLE
collisionKey["d"] = WALKABLE

return collisionKey