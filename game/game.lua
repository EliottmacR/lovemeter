
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

end

function update_game()


  
end

function draw_game()
  
  
  -- love.graphics.translate(0.5 * (width - (GW) * zoom),  0.5 * (height - (GH + border/2) * zoom))
  
  love.graphics.translate(0, 0)
  
  
  
  cls(_p_n(background_clr))
  rctf(0, 0, GW, GH + 50, _p_n(background_clr))
  add_log("Android!")
  
  use_font("log")
  print_log()
  
end


function init_controls()

  register_btn("mouse_x", 0, input_id("mouse_position", "x"))
  register_btn("mouse_y", 0, input_id("mouse_position", "y"))
  
end

function init_fonts()
  
  
  load_font("sugarcoat/TeapotPro.ttf", 16, "log", false)
  load_font("sugarcoat/TeapotPro.ttf", 32, "32l", false)
  
end




