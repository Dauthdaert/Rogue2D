--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 19/1/2019
-- Time: 10:53 PM
-- To change this template use File | Settings | File Templates.
--

local collisionKey = {}

--Wall
collisionKey["#"] = 1

--Floor
collisionKey["."] = 0

--Doors (Closed)
collisionKey["|"] = 1
collisionKey["-"] = 1

--Doors (Open)
collisionKey["/"] = 0
collisionKey["\\"] = 0

--Stairs
collisionKey["u"] = 0
collisionKey["d"] = 0

return collisionKey