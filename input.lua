--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 19/1/2019
-- Time: 10:14 PM
-- To change this template use File | Settings | File Templates.
--

local input = {}
input.actions = {}

function input.init(hero)
	local WalkAction = require("obj/actions/WalkAction")
	local RestAction = require("obj/actions/RestAction")
	local InteractAction = require("obj/actions/InteractAction")

	--Movement
	input.actions["w"] = WalkAction(hero, "up")
	input.actions["s"] = WalkAction(hero, "down")
	input.actions["d"] = WalkAction(hero, "right")
	input.actions["a"] = WalkAction(hero, "left")

	--Actions
	input.actions["r"] = RestAction(hero)
	input.actions["e"] = InteractAction(hero)
end

function input.keypressed(hero, key, isrepeat)
	hero:setAction(input.actions[key])

	if key == "w" then
		hero.facing = "up"
	elseif key == "s" then
		hero.facing= "down"
	elseif key == "d" then
		hero.facing = "right"
	elseif key == "a" then
		hero.facing = "left"
	end
end

return input