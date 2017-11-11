require "Utilities/Enums"
require "Units/Unit"
require "Technology/Technology"
require "Technology/Technology_Unit_Settler"
require "Technology/Technology_Unit_Scout"
require "Technology/Technology_Unit_Builder"
require "Technology/Technology_Unit_Warrior"


function LoadUI()
  bool_window_help = false
  bool_mouse_left_down = false
  bool_unit_action_settler_transform = false
  bool_unit_action_move = false
  unit_action_move = nil
  
  bool_ui_building_settlement = false
  
  create_unit_bool = false
  create_unit_type = nil
  create_unit_pos = { x = 0, y = 0}
  
  ui_end_x = 0
  ui_end_y = 20
  
  page_number = 0
  
 
  
  font = love.graphics.newFont("Font/coolvetica rg.ttf")
  text_title = love.graphics.newText(font, "Civilization 1.2.1")
  text_top_bar = love.graphics.newText(font, "Resources: ")
  text_help_title = love.graphics.newText(font, "Help - Controls")
  text_help_controls = love.graphics.newText(font, "H - Help - Toggle \nM - Hide Mini-Map - Toggle\nArrow Keys - Move tile selection around - Press and hold\nEscape - Takes you to the main menu, if you press start it'll take you back into the same game instance - Press")
  
  text_example = love.graphics.newText(font, "Start")
  text_debug = love.graphics.newText(font, "Hello World")
  
  text_menu_StartGame = love.graphics.newText(font, "Start Game")
  text_menu_StartGame_start = love.graphics.newText(font, "Start")
  text_menu_LoadGame = love.graphics.newText(font, "Load Game")
  text_menu_Credits = love.graphics.newText(font, "Credits")
  text_menu_Credits_credits = love.graphics.newText(font, "Everything by Paul")
  text_menu_Exit = love.graphics.newText(font, "Exit")
  
  text_unit_details = love.graphics.newText(font, "")
  text_unit_details_view = love.graphics.newText(font, "View")
  text_unit_details_movement = love.graphics.newText(font, "Movement")
  
  text_button_turn = love.graphics.newText(font, "Next turn")
  text_information_turn = love.graphics.newText(font, "")
  
  text_building_details = love.graphics.newText(font, "")
  
  text_building_production = love.graphics.newText(font, "")
end

function drawMenu()
  local gap = 10
  local fontsize = 2;
  local bool_startGame = false
  local bool_loadGame = false
  local bool_credits = false
  local bool_exit = false
  
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(text_title, 100, 40,0,3,3,0,0,0,0)
  
  if Button(100, 100 + gap, text_menu_StartGame:getWidth() + 1, text_menu_StartGame:getHeight(), text_menu_StartGame, false) then
    bool_startGame = true
  end
  --[[if Button(100, 100 + text_menu_LoadGame:getHeight() + gap * 2, text_menu_LoadGame:getWidth() + 1, text_menu_LoadGame:getHeight(), text_menu_LoadGame) then
    bool_loadGame = true
  end]]--
  if Button(100, 100 + text_menu_Credits:getHeight() + gap * 2, text_menu_Credits:getWidth() + 1, text_menu_Credits:getHeight(), text_menu_Credits, true) then
    bool_credits = true
  end
  if Button(100, 100 + text_menu_Exit:getHeight()*2 + gap * 3, text_menu_Exit:getWidth() + 1, text_menu_Exit:getHeight(), text_menu_Exit, false) then
    bool_exit = true;
  end
  return bool_startGame, bool_loadGame, bool_credits, bool_exit
end

function drawMenuCredits()
   love.graphics.setColor(255,255,255,255)
   love.graphics.draw(text_menu_Credits_credits, 400,100,0,1,1,0,0,0,0)
end

function drawUI(uistart, selectedX, selectedY)
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("fill", 0, 0, windowWidth, ui_end_y) 
  
  love.graphics.setColor(0,0,0,255)
  text_top_bar:set("Gold: "..human.gold)
  drawDrawable(text_top_bar, 10, 3,1,1)
  
  text_information_turn:set("Turn: "..count_turns)
  drawDrawable(text_information_turn, windowWidth - text_information_turn:getWidth() * 2, 0,1.5,1.5) 
  
  love.graphics.setColor(255,10,10,255)
  love.graphics.rectangle("line", selectedX * size_tile + ui_end_x, selectedY * size_tile + ui_end_y, size_tile, size_tile)
  if bool_window_help == true then drawHelpWindow() end
  
  if Button(windowWidth - (text_button_turn:getWidth() + 10), ui_end_y, text_button_turn:getWidth() + 10, 20, text_button_turn, false) then 
    count_turns = count_turns + 1 
    bool_turn_reset = true
  end
  
  love.graphics.setColor(255,255,255,255)
  
end

function drawUIUnit(Unit, tile)
  love.graphics.setColor(255,255,255,255)
  drawDrawable(image_ui_background, 0, windowHeight - 180, 1, 1)
  image = nil
  if tile.tile == tile_grass_plains then
    image = image_ui_background_plains
  elseif tile.tile == tile_beach then
    image = image_ui_background_beach
  elseif tile.tile == tile_forest then
    image = image_ui_background_forest
  elseif tile.tile == tile_ocean then
    image = image_ui_background_ocean
  elseif tile.tile == tile_mountain then
    image = image_ui_background_mountain
  end
  drawDrawable(image, 0, windowHeight - 180, 1, 1)
  
  drawUIUnitDetails(Unit)
  
  local padding = 0
  if Unit.bool_option1_exists and Unit:Option1() then
    Unit.bool_option1_active = ButtonImage(182 + 190 + padding, windowHeight - 65, 60, 60, image_ui_button_disc, image_ui_button_disc_move, Unit.bool_option1_active)
    padding = padding + 65
    if Unit.bool_option1_active then
      bool_unit_action_move = true
      unit_action_move = Unit
    elseif bool_unit_action_move then
      bool_unit_action_move = false
      unit_action_move = nil
    end
  end
  
  if Unit.bool_option2_exists and Unit:Option2() then
    Unit.bool_option2_active = ButtonImage(182 + 190 + padding, windowHeight - 65, 60, 60, image_ui_button_disc, image_ui_button_disc_heal, Unit.bool_option2_active)
    padding = padding + 65
    if Unit.bool_option2_active and Unit.currenthealth < Unit.totalhealth then
      Unit.currenthealth = Unit.currenthealth + 1
      Unit.movement_currentTurn = Unit.movement
      Unit.bool_option2_active = false
      Unit.defense_buff = Unit.defense_buff + 1
    elseif Unit.bool_option2_active and Unit.currenthealth == Unit.totalhealth then
      Unit.defense_buff = Unit.defense_buff + 1
      Unit.movement_currentTurn = Unit.movement
      Unit.bool_option2_active = false
    end
  end
  
  if Unit.bool_option3_exists and Unit:Option3() then
    Unit.bool_option3_active = ButtonImage(182 + 190 + padding, windowHeight - 65, 60, 60, image_ui_button_disc, image_ui_button_disc_skip, Unit.bool_option3_active)
    padding = padding + 65
    if Unit.bool_option3_active then
      Unit.movement_currentTurn = Unit.movement
      Unit.bool_option3_active = false
    end
  end
  
  if Unit.bool_option4_exists and Unit:Option4() and tile.tile ~= tile_ocean and tile.Building == nil then
    image = image_ui_button_disc
    if Unit.name == "Settler" then
      image = image_ui_button_disc_settle
    end
    Unit.bool_option4_active = ButtonImage(182 + 190 + padding, windowHeight - 65, 60, 60, image_ui_button_disc, image, Unit.bool_option4_active)
    padding = padding + 65
    if Unit.bool_option4_active then
      if Unit.name == "Settler" then
        bool_unit_action_settler_transform = true
      end
      Unit.movement_currentTurn = Unit.movement
    end
  end
  
end

function drawUIUnitDetails(Unit)
  image = nil
  if Unit ~= nil then
    if Unit.name == "Settler" then --where to add more Unit images
      image = image_ui_background_unit_settler
    elseif Unit.name == "Scout" then
      image = image_ui_background_unit_scout
    elseif Unit.name == "Builder" then
      image = image_ui_background_unit_builder
    elseif Unit.name == "Warrior" then
      image = image_ui_background_unit_warrior
    end
    love.graphics.setColor(255,255,255,255)
    --Unit image
    drawDrawable(image, 0, windowHeight - 180, 1, 1)
    --details board
    drawDrawable(image_ui_unit_details, 182, windowHeight - 138, 1, 1)
    --name
    love.graphics.setColor(0,0,0,255)
    text_unit_details:set(Unit.name)
    drawDrawable(text_unit_details, 182 + text_unit_details:getWidth() / 2, windowHeight - 138 + 12, 1, 1)
    --view
    text_unit_details:set(Unit.view)
    drawDrawable(text_unit_details, 182 + 26, windowHeight - 138 + 58, 1, 1)
    drawDrawable(text_unit_details_view, 182 + 50 + text_unit_details:getWidth(), windowHeight - 138 + 58, 1, 1)
    --movement
    text_unit_details:set(Unit.movement)
    drawDrawable(text_unit_details, 182 + 26, windowHeight - 138 + 88, 1, 1)
    drawDrawable(text_unit_details_movement, 182 + 50 + text_unit_details:getWidth(), windowHeight - 138 + 87, 1, 1)
    --health
    love.graphics.setColor(10,255,100,255)
    length = 156 * (Unit.currenthealth / Unit.totalhealth)
    love.graphics.rectangle("fill", 182 + 12, windowHeight - 138 + 32, length, 10)
    love.graphics.setColor(0,0,0,255)
    text_unit_details:set(Unit.currenthealth.."/"..Unit.totalhealth.." health")
    drawDrawable(text_unit_details, 182 + 12 + text_unit_details:getWidth(), windowHeight - 138 + 30, 1, 1)
    --defence
    love.graphics.setColor(255,255,255,255)
    drawDrawable(image_ui_unit_details_sheild, 182, windowHeight - 138, 1, 1)
    love.graphics.setColor(0,0,0,255)
    text_unit_details:set(Unit.defence + Unit.defense_buff)
    drawDrawable(text_unit_details, 182 + 155, windowHeight - 138 + 35, 1, 1)
  end
end

function drawUIBuilding(Building, TileType, Unit)
  if Building.name == "Settlement" then
    image = image_ui_button_disc_in
    if bool_ui_building_settlement then image = image_ui_button_disc_out end
    bool_ui_building_settlement = ButtonImage(5, windowHeight - 65, 60, 60, image_ui_button_disc, image, bool_ui_building_settlement)
    if bool_ui_building_settlement then
      love.graphics.setColor(127,51,0,230)
      local startBoxX = ui_end_x + 40
      local startBoxY = ui_end_y + 40
    
      love.graphics.rectangle("fill", startBoxX,startBoxY, windowWidth - (400 + startBoxX), windowHeight - (40 + startBoxY))
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("fill", startBoxX + 20, startBoxY + 20, windowHeight - (362 + startBoxY), 20)
      love.graphics.setColor(0,0,0,255)
      text_building_details:set(Building.race.name .. " " .. Building.name .. "          Level: "..Building.level)
      drawDrawable(text_building_details, startBoxX + 21, startBoxY + 20, 1.2, 1.2)
      
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("fill", windowHeight - (362 + startBoxY) + 115, startBoxY + 20, 420, 20)
      
      love.graphics.setColor(0,0,0,255)
      text_building_details:set("Health: "..Building.health.."                   Defense: "..Building.defense.."  ")
      drawDrawable(text_building_details, windowHeight - (362 + startBoxY) + 135, startBoxY + 20, 1.2, 1.2)
       
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("fill", windowHeight - (362 + startBoxY) + 115, startBoxY + 90, 420, 30)
       
      love.graphics.setColor(0,0,0,255)
      text_building_details:set("Total:\nProduction: "..Building.production_total)
      drawDrawable(text_building_details, windowHeight - (358 + startBoxY) + 115, startBoxY + 88, 1.2, 1.2)
       
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("fill", windowHeight - (362 + startBoxY) + 115, startBoxY + 150, 420, 30)
      love.graphics.setColor(0,0,0,255)
      text_building_details:set("Per Turn:\nProduction: "..Building.production_per_turn .."                   Gold: "..Building.gold_per_turn)
      drawDrawable(text_building_details, windowHeight - (358 + startBoxY) + 115, startBoxY + 148, 1.2, 1.2)
      
      love.graphics.setColor(255,255,255,255)
      love.graphics.rectangle("fill", windowHeight - (362 + startBoxY) + 115, startBoxY + 210, 420, 360)
       
      drawUIProductionList(startBoxX + 20, startBoxY + 55, Building.race, Building, Unit)
    end
  end
end

function drawUIProductionList(cornerX, cornerY, race, Building, Unit)
  if bool_ui_building_settlement ~= true then
    page_number = 0
  end
  
  page_max = 0
  
  love.graphics.setColor(255,255,255,255)
  
  if ButtonImage1(cornerX + 2, cornerY, 30, 30, image_ui_button_arrow_left) then
    if page_number > 0 then page_number = page_number - 1 end
  end
  if ButtonImage1(cornerX + 268, cornerY, 30, 30, image_ui_button_arrow_right) then
    if page_number < page_max then page_number = page_number + 1 end
  end
  
  local x = cornerX
  local y = cornerY + 40
  
  love.graphics.setColor(255,255,255,255)
  text_building_production:set("Production list")
  drawDrawable(text_building_production, x + 70, y - 40, 2, 2)
  
  love.graphics.setColor(147,71,20,255)
  love.graphics.rectangle("fill", cornerX, cornerY + 40, 300, 480)
  
  
  local offset = 0
  if Unit == nil then
    if race.technology[technology_unit_settler] and page_number == 0 then drawUIBuildingProductionBox(technology_unit_settler, x, y, Building); offset = offset + 80 end
    if race.technology[technology_unit_scout] and page_number == 0 then drawUIBuildingProductionBox(technology_unit_scout, x, y + offset, Building); offset = offset + 80 end
    if race.technology[technology_unit_builder] and page_number == 0 then drawUIBuildingProductionBox(technology_unit_builder, x, y + offset, Building); offset = offset + 80 end
    if race.technology[technology_unit_warrior] and page_number == 0 then drawUIBuildingProductionBox(technology_unit_warrior, x, y + offset, Building); offset = offset + 80 end
    --if race.technology[technology_building_wall] and page_number == 0 then drawUIBuildingProductionBox(technology_building_wall, x, y + offset, Building); offset = offset + 80 end
    --if race.technology[technology_unit_scout] and page_number == 0 then drawUIBuildingProductionBox(technology_unit_scout, x, y + offset, Building); offset = offset + 80 end
  end

end

function drawUIBuildingProductionBox(value, x, y, Building)
  love.graphics.setColor(87,11,0,255)
    love.graphics.rectangle("line", x, y, 300, 80)
  tech = nil
  if value == technology_unit_settler then tech = Technology_Unit_Settler:new()
  elseif value == technology_unit_scout then tech = Technology_Unit_Scout:new()
  elseif value == technology_unit_builder then tech = Technology_Unit_Builder:new()
  elseif value == technology_unit_warrior then tech = Technology_Unit_Warrior:new()
  end
  text_building_production:set(tech.name)
  love.graphics.setColor(255,255,255,255)
  drawDrawable(text_building_production, x + 7, y + 7, 1, 1)
  drawDrawable(tech.icon, x + 7, y + 30, 1, 1)
  text_building_production:set("Production: "..tech.cost_production)
  drawDrawable(text_building_production, x + 45, y + 20, 1, 1)
  text_building_production:set("Production")
  if Building.production_total >= tech.cost_production then
    if Button(x + 120, y + 20, text_building_production:getWidth(), text_building_production:getHeight(), text_building_production, false) then
      if create_unit_bool == false then
        Building.production_total = Building.production_total - tech.cost_production
        create_unit_bool = true
        create_unit_type = value
        create_unit_pos.x = Building.x
        create_unit_pos.y = Building.y
      end
    end
  end
  love.graphics.setColor(255,255,255,255)
  text_building_production:set("Gold: "..tech.cost_gold)
  drawDrawable(text_building_production, x + 45, y + 45, 1, 1)
  text_building_production:set("Gold")
  if Building.race.gold >= tech.cost_gold then
    if Button(x + 120, y + 45, text_building_production:getWidth(), text_building_production:getHeight(), text_building_production, false) then
      if create_unit_bool == false then
        Building.race.gold = Building.race.gold - tech.cost_gold
        create_unit_bool = true
        create_unit_type = value
        create_unit_pos.x = Building.x
        create_unit_pos.y = Building.y
      end
    end
  end
  love.graphics.setColor(255,255,255,255)
end

function drawDrawable(drawable, x, y, scalex, scaley)
  if drawable ~= nil and x ~= nil and y ~= nil and scalex ~= nil and scaley ~= nil then
    love.graphics.draw(drawable, x, y, 0, scalex, scaley, 0, 0, 0, 0)
  end
end

function drawHelpWindow()
  love.graphics.setColor(180,180,180,210)
  love.graphics.rectangle("fill", windowHeight/6, windowHeight/6, windowHeight/1.5,windowHeight/1.5)
  love.graphics.setColor(0,0,0,255)
  love.graphics.draw(text_help_title, windowHeight/6 + ui_end_x + 3, windowHeight/6 + 3 + ui_end_y,0,1.5,1.5,0,0,0,0)
  love.graphics.draw(text_help_controls, windowHeight/6 + ui_end_x + 3, windowHeight/6 + 25 + ui_end_y,0,1.2,1.2,0,0,0,0)
end
function Button(posX, posY, width, length, text, isRepeating)
  local x, y = love.mouse.getPosition();
  local bool = false
  if(x < posX + width and x > posX) and (y < posY + length and y > posY) then
    love.graphics.setColor(0,0,0,255)
    if isRepeating == false then
      if love.mouse.isDown(1) and bool_mouse_left_down == false then
        love.graphics.setColor(50,50,50,255)
        bool = true;
        bool_mouse_left_down = true
      elseif (love.mouse.isDown(1)) == false then
        bool_mouse_left_down = false
      end
    else
      if love.mouse.isDown(1) then
        love.graphics.setColor(50,50,50,255)
        bool = true;
      end
    end
  else love.graphics.setColor(180,180,180,255)
  end
  love.graphics.rectangle("line", posX, posY, width, length)
  if bool ~= true then love.graphics.setColor(255,255,255,255)
  else love.graphics.setColor(235,235,235,255) end
  love.graphics.rectangle("fill", posX, posY, width, length)
  love.graphics.setColor(0,0,0,255)
  love.graphics.draw(text, posX+1, posY+1, 0,1,1,0,0,0,0)
  return bool
end

function ButtonColor(posX, posY, width, length, r, g, b)
  local x, y = love.mouse.getPosition();
  local bool = false
  if(x < posX + width and x > posX) and (y < posY + length and y > posY) then
    if (love.mouse.isDown(1)) then
      bool = true;
    end
  end
  love.graphics.setColor(r,g,b,255)
  love.graphics.rectangle("fill", posX, posY, width, length)
  return bool
end

function ButtonImage1(posX, posY, width, length, image)
  local x, y = love.mouse.getPosition();
  local bool = false
  love.graphics.setColor(255,255,255,255)
  if(x < posX + width and x > posX) and 
    (y < posY + length and y > posY) then
    if (love.mouse.isDown(1)) and bool_mouse_left_down == false then
      bool = not bool;
      bool_mouse_left_down = true
    elseif (love.mouse.isDown(1)) == false then
      bool_mouse_left_down = false
    end
  end
    if bool == true then love.graphics.setColor(130,130,130,255) end
  drawDrawable(image, posX, posY, 1, 1)
  return bool
end
function ButtonImage(posX, posY, width, length, image, image2, pressed)
  local x, y = love.mouse.getPosition();
  local bool = pressed
  love.graphics.setColor(255,255,255,255)
  if(x < posX + width and x > posX) and 
    (y < posY + length and y > posY) then
    if (love.mouse.isDown(1)) and bool_mouse_left_down == false then
      bool = not bool
      bool_mouse_left_down = true
    elseif (love.mouse.isDown(1)) == false then
      bool_mouse_left_down = false
    end
  end
  drawDrawable(image, posX, posY, 1, 1)
  if bool == true then love.graphics.setColor(130,130,130,255) end
  drawDrawable(image2, posX, posY, 1, 1)
  return bool
end
