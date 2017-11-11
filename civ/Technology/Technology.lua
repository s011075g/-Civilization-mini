Technology = {name = nil, cost_production = 0, cost_gold = 0, icon = nil}

function Technology:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end