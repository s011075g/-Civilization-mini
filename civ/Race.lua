Race = {colorR = 0, colorG = 0, colorB = 0,coins = 0, name = "", technology = {}}

function Race:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Race:getColor()
  return self.colorR, self.colorG, self.colorB
end

function Race:setColor(r, g, b)
  self.colorR = r
  self.colorG = g
  self.colorB = b
end

function Race:addTechnology(tech)
  self.technology[tech] = true;
end