Game = require("game")
UI = require("ui")
Map = require("map")
Input = require("input")
local Pie = require("lib/piefiller"):new()

WINDOW_WIDTH = love.graphics.getWidth()
WINDOW_HEIGHT = love.graphics.getHeight()
TILE_SIZE = 32
DEBUG = 1

function love.load()
	love.graphics.setBackgroundColor(1, 1, 1)
	love.keyboard.setKeyRepeat(true)
	love.filesystem.setIdentity("Rogue2D")

	local game = Game.getInstance()
	local map = Map.getInstance()

	--Load current hero and map
	game:loadGame("hero")
	local hero = game:getHero()

	--Setup camera
	map:attachCamera(hero.xPos, hero.yPos)

	--Setup input management
	Input.init(hero)
end

function love.update(dt)
	local game = Game.getInstance()
	local map = Map.getInstance()

	game:update()

	local hero = game:getHero()
	map:update(hero.xPos, hero.yPos)
end

function love.keypressed(key, scancode, isrepeat)
	local game = Game.getInstance()

	if debug == 2 then Pie:keypressed(key, isrepeat) end

	Input.keypressed(game:getHero(), key)
end

function love.draw()
	local ui = UI.getInstance()

	if debug == 2 then Pie:attach() end

	ui:draw()

	if debug == 2 then Pie:detach() end
end

function love.quit()
	local game = Game.getInstance()

	game:quit()
end