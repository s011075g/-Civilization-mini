require "Technology/Technology"

Technology_Unit_Settler = Technology:new()

function Technology_Unit_Settler:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  
  self.name = "Settler"
  self.cost_production = 5
  self.cost_gold = 10
  self.icon = image_ui_icon_unit_settler
  return o
end