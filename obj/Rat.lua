local Actor = require("obj/Actor")

local Rat = Actor:extend()

local EnergyPerTurn = 60
local MaxHp = 4
local Damage = 1

function Rat:init(xPos, yPos, hp)
	hp = hp or MaxHp
	Rat.super.init(self, "Rat", xPos, yPos, EnergyPerTurn, MaxHp, hp, Damage)
end

return Rat