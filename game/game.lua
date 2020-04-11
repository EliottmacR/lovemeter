
require("game/heart")  -- where all the fun happens
require("game/love_counter")  -- where all the fun happens
background_clr = "black"

function init_game()
  
  log_str = {}
  init_network()
  
  if not IS_SERVER then
    init_controls()
    init_fonts()
    init_palette()
    
    load_png("spr_sheet", "game/assets/spr_sheet.png", nil, true) 
    -- click_s1 = load_sfx("game/assets/pizza.mp3", nil, 1)
    
    -- bdc = load_music ("game/assets/big_d_ck.mp3", nil, .1)
    -- music (bdc, true)
    
    spritesheet_grid (16, 16)
    state = "title"
    init_heart()
  end
  
  init_love_counter()
  log_enabled = false
end

function update_game()
  if not IS_SERVER then
    update_heart()
    update_love_counter()
  end
  
  if btnp("enable_logs") then log_enabled = not log_enabled end
  
  update_network()  
  
end

function draw_game()
  
  cls(_p_n(background_clr))
  
  draw_heart()
  draw_love_counter()
  
  if log_enabled then
    log_server_variables()
  end
  
  use_font("log")
  print_log()
  
end


function init_controls()

  register_btn("mouse_x", 0, input_id("mouse_position", "x"))
  register_btn("mouse_y", 0, input_id("mouse_position", "y"))
  
  register_btn("c", 0,  input_id("mouse_button", "lb"))
  register_btn("enable_logs", 0,  input_id("keyboard", "l"))
  
end

function init_fonts()
  
  load_font("sugarcoat/TeapotPro.ttf", 16, "log", false)
  load_font("sugarcoat/TeapotPro.ttf", 32, "32", false)
  
end

function log_server_variables()
 
  if sst then add_log("Connected!") end
  if alpha_s and alpha_s[1] then add_log("alpha is " .. alpha_s[1]) end
  if gc then add_log("gc is " .. gc) end
  if sc then add_log("sc is " .. sc) end
  if wfc then add_log("wfc is " .. wfc) end
  if lud then add_log("lud is " .. lud) end  
  if sst then add_log("sst is " .. sst) end
  if delta then add_log("delta is " .. delta) end
  if delta2 then add_log("delta2 is " .. delta2) end
  if delta3 then add_log("delta3 is " .. delta3) end
  if nsk then add_log("nsk is " .. nsk) end
end








