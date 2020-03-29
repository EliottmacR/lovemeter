-- require("game/game")  -- where all the fun happens
-- require("game/palette")
-- require("game/random_functions")

-- require("sugarcoat/sugarcoat")
-- sugar.utility.using_package(sugar.S, true)


-- zoom = 2

-- function love.load()

  -- GH = love.graphics.getHeight()/zoom
  -- GW = love.graphics.getWidth()/zoom

  -- init_sugar("? Are you the pizza person ?", GW, GH, zoom )

  -- set_frame_waiting(30)
  
  -- love.math.setRandomSeed(os.time())
  -- love.mouse.setVisible(true)
  
  -- init_game()
-- end

-- function love.update(dt)
  -- update_game(dt)
-- end


-- function love.draw()
  -- draw_game()
-- end















-- `main.lua` is only to test with Love2D.
-- The Castle entry points are `client.lua` and `server.lua`.

--require("sugarcoat/sugarcoat")
--sugar.utility.using_package(sugar.S, true)


-- LOAD_MAP_FROM_PNG = true



local castle_log = {}
local function get_logs(str)
  add(castle_log, str)
end

function love.load(args)
  if args[1] == "server" then
    love.event.push("keyreleased", '1')
  elseif args[1] == "client" then
    love.event.push("keyreleased", '2')
  
  end
  
  log("here")
  
end

function love.draw()
  if ROLE then
    love.graphics.clear()
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Running server.", 32, 16)
    
    
    local y = 40
    local n = #castle_log
    while n > 0 do
      love.graphics.print(castle_log[n], 48, y)
      
      n = n-1
      y = y+24
    end
    
    --love.graphics.present()
  else
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Press 1 to launch local server.", 32, 32)
    love.graphics.print("Press 2 to launch local client.", 32, 64)
  end
end

function love.keyreleased(key)
  if key == '1' then
    local oldraw = love.draw

    love.keyreleased = nil
    
    if network then
      network.async(function()
        require("server")
      end)
    else
      require("server")
    end
    start_server()
    
    catch_logs(get_logs)
    love.draw = oldraw
    
    love.graphics.setFont(love.graphics.newFont("sugarcoat/TeapotPro.ttf", 32))
  elseif key == '2' then
    love.keyreleased = nil
    
    if network then
      network.async(function()
        require("client")
      end)
    else
      require("client")
    end
    start_client()
  end
end














