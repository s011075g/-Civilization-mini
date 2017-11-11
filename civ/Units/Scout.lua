require "Units/Unit"

Scout = Unit:new()

function Scout:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.movement = 3
  self.movement_currentTurn = self.movement 
  self.view = 3
  self.totalhealth = 3
  self.currenthealth = 3
  self.defence = 2
  self.defense_buff = 0
  self.name = "Scout"
  return o
end
