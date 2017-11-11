require "WorldManager"
require "UIManager"
require "Race"
require "Units/Unit"
require "Units/Settler"
require "Units/Scout"
require "Units/Builder"
require "Units/Warrior"
require "Buildings/Building"
require "Buildings/Settlement"
require "Utilities/Enums"

--require('mobdebug').start()
--require('mobdebug').off()

function love.load()
	
  --love.window.setFullscreen(true);
  
  gamestate = gamestate_menu
  
  map_view_x = 61
  map_view_y = 32
  
  map_size_x = 75
  map_size_y = 45
  
  map_view_cornerX = 1
  map_view_cornerY = 1
  
  selectedX = 0
  selectedY = 0
  
  count_turns = 1;
  bool_turn_reset = false
  bool_playing = false
  
  LoadUI()
  createWorld()
  love.keyboard.setKeyRepeat(true)
  loadImages()
  
  love.graphics.setBackgroundColor(60,60,60)
  bool_start, bool_load, bool_credits, bool_exit, bool_hide_minimap = false ,false, false, false, false
  
  --[[]]--
  human = Race:new()
  human:setColor(255,20,20)
  human.name = "Human"
  
  human.gold = 10
  
  human:addTechnology(technology_unit_settler)
  human:addTechnology(technology_unit_scout)
  human:addTechnology(technology_unit_builder)
  human:addTechnology(technology_unit_warrior)
  
  human:addTechnology(technology_building_wall)
  
  
  local bool, bad_world, x, y = false, false, -1, -1
  while bool ~= true do
    if bad_world then
      createWorld()
      bad_world = false
    end
    bool, x, y = createStart()
    if (x >= map_view_x) or y >= (map_view_y - 9) then bool = false end
    bad_world = true
  end
  
  selectedX = x
  selectedY = y
  --[[Testing: Start]]--
  local guy = Settler:new()
  guy.race = human
  guy.x = x
  guy.y = y 
  guy:SetImage(image_unit_settler_1)
  
  --[[local home = Settlement:new()
  home:SetImage(image_building_settlement_1)
  home.race = human
  home.x = 6
  home.y = 6]]--
  
  addUnitToMap(guy)
  --addBuildingToMap(home)
  --[[Testing: End]]--
end

function love.draw()
  if gamestate == gamestate_menu then
    bool_start, bool_load, bool_credits, bool_exit = drawMenu()
    if bool_start   == true then 
      gamestate = gamestate_game 
      if bool_playing == false then
        bool_turn_reset = true;
        bool_playing = true;
      end
    end
    if bool_credits == true then drawMenuCredits() end
  elseif gamestate == gamestate_game then
    
    drawWorld(map_view_cornerX, map_view_cornerY, home, guy)
    
    drawUI(uistart, selectedX, selectedY)
    
    UnitAction()
    
    local tile, unit, building = getTileDetails(selectedX, selectedY, map_view_cornerX - 1, map_view_cornerY - 1)
    
    if tile ~= nil then
      if unit ~= nil then
        temp = {}
        temp.tile = tile
        temp.Building = building
        drawUIUnit(unit, temp)
      end
      if building ~= nil then
        drawUIBuilding(building, tile, unit)
      else
        bool_ui_building_settlement = false
      end
    end
   
    if bool_hide_minimap == false then
      scale = 5
      drawMiniMap(windowWidth - map_size_x * scale, windowHeight - map_size_y * scale, scale, map_view_cornerX, map_view_cornerY)
    end
  end
end

function love.update(dt)
  if gamestate == gamestate_menu then
    
  elseif gamestate == gamestate_game then
    if bool_turn_reset then
      newTurn()
      bool_turn_reset = false
    end
    resetViewableFog()
    clearFogAreaUnitsAndBuildings()
    if bool_unit_action_settler_transform then
      transformSettler()
      bool_unit_action_settler_transform = false
    end
    --[[ For testing: To show the map around the selected part of the map ]]--
    --clearFogArea(selectedX + map_view_cornerX - 1, selectedY + map_view_cornerY - 1, 30) 
  end
  if bool_exit == true then
    love.event.quit(0)
  end
end

function love.keypressed(key, isrepeat) --Controls
  if key == "up"  or key == "w" then 
    if selectedY ~= 1 then 
      selectedY = selectedY - 1 
    elseif map_view_cornerY > 0 and map_view_cornerY > 1 then 
        map_view_cornerY = map_view_cornerY - 1 
  end end 
  if key == "down" or key == "s" then
    if selectedY ~= map_view_y + 1 then 
      selectedY = selectedY + 1  
    elseif selectedY ~= map_size_y  and map_view_cornerY ~= map_size_y  - map_view_y then 
      map_view_cornerY = map_view_cornerY + 1
  end end
  if key == "left" or key == "a" then
    if selectedX ~= 1 then 
      selectedX = selectedX - 1 
    elseif map_view_cornerX > 0 and map_view_cornerX > 1 then 
        map_view_cornerX = map_view_cornerX - 1 
  end end
  if key == "right" or key == "d" then
    if selectedX ~= map_view_x + 1 then 
      selectedX = selectedX + 1 
    elseif selectedX ~= map_size_x and map_view_cornerX ~= map_size_x - map_view_x then 
        map_view_cornerX = map_view_cornerX + 1 
  end end
  if key == "h" then
    if bool_window_help == false then bool_window_help = true
    elseif bool_window_help == true then bool_window_help = false end 
  end
  if key == "m" then
    if bool_hide_minimap == false then bool_hide_minimap = true
    elseif bool_hide_minimap == true then bool_hide_minimap = false end
  end
  if key == "escape" then
    gamestate = gamestate_menu
  end
end

function loadImages()
  image_grass_plain = love.graphics.newImage("Texture/grass_plain.png")
  image_forest = love.graphics.newImage("Texture/forest.png")
  image_ocean = love.graphics.newImage("Texture/ocean.png")
  image_mountain = love.graphics.newImage("Texture/mountain.png")
  image_beach = love.graphics.newImage("Texture/beach.png")
  image_fog = love.graphics.newImage("Texture/fog.png")
  
  image_building_settlement_1 = love.graphics.newImage("Texture/Building/Settlement_1.png")
  
  image_unit_settler_1 = love.graphics.newImage("Texture/Units/Settler_1.png")
  image_unit_scout_1 = love.graphics.newImage("Texture/Units/Scout_1.png")  
  image_unit_builder_1 = love.graphics.newImage("Texture/Units/Builder_1.png")  
  image_unit_warrior_1 = love.graphics.newImage("Texture/Units/Warrior_1.png")


  
  image_ui_background = love.graphics.newImage("Texture/UI/background.png")
  image_ui_background_beach = love.graphics.newImage("Texture/UI/background_beach.png")
  image_ui_background_forest = love.graphics.newImage("Texture/UI/background_forest.png")
  image_ui_background_mountain = love.graphics.newImage("Texture/UI/background_mountain.png")
  image_ui_background_ocean = love.graphics.newImage("Texture/UI/background_ocean.png")
  image_ui_background_plains = love.graphics.newImage("Texture/UI/background_plains.png")
  
  image_ui_background_unit_settler = love.graphics.newImage("Texture/UI/background_unit_settler.png")
  image_ui_background_unit_scout = love.graphics.newImage("Texture/UI/background_unit_scout.png")  
  image_ui_background_unit_builder = love.graphics.newImage("Texture/UI/background_unit_builder.png")
  image_ui_background_unit_warrior = love.graphics.newImage("Texture/UI/background_unit_warrior.png")
  
  image_ui_unit_details = love.graphics.newImage("Texture/UI/unit_details.png")
  image_ui_unit_details_sheild = love.graphics.newImage("Texture/UI/unit_details_sheild.png")
  
  image_ui_button_disc = love.graphics.newImage("Texture/UI/option_disc.png")
  image_ui_button_disc_heal = love.graphics.newImage("Texture/UI/option_disc_heal.png")
  image_ui_button_disc_move = love.graphics.newImage("Texture/UI/option_disc_move.png")
  image_ui_button_disc_skip = love.graphics.newImage("Texture/UI/option_disc_skip.png")
  image_ui_button_disc_settle = love.graphics.newImage("Texture/UI/option_disc_settle.png")
  image_ui_button_disc_in = love.graphics.newImage("Texture/UI/option_disc_in.png")
  image_ui_button_disc_out = love.graphics.newImage("Texture/UI/option_disc_out.png")
  
  image_ui_button_arrow_left = love.graphics.newImage("Texture/UI/ui_arrow_left.png")
  image_ui_button_arrow_right = love.graphics.newImage("Texture/UI/ui_arrow_right.png")
  
  image_ui_icon_unit_settler = love.graphics.newImage("Texture/UI/ui_unit_settler.png")
  image_ui_icon_unit_building_walls = love.graphics.newImage("Texture/UI/ui_building_walls.png")
end

function UnitAction()
  --action
  if bool_unit_action_move and unit_action_move ~= nil then
    if moveUnitInput(unit_action_move) then
       bool_unit_action_move = false 
       unit_action_move.bool_option1_active = false
       unit_action_move = nil
    end
  end
  --Creation
  if create_unit_bool and create_unit_type ~= nil then
    create_unit_bool = false
    local unit = nil
    if create_unit_type == technology_unit_settler then
      unit = Settler:new()
      unit:SetImage(image_unit_settler_1)
    end
    if create_unit_type == technology_unit_scout then
      unit = Scout:new()
      unit:SetImage(image_unit_scout_1)
    end
    if create_unit_type == technology_unit_builder then
      unit = Builder:new()
      unit:SetImage(image_unit_builder_1)
    end
    if create_unit_type == technology_unit_warrior then
      unit = Warrior:new()
      unit:SetImage(image_unit_warrior_1)
    end
    if unit ~= nil then
      unit.race = human
      unit.x = create_unit_pos.x
      unit.y = create_unit_pos.y 
      addUnitToMap(unit)
    end
    create_unit_type = nil
  end
end