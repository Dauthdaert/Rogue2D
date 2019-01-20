--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 19/1/2019
-- Time: 10:53 PM
-- To change this template use File | Settings | File Templates.
--

local Action = require("obj/actions/Action")

local OpenDoorAction = Action:extend()

function OpenDoorAction:init(actor, xPos, yPos)
	OpenDoorAction.super.init(self, actor)

	self.xPos, self.yPos = xPos, yPos
end

function OpenDoorAction:execute()
	local map = Map.getInstance()
	local ActionResult = (require("obj/actions/ActionResult"))()

	local targetTile = map:getTileAtPos(self.xPos, self.yPos)

	if targetTile == "-" then
		map:getTileMap()[self.yPos][self.xPos] = "\\"
	else
		map:getTileMap()[self.yPos][self.xPos] = "/"
	end
	map:getCollisionMap()[self.yPos][self.xPos] = 1

	OpenDoorAction.super.execute(self) --does energy cost

	return ActionResult
end

return OpenDoorAction

