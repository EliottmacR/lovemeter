
----------- Heart


function init_heart()

  heart = {}
  
  heart.w = 88
  heart.h = 77
  
  heart.x = GW/2 - heart.w/2
  heart.y = GH/5*2.2 - heart.h/2
  
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
  end
  
  -- add_log("my_count_server_side : " .. (my_count_server_side or "nil") )
end

function draw_heart()
  rctf(heart.x, heart.y, heart.w, heart.h, heart_clr())  
  
  spr_sheet (heartpng, heart.x, heart.y)
  
end


function heart_clr()

  if heart.clicked then return heart.clr3
  elseif heart.hover then return heart.clr2
  else return heart.clr1 end

end