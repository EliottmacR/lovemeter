
----------- Heart


function init_heart()

  heart = {}
  
  heart.w = 88
  heart.h = 77
  
  heart.x = GW/2 - heart.w/2
  heart.y = GH/2 - heart.h/2
  
  heart.spr = 0
  
  heart.clr1 = _p_n("hp1")
  heart.clr2 = _p_n("ppink")
  heart.clr3 = _p_n("white")
end

function update_heart()

  heart.hover = m_in_rect(heart.x, heart.y, heart.w, heart.h)
  heart.clicked = btnp("c") and heart.hover 
  
  if heart.clicked then 
    lc.client_count = lc.client_count + 1 
    last_time_clicked = t()
  end
  
  -- add_log("my_count_server_side : " .. (my_count_server_side or "nil") )
end

function draw_heart()

  spritesheet(heartpng)
  spritesheet_grid ( heart.w, heart.h)
 
  local a = 1/40 * cos(t()/6)
  
  local size = 1 * size_mult()
  
  aspr (0, heart.x + heart.w/2 , heart.y + heart.h/2 , a, 1, 1, .5, .5, size, size )
end


function bg_clr()

  if heart.clicked then return "dpurple2"
  else return "dpurple" end

end


last_time_clicked = 0
time_to_resize = .3

function size_mult()  
  if t() - last_time_clicked < time_to_resize then    
    return .85 + .25 * min(1, (t() - last_time_clicked)/time_to_resize)
  else
    return 1
  end  
end







