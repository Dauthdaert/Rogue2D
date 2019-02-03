--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 19/1/2019
-- Time: 10:47 PM
-- To change this template use File | Settings | File Templates.
--

local Action = require("obj/actions/Action")

local InteractAction = Action:extend()

function InteractAction:init(actor)
	InteractAction.super.init(self, actor)
end

function InteractAction:checkForStairs(xPos, yPos)
	local map = Map.getInstance()
	local alternate

	local targetTile = map:getTileAtPos(xPos, yPos)

	if targetTile then
		--Target is an up stair, so use it
		if targetTile == "u" then
			alternate = (require("obj/actions/UseStairAction"))(self.actor, "up")
			--Target is a down stair, so use it
		elseif targetTile == "d" then
			alternate = (require("obj/actions/UseStairAction"))(self.actor, "down")
		end
	end

	return alternate
end

function InteractAction:checkAlternate(nextXPos, nextYPos)
	local map = Map.getInstance()
	local alternate

	local targetTile = map:getTileAtPos(nextXPos, nextYPos)

	if targetTile then
		--Target is a door, so open it
		if targetTile == "|" or targetTile == "-" then
			alternate = (require("obj/actions/OpenDoorAction"))(self.actor, nextXPos, nextYPos)
		--Target is an open door, so close it
		elseif targetTile == "\\" or targetTile == "/" then
			alternate = (require("obj/actions/CloseDoorAction"))(self.actor, nextXPos, nextYPos)
		--Rest for anything else
		else
			alternate = (require("obj/actions/RestAction"))(self.actor)
		end
	end

	local targetActor = map:getActorAtPos(nextXPos, nextYPos)

	if targetActor then

	end

	return alternate
end

function InteractAction:execute()
	local navigate = require("lib/navigate")

	local ActionResult = (require("obj/actions/ActionResult"))()

	ActionResult.alternate = self:checkForStairs(self.actor.xPos, self.actor.yPos)

	if not ActionResult.alternate then
		local nextXPos, nextYPos = navigate.getNextPos(self.actor, self.actor.facing)

		ActionResult.alternate = self:checkAlternate(nextXPos, nextYPos)
	end

	if ActionResult.alternate then
		return ActionResult
	else
		ActionResult.succeeded = false
	end

	return ActionResult
end

return InteractAction

