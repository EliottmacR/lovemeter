require("game/game")  -- where all the fun happens
require("game/palette")
require("game/random_functions")

require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)


zoom = 2
local pi = 3.1415

function love.load()

  
  -- GW = 700 / zoom
  -- GH = GW * 21/16
  -- GH = love.graphics.getWidth()/zoom
  GH = love.graphics.getHeight()/zoom
  -- GH = flr(GH)
  -- GW = love.graphics.getHeight()/zoom
  GW = love.graphics.getWidth()/zoom
  -- GW = flr(GW)

  init_sugar("? Are you the pizza person ?", GW, GH, zoom )

  set_frame_waiting(30)
  
  love.math.setRandomSeed(os.time())
  -- love.mouse.setVisible(true)
  
  init_game()
end

function love.update(dt)
  update_game(dt)
end


function love.draw()
  
  -- love.graphics.push()
  -- love.graphics.translate(GW/2, GH/2)
  -- love.graphics.rotate(-pi/2) 	
  -- love.graphics.translate(-GH/2, -GW/2)
  
  draw_game()
    
  -- love.graphics.pop()
  
end















