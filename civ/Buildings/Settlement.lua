require "Buildings/Building"

Settlement = Building:new{production_total = 0, production_per_turn = 1, gold_per_turn = 1, growth_tick = 4}

function Settlement:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.view = 1
  self.level = 1
  self.health = 10
  self.name = "Settlement"
  self.defense = 3
  return o
end

function Settlement:LevelUp()
  self.level = self.level + 1
  self.health = self.health + 2
end

function Settlement:NewTurn()
  self.production_total = self.production_total + self.production_per_turn
  self.race.gold = self.race.gold + self.gold_per_turn
end
