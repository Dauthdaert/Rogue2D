local Action = require("obj/actions/Action")

local RestAction = Action:extend()

function RestAction:init(actor)
	RestAction.super.init(self, actor)
end

function RestAction:execute()
	local ActionResult = (require("obj/actions/ActionResult"))()

	self.actor:heal()
	RestAction.super.execute(self) --does energy cost

	return ActionResult
end

return RestAction