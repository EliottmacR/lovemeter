require("game/diff1")
require("game/diff2")
require("game/diff3")
require("game/diff4")

right = "green"
wrong = "red"
shouldhave = "yellow"
waiting_col = "blue"

function init_pp()
  state = "game"
  
  w_tb = GW
  h_tb = GH/10
  
  w_pa = GW
  h_pa = GH * 9/10
  
  timer_bar = new_surface (w_tb, h_tb + 1)
  play_area = new_surface (w_pa, h_pa)
  
  timer_duration = 1
  timer = 1
  
  diff = 1
  hp = 3
  -- hp = 1
  
  _BEGAN_PHASE = false
  
  wait_timer_bar = 1
  wait_timer = 0
  wait_before_next = .5
  wave_number = 0
  
  words = {}
  
  col_UP = false
  UP = false
  LEFT = false
  col_LEFT = false  
  DOWN = false
  col_DOWN = false  
  RIGHT = false
  col_RIGHT = false
  
  init_points()
  score = 0
  
end

function update_pp()
  update_timer_bar()
  update_play_area()
end

function draw_pp()
  cls(_p_n(background_clr))
  draw_timer_bar()
  draw_play_area()
end

function update_timer_bar()

  wait_timer_bar = wait_timer_bar - dt()
  
  if wait_timer_bar < 0 then
    
    if not _BEGAN_PHASE then
      begin_phase()
    end
    
    wait_timer = wait_timer - dt()
    if wait_timer < 0 then 
      timer = timer - dt()
      
      if timer < -.2 - dt() then
        wait_before_next = (wait_before_next or .5) - dt()
        if wait_before_next >= .4 and not done then 
          done = true
          if diff == 1 then wait_before_next_d1() 
          elseif diff == 2 then wait_before_next_d2() 
          elseif diff == 3 then wait_before_next_d3()  
          elseif diff == 4 then wait_before_next_d4() end 
        end
        
        if wait_before_next < 0 then begin_phase() done = false end
      else

        -- Game on
        
        if btnp("up")     then UP = true end
        if btnp("left")   then LEFT = true end
        if btnp("down")   then DOWN = true end
        if btnp("right")  then RIGHT = true end
      
      end 
    end 
  end 
  
end



function draw_timer_bar()
  target(timer_bar)
    cls(_p_n("black"))
    if timer_duration ~= 0 and timer / timer_duration > 0 then
      rctf(0, 0, w_tb * timer / timer_duration, h_tb, _p_n("red"))
    end
    
    for i = 0, 2 do 
      local spr = 2 + (i < (hp) and 0 or 8*2)
      a_outlined(spr, w_tb/4 - 60 + 17 + 2 + i * 40 , 16 + 2, .04 * cos(t()/2 + i * .1), 2, 2)
    end
    
    use_font("log")
    outlined_print("Score : " .. score, w_tb*3/4, 18)
    
  target()
  
  spr_sheet(timer_bar, 0, -1)
end

function update_play_area()

end

function draw_play_area()
  target(play_area)
    cls(_p_n("black"))
    
    rctf(0, 0, w_pa, h_pa, _p_n("champi2"))
    use_font("log")
    if     diff == 1 then draw_play_area_d1() print_wave_number(h_pa*2/3)
    elseif diff == 2 then draw_play_area_d2() print_wave_number(h_pa/2)
    elseif diff == 3 then draw_play_area_d3() print_wave_number(h_pa/2)
    elseif diff == 4 then draw_play_area_d4() 
    end
  target()
  
  spr_sheet(play_area, 0, h_tb)
end

function print_wave_number(y)
  if wave_number ~= 0 then
    local str = (wave_number <= 5 and "plays left before difficulty up : " or "" ) .. 4 - (wave_number - 1)%5
    outlined_print(str, w_pa/2, y, _p_n("champi1"))
  else
    outlined_print("plays left before difficulty up : ", w_pa/2, y, _p_n("champi1"))
  end
end

function begin_phase()
  if hp < 1 then end_game() return end

  _BEGAN_PHASE = true  
  words = {}
  wave_number = wave_number + 1

  if wave_number > 5 then diff = 2 end   
  if wave_number > 10 then diff = 3 end   
  if wave_number > 15 then diff = 4 end  
  
  for i = 1, 4 do 
    words[i] = ( rnd(100) < 50 and (rnd(1) < .5 and "P" or "p").."izza" or pick(word_list))
  end
  
  for i = 1, 4 do 
    offset[i] = {x = rnd(16), y = rnd(16)}
  end
  
  wait_before_next = .5 
  if diff == 4 then
    x = (wave_number > 18 and (1/(wave_number-18)) or 0)
    timer = .9 + .4 * x
  else
    timer = 1
  end
  
  timer_duration = timer
  
  UP = false
  col_UP = false
  
  LEFT = false
  col_LEFT = false
  
  DOWN = false
  col_DOWN = false
  
  RIGHT = false
  col_RIGHT = false
end

loged_score = nil

function end_game()

  if not _asked then
    update_score()
    _asked = true
  end
  
  if not refreshing then
    state = "retry"
    timer_end = 2
    
    if score > old_highscore then
      -- highscore = max(score, highscore)
      state = "new_highscore"
    end
    _asked = false
  end
  
  
  
end
----------------------------------------

word_list = {
"Zapi","piza","Pizzza","pizzza","Rizza","qizza","pizze","pyzza","Ryzza","Pipa","Pippa","factories",
"Rippa","Brocoli","Hey","Ghost","data","universe","claim","castle","town","and","pain","tofu","canapé",
"beuh","tortilla","calzone","goddot","architect","cat","bus","nintendo","tentendo","pocket","animals",
"cities","triangles","dance","party","nail","glitter","skyfall","folder","age","diamonds","forest"}







