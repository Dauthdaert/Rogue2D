local Action = require("obj/actions/Action")

local WalkAction = Action:extend()

function WalkAction:init(actor, direction)
	WalkAction.super.init(self, actor)

	self.direction = direction or ""
end

function WalkAction:checkAlternate(nextXPos, nextYPos)
	local map = Map.getInstance()
	local alternate

	if map:getCollisionWithTiles(nextXPos, nextYPos) then
		local targetTile = map:getTileAtPos(nextXPos, nextYPos)

		--Taget is a door, so open it
		if targetTile == "|" or targetTile == "-" then
			alternate = (require("obj/actions/OpenDoorAction"))(self.actor, nextXPos, nextYPos)
		--Target is anything else, so rest
		else
			alternate = (require("obj/actions/RestAction"))(self.actor)
		end
	end

	local targetActor = map:getActorAtPos(nextXPos, nextYPos)

	if targetActor then
		alternate = (require("obj/actions/AttackAction"))(self.actor, targetActor)
	end

	return alternate
end

function WalkAction:execute()
	local navigate = require("lib/navigate")

	local ActionResult = (require("obj/actions/ActionResult"))()

	local nextXPos, nextYPos = navigate.getNextPos(self.actor, self.direction)

	--Check if we want to do something other than walking
	ActionResult.alternate = self:checkAlternate(nextXPos, nextYPos)
	if ActionResult.alternate then return ActionResult end

	WalkAction.super.execute(self) --does energy cost
	self.actor.xPos = nextXPos
	self.actor.yPos = nextYPos

	return ActionResult
end

return WalkAction