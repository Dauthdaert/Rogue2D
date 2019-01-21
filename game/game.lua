local class = require("lib/30log")

local Game = class("Game")
local gameIO = require("game/io")
local gameGenerator = require("game/generator")

local instance = Game()

local TURNS_TO_SPAWN = 20

function Game.new()
	error('Cannot instantiate from a Singleton class')
end

function Game.extend()
	error('Cannot extend from a Singleton class')
end

function Game.getInstance()
	return instance
end

--------------------------------------------------------------------------------------------------

function Game:getHero()
	return self.actors[1]
end

function Game:getActors()
	return self.actors
end

--------------------------------------------------------------------------------------------------

function Game:resetGame()
	self.currentActor = 1
	self.turnsSinceSpawn = 0

	if self.actors then
		for i = #self.actors, 2, -1 do
			table.remove(self.actors, i)
		end
	end
end

function Game:loadGame(heroName)
	self:resetGame()

	local map, actors = gameIO.loadGame(heroName)

	self.actors = actors
	Map:getInstance():load(map)
end

function Game:quit()--save lvl state
	gameIO.saveGame(Map:getInstance():getTileMap(), self:getActors())
end

--------------------------------------------------------------------------------------------------

function Game:update()
	local actor = self.actors[self.currentActor]

	if Map:getInstance():actorIsCloseToPlayer(actor) then
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

		--Add new energy for actions
		actor:gainEnergy()
	end

	--------------------------------------------------------------------------------

	--Spawn new monsters every so often
	if actor.type == "Hero" then
		if self.turnsSinceSpawn > TURNS_TO_SPAWN then
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

--------------------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------------------

function Game:generateNewLevel(name)
	local tileMap = gameGenerator.generateMap(100, 100)
	local actors = gameGenerator.generateActorsForMap(tileMap)

	gameIO.saveLevel(tileMap, actors, self:getHero().name, name)
end

function Game:loadNewLevel(nextLevel)
	local map = Map:getInstance()
	local hero = self:getHero()

	--Save the old map before we change
	gameIO.saveLevel(map:getTileMap(), self.actors, hero.name, hero.currentLevel)

	self:resetGame()

	--Which position to place the Hero on the next map
	local goingDown = nextLevel > hero.currentLevel

	--Load map and new actors
	local tileMap, actorsTmp = gameIO.loadLevel(hero.name, nextLevel)
	map:load(tileMap)
	for key, item in ipairs(actorsTmp) do
		table.insert(self.actors, item)
	end

	--Setup new values for Hero
	hero.currentLevel = nextLevel
	if goingDown then
		hero.xPos, hero.yPos = map:getEntrancePos()
	else
		hero.xPos, hero.yPos = map:getExitPos()
	end
end

function Game:goDown()
	local hero = self:getHero()
	local nextLevel = hero.currentLevel + 1
	--if no level exists, generate new
	if not gameIO.levelExists(hero.name, nextLevel) then
		self:generateNewLevel(nextLevel)
	end

	self:loadNewLevel(nextLevel)
end

function Game:goUp()
	local hero = self:getHero()
	local nextLevel = hero.currentLevel - 1

	self:loadNewLevel(nextLevel)
end

--------------------------------------------------------------------------------------------------

return Game