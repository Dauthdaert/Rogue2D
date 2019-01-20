--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 20/1/2019
-- Time: 12:57 PM
-- To change this template use File | Settings | File Templates.
--

local private = {}
local navigate = {}

private.directions = {}
private.directions["up"] = function(actor)
	return actor.xPos, actor.yPos - actor.speed
end

private.directions["down"] = function(actor)
	return actor.xPos, actor.yPos + actor.speed
end

private.directions["right"] = function(actor)
	return actor.xPos + actor.speed, actor.yPos
end

private.directions["left"] = function(actor)
	return actor.xPos - actor.speed, actor.yPos
end

function navigate.getNextPos(actor, direction)
	return private.directions[direction](actor)
end

return navigate