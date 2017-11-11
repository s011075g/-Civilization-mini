require "Units/Unit"

Builder = Unit:new()

function Builder:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.movement = 2
  self.view = 1
  self.totalhealth = 1
  self.currenthealth = 1
  self.defence = 1
  self.defense_buff = 0
  self.movement_currentTurn = self.movement 
  self.name = "Builder"
  return o
end
