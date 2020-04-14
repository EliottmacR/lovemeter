
---------- Love Counter

function init_love_counter()
  
  lc = {}
  lc.length = 6
  lc.count = 0
  
  lc.client_count = 0
  lc.server_count = 0
  
  if not IS_SERVER then
    numpng = load_png("numbers", "game/assets/numbers.png")
  end
end

function update_love_counter()  
  lc.count = lc.client_count + lc.server_count  
end

SMULT = 2

NUMW = 10
NUMH = 16

function draw_love_counter()

  use_font("32")
  
  local str = count_to_str(lc.count)  
  local sw = NUMW * 6 * SMULT
  local sh = str_height(str)  
  local sx = GW/2 - 30 * SMULT
  local sy = GH/7
 
  spritesheet(numpng)
  
  draw_background_counter(sx, sy, #str)  
  draw_numbers(str, sx, sy)
  
end

function draw_numbers(str, x, y)
  for i = 1, #str do
    sspr (tonumber(str:sub(i,i)) * NUMW, 0, NUMW, NUMH, x + NUMW * (i-1) * SMULT, y, NUMW * SMULT, NUMH * SMULT)    
  end  
end

HEADERW = 13
HEADERH = 22

function draw_background_counter(sx, sy, strn) 
  local sw, sh = HEADERW * SMULT, HEADERH * SMULT
  local sx = sx - 3 * SMULT
  local sy = sy - 3 * SMULT
  
  sspr(0, NUMH, HEADERW, HEADERH, sx, sy, sw, sh)  
  for i = 1, strn - 2 do
    sspr(15, NUMH, NUMW, HEADERH, sx + (HEADERW + (i-1) * NUMW) * SMULT, sy, NUMW * SMULT, sh)  
  end  
  sspr(27, NUMH, HEADERW, HEADERH, sx + (HEADERW + (strn-2) * NUMW) * SMULT, sy, sw, sh)
end

function count_to_str(count)
  if count > 999999 then return tostring(count)
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



