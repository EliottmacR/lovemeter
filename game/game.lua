
background_clr = "black"

function init_game()
  
  log_str = {}
  init_network()
  
  if not IS_SERVER then
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
  
  init_lm()
  
end

function update_game()
  if not IS_SERVER then
    update_heart()
    update_c_lm()
  end
  
  update_network()  
  
end

function draw_game()
  
  cls(_p_n(background_clr))
  rctf(0, 0, GW, GH + 50, _p_n(background_clr))
  
  draw_heart()
  draw_lm()
  
  -- if _SK then add_log(_SK) end
  
  if _SKs then 
    for i, s in pairs(_SKs) do
      add_log(s)
    end
  end
  
  -- if alpha_s and alpha_s[1] then add_log("alpha is " .. alpha_s[1]) end
  -- if gc then add_log("gc is " .. gc) end
  -- if sc then add_log("sc is " .. sc) end
  -- if wfc then add_log("wfc is " .. wfc) end
  -- if lud then add_log("lud is " .. lud) end
  
  
  if sst then add_log("Connected!") end
  use_font("log")
  print_log()
  
end


function init_controls()

  register_btn("mouse_x", 0, input_id("mouse_position", "x"))
  register_btn("mouse_y", 0, input_id("mouse_position", "y"))
  
  register_btn("c", 0,  input_id("mouse_button", "lb"))
  
end

function init_fonts()
  
  load_font("sugarcoat/TeapotPro.ttf", 16, "log", false)
  load_font("sugarcoat/TeapotPro.ttf", 32, "32", false)
  
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
  heart.clr3 = _p_n("white")
end

function update_heart()

  heart.hover = m_in_rect(heart.x, heart.y, heart.w, heart.h)
  heart.clicked = btnp("c") and heart.hover 
  
  if heart.clicked then 
    lm.client_count = lm.client_count + 1 
  end
  
  -- add_log("my_count_server_side : " .. (my_count_server_side or "nil") )
end

function draw_heart()
  rctf(heart.x, heart.y, heart.w, heart.h, heart_clr())  
end


function heart_clr()

  if heart.clicked then return heart.clr3
  elseif heart.hover then return heart.clr2
  else return heart.clr1 end

end



---------- Love Meter

function init_lm()
  
  lm = {}
  lm.length = 6
  lm.count = 0
  
  lm.client_count = 0
  lm.server_count = 0

end

function update_c_lm()
  
  lm.count = lm.client_count + lm.server_count
  -- add_log(server_id or "no server id received")
  
end

function draw_lm()

  use_font("32")
  
  local str = count_to_str(lm.count)  
  local sw = str_width(str)
  local sh = str_height(str)  
  local sx = GW/2
  local sy = GH/7
  
  print(str, sx - sw/2, sy - sh/2, _p_n("pink"))

end

function count_to_str(count)
  if count > 999999 then return count
  else
    local x = 10
    local n_o_z = lm.length - 1
    while count > x - 1 do    
      x = x * 10
      n_o_z = n_o_z - 1
    end
    return noz(n_o_z) .. count
  end
end

function noz(number)
  str = ""
  for i = 1, number do str = str .. "0" end 
  return str
end










