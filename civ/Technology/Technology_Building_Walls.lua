require "Technology/Technology"

Technology_Unit_Walls = Technology:new()

function Technology_Unit_Walls:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  
  self.name = "Walls"
  self.cost_production = 15
  self.cost_gold = 23
  self.icon = image_ui_icon_unit_building_walls
  return o
end