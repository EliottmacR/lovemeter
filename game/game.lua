
background_clr = "black"

function init_game()
  
  log_str = {}

  init_controls()
  init_fonts()
  init_palette()
  
  -- load_png("spr_sheet", "game/assets/spr_sheet.png", nil, true) 
  -- click_s1 = load_sfx("game/assets/pizza.mp3", nil, 1)
  
  -- bdc = load_music ("game/assets/big_d_ck.mp3", nil, .1)
  -- music (bdc, true)
  
  spritesheet_grid (16, 16)
  state = "title"

  init_heart()


end

function update_game()
  update_touches()
  update_heart()
  
end

function draw_game()
  
  cls(_p_n(background_clr))
  rctf(0, 0, GW, GH + 50, _p_n(background_clr))
  
  
  draw_heart()
  
  -- for i, t in pairs(touches) do
    -- add_log(i .. " : " .. t.x .. ", " .. t.y)
  -- end
  
  local cl = click()
  
  if cl then add_log(count(touches) .. " : " .. cl.x .. ", " .. cl.y) end
  
  use_font("log")
  print_log()
  
end


function init_controls()

  register_btn("mouse_x", 0, input_id("mouse_position", "x"))
  register_btn("mouse_y", 0, input_id("mouse_position", "y"))
  
  register_btn("select", 0,  input_id("mouse_button", "lb"))
  
end

function init_fonts()
  
  
  load_font("sugarcoat/TeapotPro.ttf", 16, "log", false)
  load_font("sugarcoat/TeapotPro.ttf", 32, "32l", false)
  
end



----------- Heart


function init_heart()

  heart = {}
  
  heart.w = 32
  heart.h = 32
  
  heart.x = GW/2 - heart.w/2
  heart.y = GH/5*2.2 - heart.h/2
  
  heart.clr1 = _p_n("pink")
  heart.clr2 = _p_n("ppink")
end

function update_heart()

  
  
end

function draw_heart()

  rctf(heart.x, heart.y, heart.w, heart.h, heart.clr1)
  
end


---------- Touches

function update_touches()


  tch = love.touch.getTouches( )
  
  touches = {}
  
  for i = 1, count(tch) do
    xs, ys = love.touch.getPosition( tch[i] )
    touches[i] = {x = xs, y = ys }
  end
  
  if btn("select") then touches[1] = {x = btnv("mouse_x"), y = btnv("mouse_y") } end
  
end

function click()


  return btn("select") and {x = btnv("mouse_x"), y = btnv("mouse_y") } or
        (count(touches) == 1 and touches[1] or nil)

end




