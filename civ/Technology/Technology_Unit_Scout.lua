require "Technology/Technology"

Technology_Unit_Scout = Technology:new()

function Technology_Unit_Scout:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  
  self.name = "Scout"
  self.cost_production = 2
  self.cost_gold = 5
  self.icon = image_ui_icon_unit_settler
  return o
end