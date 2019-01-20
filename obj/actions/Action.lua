local class = require("lib/30log")

local Action = class("Action", {energyCost = 100})

function Action:init(actor)
	self.actor = actor or nil
end

function Action:execute()
	self.actor:finishAction(self.energyCost)
end

return Action