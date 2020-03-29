
-- if CASTLE_PREFETCH then
  -- CASTLE_PREFETCH({
    -- "game/nnetwork.lua",
    -- "game/game.lua",
  -- })
-- else
  -- require("game/nnetwork")
-- end

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
  init_sugar("? Are you the pizza person ?", 128, 128, 2 )

  love.math.setRandomSeed(os.time())
  love.mouse.setVisible(true)
  
  init_game()
  initialized = true
  
  loged = 0
  
end

function server.update(dt)
  if not initialized then return end

  if ROLE then server.preupdate(dt) end
  
  if t() > loged * 2 then loged = loged + 1 log("log") end
  
  update_game(dt)
  
  if ROLE then server.postupdate(dt) end
end







