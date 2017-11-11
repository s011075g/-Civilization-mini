require "Technology/Technology"

Technology_Unit_Warrior = Technology:new()

function Technology_Unit_Warrior:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  
  self.name = "Warrior"
  self.cost_production = 4
  self.cost_gold = 8
  self.icon = image_ui_icon_unit_settler
  return o
end