local class = require("lib/30log")

local Game = class("Game")
local gameIO = require("game/io")
local gameGenerator = require("game/generator")

local instance = Game()

function Game.new()
	error('Cannot instantiate from a Singleton class')
end

function Game.extend()
	error('Cannot extend from a Singleton class')
end

function Game.getInstance()
	return instance
end

function Game:getHero()
	return self.actors[1]
end

function Game:getActors()
	return self.actors
end

function Game:loadGame(heroName)
	self.currentActor = 1
	self.turnsSinceSpawn = 0

	local map, actors = gameIO.load(heroName)

	self.actors = actors
	Map:getInstance():load(map)
end

function Game:update()
	local actor = self.actors[self.currentActor]
	
	if (require("obj/actions/Action")).energyCost <= actor.currentEnergy then
		local action = actor:getAction()
		if action == nil then return end

		while true do
			local result = action:execute()

			if result.succeeded == false then return end
			if result.alternate == nil then break end

			action = result.alternate
		end
	end

------------After this happens only when an actor executes an action------------

	--Add new energy for actions
	actor:gainEnergy()

	--Spawn new monsters every so often
	if actor.type == "Hero" then
		if self.turnsSinceSpawn > 10 then
			table.insert(self.actors, gameGenerator.generateNewActor(Map:getInstance():getTileMap()))
			self.turnsSinceSpawn =  0
		else
			--Add a turn to next Spawn Counter
			self.turnsSinceSpawn = self.turnsSinceSpawn + 1
		end
	end

	--Set next actor to handle during update
	if self.currentActor + 1 > #self.actors then
		self.currentActor = 1
	else
		self.currentActor = self.currentActor + 1
	end
end

function Game:addActor(actor)
	table.insert(self.actors, actor)
end

function Game:killActor(actor)
	for i = 2, #self.actors do
		local tmp = self.actors[i]

		if tmp.xPos == actor.xPos and tmp.yPos == actor.yPos then
			table.remove(self.actors, i)
			return
		end
	end
end

function Game:goDown()
	local hero = self:getHero()
	local nextLevel = hero.currentLevel + 1
	--if no level exists, generate new
	if true then
		self:generateNewLevel(nextLevel)
	end
	hero.currentLevel = nextLevel

	--self:startGame(hero.name)
end

function Game:goUp()
	local hero = self:getHero()
	local nextLevel = hero.currentLevel - 1
	hero.currentLevel = nextLevel

	--self:startGame(hero.name)
end

function Game:generateNewLevel(name)
	local tileMap = gameGenerator.generateMap(400, 400)
	local actors = gameGenerator.generateActorsForMap(tileMap)

	--gameIO.save(gameIO.getHeroPath(self:getHero().name)..name, tileMap, actors)
end

function Game:quit()--save lvl state
	gameIO.save(Map:getInstance():getTileMap(), self:getActors())
end

return Game