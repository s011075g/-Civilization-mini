require "Utilities/Enums"

require "Buildings/Building"
require "Units/Unit"

function createWorld()
  
  chance_grass = 1
  chance_beach = 3
  chance_forest = 2
  chance_mountain = 8 
  
  math.randomseed(os.time())
  
  matrix_tiles = {}
  
  for x=1, map_size_x, 1 do
    matrix_tiles[x] = {}
    
    for y=1, map_size_y, 1 do
      
       matrix_tiles[x][y] = {tile = nil, fog = true, inview = false, Unit = nil, Building = nil, race = nil }
      
      hold = math.random(0,25) --Chance of init grassland to build upon
      if hold == 0 then
        matrix_tiles[x][y].tile = tile_grass_plains
      else 
        matrix_tiles[x][y].tile = tile_ocean
      end
    end 
  end
  
  for x=1, map_size_x, 1 do
    for y=1, map_size_y, 1 do
      
      if x ~= 1 and y ~= 1 then
        if canAccessMap(x, y, 0) then
          if matrix_tiles[x][y].tile == tile_grass_plains then
            if matrix_tiles[x-1][y].tile == tile_ocean and matrix_tiles[x][y-1].tile == tile_ocean and matrix_tiles[x+1][y].tile == tile_ocean and matrix_tiles[x][y+1].tile == tile_ocean then
            matrix_tiles[x][y].tile = tile_ocean;
            end
          end
          if(matrix_tiles[x-1][y].tile == tile_grass_plains or matrix_tiles[x][y-1].tile == tile_grass_plains or matrix_tiles[x-1][y-1].tile == tile_grass_plains or
            matrix_tiles[x+1][y].tile == tile_grass_plains or matrix_tiles[x][y+1].tile == tile_grass_plains or matrix_tiles[x+1][y+1].tile == tile_grass_plains) then
            hold = math.random(0, chance_grass)
            if hold == 0 then
            matrix_tiles[x][y].tile = tile_grass_plains
            else 
              hold = math.random(0, chance_grass)
              if hold == 0 then
                matrix_tiles[x][y].tile = tile_grass_plains
              else 
                hold = math.random(0, chance_grass)
                if hold == 0 then
                  matrix_tiles[x][y].tile = tile_grass_plains
                end
              end
            end
          end
          if(matrix_tiles[x-1][y].tile == tile_ocean or matrix_tiles[x][y-1].tile == tile_ocean or matrix_tiles[x-1][y-1].tile == tile_ocean) and matrix_tiles[x][y].tile == tile_grass_plains then
            hold = math.random(0, chance_beach)
            if hold == 0 then
              matrix_tiles[x][y].tile = tile_beach
            end
          end
          if matrix_tiles[x][y].tile == ocean then
            if(matrix_tiles[x-1][y].tile == tile_grass_plains and matrix_tiles[x][y-1].tile == tile_grass_plains and matrix_tiles[x-1][y-1].tile == tile_grass_plains) then
              matrix_tiles[x][y].tile = tile_grass_plains
            end
          end
          if matrix_tiles[x][y].tile == tile_grass_plains then
            hold = math.random(0, chance_mountain)
            if hold == 0 then
              matrix_tiles[x][y].tile = tile_mountain
            end
          end
        end
        if(matrix_tiles[x][y].tile == tile_grass_plains) then
          hold = math.random(0,chance_forest)
          if hold == 0 then
            matrix_tiles[x][y].tile = tile_forest
          end 
        end
      end
    end
  end
end

function addUnitToMap(unit)
  if canAccessMap(unit.x, unit.y, 1) then 
    matrix_tiles[unit.x][unit.y].Unit = unit
  end
end

function addBuildingToMap(building)
  if canAccessMap(building.x, building.y, 1) then 
    matrix_tiles[building.x][building.y].Building = building
  end
end

function drawWorld(posX, posY)
  size_tile = 20
  local image = image_ocean
  
  for x = posX, map_view_x + posX, 1 do
    for y = posY, map_view_y + posY, 1 do
      love.graphics.setColor(255,255,255,255)
      if matrix_tiles[x][y].fog ~= true then
        if matrix_tiles[x][y].inview == false then
          love.graphics.setColor(170,170,170,255)
        end
        if matrix_tiles[x][y].tile == tile_grass_plains then
          image = image_grass_plain
        elseif matrix_tiles[x][y].tile == tile_forest then
          image = image_forest
        elseif matrix_tiles[x][y].tile == tile_ocean then
          --love.graphics.setColor(100,140,240,255)
          image = image_ocean
        elseif matrix_tiles[x][y].tile == tile_beach then
          image = image_beach
        elseif matrix_tiles[x][y].tile == tile_mountain then
          image = image_mountain
        end
      else 
        image = image_fog 
      end
      love.graphics.draw(image, ((x + 1) - posX) * size_tile + ui_end_x, ((y + 1) - posY) * size_tile + ui_end_y) 
      
      if matrix_tiles[x][y].Building ~= nil and matrix_tiles[x][y].inview == true then
        if matrix_tiles[x][y].Building.race == human then matrix_tiles[x][y].Building:Draw(size_tile, posX, posY, ui_end_x, ui_end_y) 
        elseif matrix_tiles[x][y].fog == false then matrix_tiles[x][y].Building:Draw(size_tile, posX, posY, ui_end_x, ui_end_y) 
        end
      end
      if matrix_tiles[x][y].Unit ~= nil and matrix_tiles[x][y].inview == true then
        if matrix_tiles[x][y].Unit.race == human then matrix_tiles[x][y].Unit:Draw(size_tile, posX, posY, ui_end_x, ui_end_y) 
        elseif matrix_tiles[x][y].inview == true then matrix_tiles[x][y].Building:Draw(size_tile, posX, posY, ui_end_x, ui_end_y) 
        end
      end
    end
  end
  for x = posX, map_view_x + posX, 1 do
    for y = posY, map_view_y + posY, 1 do
      local bool_N, bool_E, bool_S, bool_W = false, false, false, false
      if matrix_tiles[x][y].race ~= nil then
        if canAccessMap(x, y - 1, 0) then
          if matrix_tiles[x][y].race ~= matrix_tiles[x][y - 1].race then bool_N = true end
        end
        if canAccessMap(x + 1, y, 0) then
          if matrix_tiles[x][y].race ~= matrix_tiles[x + 1][y].race then bool_E = true end
        end
        if canAccessMap(x, y + 1, 0) then
          if matrix_tiles[x][y].race ~= matrix_tiles[x][y + 1].race then bool_S = true end
        end
        if canAccessMap(x - 1, y, 0) then
          if matrix_tiles[x][y].race ~= matrix_tiles[x - 1][y].race then bool_W = true end
        end
        drawBoarders(x, y, bool_N, bool_E, bool_S, bool_W, matrix_tiles[x][y].race, posX, posY)
      end
    end
  end
end

function resetViewableFog()
  for x = 1, map_size_x, 1 do
    for y = 1, map_size_y, 1 do
      matrix_tiles[x][y].inview = false;
    end
  end
end

function drawBoarders(x, y, bool_N, bool_E, bool_S, bool_W, race, posX, posY)
  local r, g, b = race:getColor()
  love.graphics.setColor(r,g,b,255)
  if bool_N then love.graphics.rectangle("fill", ((x + 1) - posX) * size_tile + ui_end_x, ((y + 1) - posY) * size_tile + ui_end_y, 20, 1) end
  if bool_E then love.graphics.rectangle("fill", ((x + 1) - posX) * size_tile + ui_end_x + 20, ((y + 1) - posY) * size_tile + ui_end_y, 1, 20) end
  if bool_S then love.graphics.rectangle("fill", ((x + 1) - posX) * size_tile + ui_end_x, ((y + 1) - posY) * size_tile + ui_end_y + 20, 20, 1) end
  if bool_W then love.graphics.rectangle("fill", ((x + 1) - posX) * size_tile + ui_end_x, ((y + 1) - posY) * size_tile + ui_end_y, 1, 20) end


end

function clearFog(posx, posy)
  if canAccessMap(posx, posy, 1) then 
    matrix_tiles[posx][posy].fog = false 
    matrix_tiles[posx][posy].inview = true;
  end
end

function clearFogArea(posx, posy, view)
  if canAccessMap(posx, posy, 1) then
    if matrix_tiles[posx][posy].fog == true then matrix_tiles[posx][posy].fog = false end
    
    for x = -view, view, 1 do
      for y = -view, view, 1 do
        
        clearFog(posx + x, posy + y)
        
      end
    end
  end
end
function clearFogAreaUnitsAndBuildings()
  for x = 1, map_size_x, 1 do
    for y = 1, map_size_y, 1 do
      if matrix_tiles[x][y].Building ~= nil then
        if matrix_tiles[x][y].Building.race == human then clearFogArea(x, y, matrix_tiles[x][y].Building.view) end
      end
      if matrix_tiles[x][y].Unit ~= nil then
        if matrix_tiles[x][y].Unit.race == human then clearFogArea(x, y, matrix_tiles[x][y].Unit.view) end
      end
    end
  end
end
function drawMiniMap(posX, posY, scale, cornerX, cornerY)
  for x = 1, map_size_x, 1 do
    for y = 1, map_size_y, 1 do
      if matrix_tiles[x][y].fog ~= true then
        if matrix_tiles[x][y].Building ~= nil and matrix_tiles[x][y].Building.race ~= nil then
          local r,g,b = matrix_tiles[x][y].Building.race:getColor()
          love.graphics.setColor(r,g,b,255)
        else
          if matrix_tiles[x][y].tile == tile_grass_plains then
            love.graphics.setColor(033,206,015,255)
          elseif matrix_tiles[x][y].tile  == tile_forest then
            love.graphics.setColor(040,206,030,255)
          elseif matrix_tiles[x][y].tile  == tile_ocean then
            love.graphics.setColor(039,128,255,255)
          elseif matrix_tiles[x][y].tile  == tile_beach then
            love.graphics.setColor(255,255,000,255)
          elseif matrix_tiles[x][y].tile  == tile_mountain then 
            love.graphics.setColor(210,210,210,255)
          end
        end
      else
        love.graphics.setColor(110,110,110,255)
      end
      love.graphics.rectangle("fill", x * scale + (posX - scale), y * scale + (posY - scale), scale, scale) --(x + posX) * scale ,(y + posY) * scale
    end
  end
  love.graphics.setColor(255,10,10,255)
  love.graphics.rectangle("line", posX + cornerX * scale - scale, posY + cornerY * scale - scale, scale * map_view_x + scale, scale * map_view_y + scale)
end

function canAccessMap(x, y, z)
  if x > 0  and y > 0  and x < map_size_x + z and y < map_size_y + z then 
    return true end
  return false
end

function getTileDetails(x, y, xCorner, yCorner)
  if canAccessMap(x + xCorner, y + yCorner, 0) then
    return matrix_tiles[x + xCorner][y + yCorner].tile, matrix_tiles[x + xCorner][y + yCorner].Unit, matrix_tiles[x + xCorner][y + yCorner].Building
  end
end

function moveUnit(x, y, toX, toY)
  if canAccessMap(x, y, 0) and canAccessMap(toX, toY, 0) then --are the positions on the map
    if matrix_tiles[toX][toY].tile ~= nil and matrix_tiles[toX][toY].Unit == nil and matrix_tiles[x][y].tile ~= nil and matrix_tiles[x][y].Unit ~= nil then--are the values suitable to move a unit
      if matrix_tiles[x][y].Unit:CanMoveTo(toX, toY) then --can it move
        if matrix_tiles[toX][toY].tile ~= tile_ocean or matrix_tiles[x][y].Unit.attribute_canSwim == true then
          if matrix_tiles[toX][toY].tile ~= tile_mountain then
            unit = matrix_tiles[x][y].Unit
            matrix_tiles[x][y].Unit = nil
            matrix_tiles[toX][toY].Unit = unit
            matrix_tiles[toX][toY].Unit.x = toX
            matrix_tiles[toX][toY].Unit.y = toY
            matrix_tiles[toX][toY].Unit.movement_currentTurn = matrix_tiles[toX][toY].Unit.movement_currentTurn + math.abs(x - toX) + math.abs(y - toY) --adds up the distance traveled 
          end
        end
      end
    end
  end
end

function moveUnitInput(unit)
  for x = -(unit.movement - unit.movement_currentTurn), unit.movement - unit.movement_currentTurn, 1 do
    for y = -(unit.movement - unit.movement_currentTurn), unit.movement - unit.movement_currentTurn, 1 do
      local tempX = math.abs(x)
      local tempY = math.abs(y)
      if tempX + tempY <= unit.movement - unit.movement_currentTurn then
        if movementSelection(x, y, unit.x, unit.y, unit.race) then
          moveUnit(unit.x, unit.y, unit.x + x, unit.y + y)
          return true
        end
      end
    end
  end 
end

function movementSelection(posX, posY, currentPosX, currentPosY, race)
  local x, y = love.mouse.getPosition();
  local bool = false
  
  local tempX = currentPosX + posX
  local tempY = currentPosY + posY
  
  if tempX < map_view_cornerX or tempY < map_view_cornerY or tempX > map_size_x - 1 or tempY > map_size_y - 1 then return false
  elseif posX == 0 and posY == 0 then return false
  elseif canAccessMap (tempX, tempY, 0) then
    if matrix_tiles[tempX][tempY].fog == true then  return false end
    if matrix_tiles[tempX][tempY].tile == tile_ocean and Unit.attribute_canSwim == false then return false end
    if matrix_tiles[tempX][tempY].tile == tile_mountain then return false end
    if matrix_tiles[tempX][tempY].race ~= race and matrix_tiles[tempX][tempY].race ~= nil then return false end
  end
  posX = (ui_end_x + size_tile) + (tempX - map_view_cornerX) * size_tile
  posY = (ui_end_y + size_tile) + (tempY - map_view_cornerY) * size_tile
  
  if(x < posX + 20 and x > posX) and (y < posY + 20 and y > posY) then if (love.mouse.isDown(1)) then bool = true end end
  love.graphics.setColor(255,70,70,255)
  love.graphics.rectangle("fill", posX + 5, posY + 5, 10, 10)
  return bool
end

function newTurn()
  for x = 1, map_size_x, 1 do
    for y = 1, map_size_y, 1 do
      if matrix_tiles[x][y].Unit ~= nil then 
         matrix_tiles[x][y].Unit:NewTurn()
      end
      if matrix_tiles[x][y].Building ~= nil then
        matrix_tiles[x][y].Building:NewTurn()
      end
    end
  end
end

function transformSettler()
  for x = 1, map_size_x, 1 do
    for y = 1, map_size_y, 1 do
      if matrix_tiles[x][y].Unit ~= nil and matrix_tiles[x][y].Building == nil and matrix_tiles[x][y].tile ~= tile_ocean then 
        if matrix_tiles[x][y].Unit.name == "Settler" and matrix_tiles[x][y].Unit.bool_option4_active == true then
          matrix_tiles[x][y].Unit.bool_option4_active = false
          local settle = Settlement:new()
          settle:SetImage(image_building_settlement_1)
          settle.race = matrix_tiles[x][y].Unit.race
          settle.x = x
          settle.y = y
          matrix_tiles[x][y].Building = settle
          matrix_tiles[x][y].Unit = nil
          captureTile(x-1, y-1, settle.race)
          captureTile(x-1, y, settle.race)
          captureTile(x-1, y+1, settle.race)
          captureTile(x, y-1, settle.race)
          captureTile(x, y, settle.race)
          captureTile(x, y+1, settle.race)
          captureTile(x+1, y-1, settle.race)
          captureTile(x+1, y, settle.race)
          captureTile(x+1, y+1, settle.race)
        end
      end
    end
  end
end
function createStart()
  for x = 1, map_size_x, 1 do
    for y = 1, map_size_y, 1 do
      if canAccessMap(x, y, 0) then
        if matrix_tiles[x][y].tile == tile_grass_plains or matrix_tiles[x][y].tile == tile_forest or matrix_tiles[x][y].tile == tile_beach then
          if canAccessMap(x+1, y, 0) and canAccessMap(x-1, y, 0) and canAccessMap(x, y+1,0) and canAccessMap(x, y-1,0) then
            if(matrix_tiles[x+1][y].tile == tile_grass_plains or matrix_tiles[x+1][y].tile == tile_forest or matrix_tiles[x+1][y].tile == tile_beach) and
              (matrix_tiles[x-1][y].tile == tile_grass_plains or matrix_tiles[x-1][y].tile == tile_forest or matrix_tiles[x-1][y].tile == tile_beach) and
              (matrix_tiles[x][y+1].tile == tile_grass_plains or matrix_tiles[x][y+1].tile == tile_forest or matrix_tiles[x][y+1].tile == tile_beach) and
              (matrix_tiles[x][y-1].tile == tile_grass_plains or matrix_tiles[x][y-1].tile == tile_forest or matrix_tiles[x][y-1].tile == tile_beach) then
                return true, x, y;
            end
          end
        end
      end
    end
  end
  return false, -1, -1;
end

function captureTile(x, y, race)
  if canAccessMap(x, y, 0) then
    if matrix_tiles[x][y].race == nil then
      matrix_tiles[x][y].race = race
    end
  end
end

function captureTileFromOther(x, y, FromRace, ToRace)
  if canAccessMap(x, y, 0) then
    if matrix_tiles[x-1][y].race == FromRace then
      matrix_tiles[x-1][y].race = race
    end
  end
end