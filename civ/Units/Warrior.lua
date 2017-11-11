require "Units/Unit"

Warrior = Unit:new()

function Warrior:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.movement = 3
  self.view = 2
  self.totalhealth = 3
  self.currenthealth = 3
  self.defence = 3
  self.defense_buff = 0
  self.movement_currentTurn = self.movement 
  self.name = "Warrior"
  return o
end
