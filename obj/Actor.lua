local class = require("lib/30log")

local Actor = class("Actor", {currentEnergy = 0})

function Actor:init(type, xPos, yPos, energyPerTurn, maxHp, hp, damage)
	self.type = type or "Default"
	self.xPos, self.yPos = xPos or 0, yPos or 0
	self.energyPerTurn = energyPerTurn or 0
	self.maxHp, self.hp = maxHp or 100, hp or 100
	self.damage = damage or 0
	self.speed = 1
	self.facing = "up"
end

function Actor:getAction()
	local destX, destY = Map:getInstance():getPathToPlayer(self.xPos, self.yPos)

	local direction

	if destX > self.xPos then
		direction = "right"
	elseif destX < self.xPos then
		direction = "left"
	elseif destY > self.yPos then
		direction = "down"
	elseif destY < self.yPos then
		direction = "up"
	end

	return (require("obj/actions/WalkAction"))(self, direction)
end

function Actor:finishAction(energyCost)
	self.currentEnergy = self.currentEnergy - energyCost
end

function Actor:gainEnergy()
	self.currentEnergy = self.currentEnergy + self.energyPerTurn
end

function Actor:heal()
	self.hp = math.min(self.maxHp, self.hp + self.maxHp * 0.1)
end

function Actor:takeDamage(damage)
	self.hp = math.max(0, self.hp - damage)
	if self.hp <= 0 then self:die() end
end

function Actor:die()
	Game.getInstance():killActor(self)
end

return Actor