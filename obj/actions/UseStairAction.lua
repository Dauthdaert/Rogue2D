--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 21/1/2019
-- Time: 11:15 AM
-- To change this template use File | Settings | File Templates.
--

--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 20/1/2019
-- Time: 1:11 PM
-- To change this template use File | Settings | File Templates.
--

local Action = require("obj/actions/Action")

local UseStairAction = Action:extend()

function UseStairAction:init(actor, direction)
	UseStairAction.super.init(self, actor)

	self.direction = direction or nil
end

function UseStairAction:execute()
	local ActionResult = (require("obj/actions/ActionResult"))()

	if self.direction == "up" then
		Game:getInstance():goUp()
	elseif self.direction == "down" then
		Game:getInstance():goDown()
	end

	--does energy cost
	UseStairAction.super.execute(self)

	return ActionResult
end

return UseStairAction