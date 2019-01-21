--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 20/1/2019
-- Time: 1:11 PM
-- To change this template use File | Settings | File Templates.
--

local Action = require("obj/actions/Action")

local CloseDoorAction = Action:extend()

function CloseDoorAction:init(actor, xPos, yPos)
	CloseDoorAction.super.init(self, actor)

	self.xPos, self.yPos = xPos, yPos
end

function CloseDoorAction:execute()
	local map = Map.getInstance()
	local ActionResult = (require("obj/actions/ActionResult"))()

	local targetTile = map:getTileAtPos(self.xPos, self.yPos)

	print(targetTile)

	if targetTile == "\\" then
		map:getTileMap()[self.yPos][self.xPos] = "-"
	else
		map:getTileMap()[self.yPos][self.xPos] = "|"
	end
	map:getCollisionMap()[self.yPos][self.xPos] = 1

	CloseDoorAction.super.execute(self) --does energy cost

	return ActionResult
end

return CloseDoorAction



