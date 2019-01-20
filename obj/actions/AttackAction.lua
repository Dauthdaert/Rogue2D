local Action = require("obj/actions/Action")

local AttackAction = Action:extend()

function AttackAction:init(actor, targetActor)
	AttackAction.super.init(self, actor)
	self.targetActor = targetActor or nil
end

function AttackAction:execute()
	local ActionResult = (require("obj/actions/ActionResult"))()

	self.targetActor:takeDamage(self.actor.damage)
	AttackAction.super.execute(self) --does energy cost

	return ActionResult
end

return AttackAction