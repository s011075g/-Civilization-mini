require "Technology/Technology"

Technology_Unit_Builder = Technology:new()

function Technology_Unit_Builder:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  
  self.name = "Builder"
  self.cost_production = 2
  self.cost_gold = 4
  self.icon = image_ui_icon_unit_settler
  return o
end