
if CASTLE_PREFETCH then
  CASTLE_PREFETCH({
    "game/nnetwork.lua",
  })
else
  require("game/nnetwork")
end

require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)

zoom = 2


start_client(8)

require("game/game")  -- where all the fun happens
require("game/palette")
require("game/random_functions")

function client.load()

  GH = love.graphics.getHeight()/zoom
  GW = love.graphics.getWidth()/zoom

  init_sugar("? Are you the pizza person ?", GW, GH, zoom )

  set_frame_waiting(30)
  
  love.math.setRandomSeed(os.time())
  love.mouse.setVisible(true)
  
  init_game()
  initialized = true
end

function client.update(dt)
  if not initialized then return end
  
  if ROLE then client.preupdate(dt) end
  
  update_game(dt)
  
  -- if variable then 
    -- for i, v in pairs(variables) do 
      -- variable
    -- end
    -- add_log(variable) 
  -- end 
  
  if clicks then 
    for i, c in pairs(clicks) do
      add_log(i .. " : " .. c)
    end
  end
  
  if server_id then
    add_log("server_id : " .. server_id)
  end
  
  if ROLE then client.postupdate(dt) end
  
end


function client.draw()
  if not initialized then return end
  draw_game()
end









