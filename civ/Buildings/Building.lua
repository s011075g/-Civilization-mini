require "Utilities/Enums"
require "Race"

Building = { race = nil, x = nil, y = nil, view = nil, health = nil, image = nil, level = nil, name = nil, defense = nil}

function Building:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Building:Draw(tile_size, posX, posY, uiEndX, uiEndY)
  love.graphics.draw(self.image, ((self.x + 1) - posX) * tile_size + uiEndX, ((self.y + 1) - posY) * tile_size + uiEndY)
end

function Building:SetImage(Image)
  self.image = Image
end

function Building:NewTurn()
  
end