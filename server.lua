
require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)

-- zoom = 2

require("game/nnetwork")
start_server(8)

require("game/game")  -- where all the fun happens
require("game/palette")
require("game/random_functions")

function server.load()
  IS_SERVER = true

  -- GH = love.graphics.getHeight()/zoom
  -- GW = love.graphics.getWidth()/zoom

  init_sugar("? Are you the pizza person ?", 128, 128, 2 )

  -- set_frame_waiting(30)
  
  love.math.setRandomSeed(os.time())
  love.mouse.setVisible(true)
  
  init_game()
  initialized = true
end

function server.update(dt)
  if not initialized then return end

  if ROLE then server.preupdate(dt) end

  update_game(dt)
  
  if ROLE then server.postupdate(dt) end
end







