local Actor = require("obj/Actor")

local Hero = Actor:extend()

local DefaultEnergyPerTurn = 50
local DefaultMaxHp = 11
local DefaultDamage = 2

function Hero:init(name, currentLevel, xPos, yPos, hp)
	hp = hp or MaxHp
	Hero.super.init(self, "Hero", xPos, yPos, DefaultEnergyPerTurn, DefaultMaxHp, hp, DefaultDamage)

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