local encoding = {}

function string:split(sSeparator, bRegexp)
   assert(sSeparator ~= '')

   local aRecord = {}

   if self:len() > 0 then
      local bPlain = not bRegexp
      nMax = -1

      local nField, nStart = 1, 1
      local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
      while nFirst and nMax ~= 0 do
         aRecord[nField] = self:sub(nStart, nFirst-1)
         nField = nField+1
         nStart = nLast+1
         nFirst,nLast = self:find(sSeparator, nStart, bPlain)
         nMax = nMax-1
      end
      aRecord[nField] = self:sub(nStart)
   end

   return aRecord
end

function encoding.encodeHero(hero)
	data = hero.name.."|"..hero.currentLevel.."|"..hero.xPos.."|"..hero.yPos.."|"..hero.hp

	return data
end

function encoding.encodeActor(actor)
	data = actor.type.."|"..actor.xPos.."|"..actor.yPos.."|"..actor.hp

	return data
end

function encoding.decode(infoString)
   data = string.split(infoString, "|")

   return data
end

return encoding