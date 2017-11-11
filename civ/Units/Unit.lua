require "Utilities/Enums"
require "Race"

Unit = { race = nil, x = nil, y = nil, movement = nil, view = nil, totalhealth = nil, currenthealth = nil, image = nil, defence = nil, name = nil,
  bool_option1_exists = true , bool_option2_exists = true, bool_option3_exists = true, bool_option4_exists = false,
  bool_option1_active = false, bool_option2_active = false, bool_option3_active = false, bool_option4_active = false,
  attribute_canSwim = false, movement_currentTurn = nil, defense_buff = 0}

function Unit:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Unit:CanMoveTo(posX, posY)
  if self.movement - self.movement_currentTurn > 0 then
    if self.x + (self.movement - self.movement_currentTurn)  >= posX and self.x - (self.movement - self.movement_currentTurn) <= posX and self.y + (self.movement - self.movement_currentTurn) >= posY and self.y - (self.movement - self.movement_currentTurn) <= posY then
      return true 
    end
  end
  return false
end

function Unit:Draw(tile_size, posX, posY, uiEndX, uiEndY)
  love.graphics.draw(self.image, ((self.x + 1) - posX) * tile_size + uiEndX, ((self.y + 1) - posY) * tile_size + uiEndY)
end

function Unit:SetImage(Image)
  self.image = Image
end

function Unit:ResetOptions()
  self.bool_option1_active = false
  self.bool_option2_active = false
  self.bool_option3_active = false
  self.bool_option4_active = false
end
 
function Unit:Option1() --move
  if self.movement - self.movement_currentTurn > 0 then
    return true;
  end
  return false;
end

function Unit:Option2() --Heal and defend 
  if self.movement - self.movement_currentTurn == self.movement then --[[ and self.totalhealth ~= self.currenthealth ]]-- if I only want heal from this option
    return true
  end
  return false
end

function Unit:Option3() --Skip turn
  if self.movement - self.movement_currentTurn > 0 then
    return true
  end
  return false
end

function Unit:Option4() --reserved for unit speciality options, written here to be overrided
  return false
end

function Unit:NewTurn()
  self.movement_currentTurn = 0 
  self.defense_buff = 0 
end