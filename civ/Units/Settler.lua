require "Units/Unit"

Settler = Unit:new()

function Settler:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.movement = 2
  self.view = 1
  self.totalhealth = 1
  self.currenthealth = 1
  self.defence = 1
  self.defense_buff = 0
  self.name = "Settler"
  self.movement_currentTurn = self.movement 
  self.bool_option4_exists = true
  return o
end

function Settler:CanSettleHere(tile)
  if tile == tile_grass_plains or tile == tile_forest then
    return true end
  return false
end

function Unit:Option4() --reserved for unit speciality options, here to be overrided
  if self.movement - self.movement_currentTurn > 0 then
    return true
  end
  return false
end

