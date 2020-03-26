require("game/game")  -- where all the fun happens
require("game/palette")
require("game/random_functions")

require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)


zoom = 2

function love.load()

  GH = love.graphics.getHeight()/zoom
  GW = love.graphics.getWidth()/zoom

  init_sugar("? Are you the pizza person ?", GW, GH, zoom )

  set_frame_waiting(30)
  
  love.math.setRandomSeed(os.time())
  love.mouse.setVisible(true)
  
  init_game()
end

function love.update(dt)
  update_game(dt)
end


function love.draw()
  draw_game()
end















