local class = require("lib/30log")

local UI = class("UI")
local uiMap = require("ui/map")

local instance = UI()

function UI.new()
	error('Cannot instantiate from a Singleton class') 
end

function UI.extend() 
  error('Cannot extend from a Singleton class')
end

function UI.getInstance()
  return instance
end

function UI:drawDebug()
	local actors = Game.getInstance().actors
	love.graphics.setColor(0, 1, 0)
	for i = 1, #actors do
		local actor = actors[i]
		love.graphics.print(actor.type..":"..actor.currentEnergy, 10, 20 + 10 * (i - 1))
	end
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	love.graphics.setColor(1, 1, 1)
end

function UI:draw()
	local game = Game.getInstance()
	local map = Map.getInstance()

	uiMap.drawMap(map:getCamera(), map:getTileMap(), game:getActors())

	if DEBUG ~= 0 then self:drawDebug() end
end

return UI