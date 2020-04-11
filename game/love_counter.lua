
---------- Love Counter

function init_love_counter()
  
  lc = {}
  lc.length = 6
  lc.count = 0
  
  lc.client_count = 0
  lc.server_count = 0

end

function update_love_counter()  
  lc.count = lc.client_count + lc.server_count  
end

function draw_love_counter()

  use_font("32")
  
  local str = count_to_str(lc.count)  
  local sw = str_width(str)
  local sh = str_height(str)  
  local sx = GW/2
  local sy = GH/7
  
  print(str, sx - sw/2, sy - sh/2, _p_n("hp1"))

end

function count_to_str(count)
  if count > 999999 then return count
  else
    local x = 10
    local n_o_z = lc.length - 1
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



