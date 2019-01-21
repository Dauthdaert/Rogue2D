local Actor = require("obj/Actor")

local Hero = Actor:extend()

local EnergyPerTurn = 50
local MaxHp = 11
local Damage = 2

function Hero:init(name, currentLevel, xPos, yPos, hp)
	hp = hp or MaxHp
	Hero.super.init(self, "Hero", xPos, yPos, EnergyPerTurn, MaxHp, hp, Damage)

	self.currentLevel, self.name, self.action = currentLevel or "example", name or "test", nil
	self.facing = "up"
end

function Hero:setAction(action)
	self.action = action
end

function Hero:getAction()
	local tmp = self.action
	self.action = nil
	return tmp
end

function Hero:die()
	
end

return Hero