--
-- Created by IntelliJ IDEA.
-- User: Wayan
-- Date: 13/1/2019
-- Time: 1:28 PM
-- To change this template use File | Settings | File Templates.
--

local encoding = require("lib/encoding")

local private = {}

local io = {}

function private.getHeroPath(heroName)
	return "saves/"..heroName.."/"
end

function private.getLevelPath(hero)
	return "saves/"..hero.name.."/"..hero.currentLevel.."/"
end

function private.loadHero(heroName)
	local data = encoding.decode(love.filesystem.read(private.getHeroPath(heroName).."stats.txt"))
	return require("obj/Hero")(data[1], tonumber(data[2]), tonumber(data[3]), tonumber(data[4]), tonumber(data[5]))
end

function private.loadActor(actorString)
	local data = encoding.decode(actorString)
	local actor = require("obj/"..data[1])(tonumber(data[2]), tonumber(data[3]), tonumber(data[4]))
	return actor
end

function private.loadActors(heroName)
	local actors = {}

	--Load Hero
	table.insert(actors, private.loadHero(heroName))

	--Load the rest
	for line in love.filesystem.lines(private.getLevelPath(actors[1]).."meta.txt") do
		table.insert(actors, private.loadActor(line))
	end

	return actors
end

function private.loadMap(path)
	local tileMap = {}

	local currLine = 1
	for line in love.filesystem.lines(path) do
		tileMap[currLine] = {}

		for i = 1, #line do
			local c = line:sub(i, i)
			tileMap[currLine][i] = c
		end

		currLine = currLine + 1
	end

	return tileMap
end

function io.loadGame(heroName)
	local actors = private.loadActors(heroName)
	local map = private.loadMap(private.getLevelPath(actors[1]).."map.txt")

	return map, actors
end

function io.loadLevel(heroName)
	local actors = private.loadActors(heroName)
	local map = private.loadMap(private.getLevelPath(actors[1]).."map.txt")

	return map, actors
end

function private.saveHero(hero)
	local heroString = encoding.encodeHero(hero)
	love.filesystem.write(private.getHeroPath(hero.name).."stats.txt", heroString)
end

function private.saveActor(actor, path)
	local actorString = encoding.encodeActor(actor)
	love.filesystem.append(path, actorString.."\n")
end

function private.saveActors(actors)
	local path = private.getLevelPath(actors[1]).."meta.txt"
	love.filesystem.write(path, "")
	for i=2, #actors do
		private.saveActor(actors[i], path)
	end
end

function private.saveMap(tiles, path)
	love.filesystem.createDirectory(path)
	love.filesystem.write(path.."/map.txt", "")

	for y = 1, #tiles do
		local line = ''
		for x = 1, #tiles[y] do
			line = line .. tiles[y][x]
		end
		love.filesystem.append(path.."/map.txt", line.."\n")
	end
end

function io.saveGame(map, actors)
	private.saveHero(actors[1])
	private.saveActors(actors)
	private.saveMap(map, private.getLevelPath(actors[1]))
end

function io.saveLevel(map, actors)
	private.saveActors(actors)
	private.saveMap(map, private.getLevelPath(actors[1]))
end

return io