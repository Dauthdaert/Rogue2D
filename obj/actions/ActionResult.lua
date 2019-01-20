local class = require("lib/30log")

local ActionResult = class("ActionResult")

function ActionResult:init(succeeded, alternate)
	self.succeeded = succeeded or true
	self.alternate = alternate or nil
end

return ActionResult