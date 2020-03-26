
function count(tab)
  if not tab then return 0 end
  local nb = 0
  for i, j in pairs(tab) do nb = nb + 1 end
  return nb  
end

function m_in_rect(x, y, w, h, mx, my)
  if not x or not y or not w or not h then return end
  
  local mx = mx or btnv("mouse_x")
  local my = my or btnv("mouse_y")
  return mx > x and mx < x + w and my > y and my < y + h
end

function chance(x) -- x gotta be between between 1 and 100 (both in)
  if x > 100 or x < 0 then return end
  return (rnd(100) <= x)
end

function point_in_rect(px, py, x, y, w, h)
  return px > x and px < x + w and py > y and py < y + h 
end

function pick_distinct( amount, from )
  if not from or not amount or from == {} then return {} end
  
  to_return = {}  
  for i = 1, amount do
    local choosen = pick(from)    
    while check_in(choosen, to_return) do 
      choosen = pick(from)
    end
    add(to_return, choosen)    
  end
  
  return to_return
end

function is_in(value, tab)
  for index, val in pairs(tab) do
    if val == value then return true end
  end
  return false
end

function sign(x) return x >=0 and 1 or -1 end

function rct(x, y, w, h, col)
  return rect(x, y, x + w, y + h, col)
end
function rctf(x, y, w, h, col)
  return rectfill(x, y, x + w, y + h, col)
end



function copy(obj)
  if type(obj) ~= 'table' then return obj end
  local res = {}
  for k, v in pairs(obj) do res[copy(k)] = copy(v) end
  return res
end


function add_log(str)
  log_str[#log_str + 1] = str
end

function print_log(x, y)
  color(_p_n("white"))
  local l = ""
  for i = 1, #log_str do
    print(l .. log_str[i], x or 0 , y or 0)
    l = l .. "\n"
    log_str[i] = nil
  end
end

function wave_print(str, x, y, inner_col, outer_col, margin)

  local w = str_width(str) * 1.2 
  local x = x - w/2
  local margin = margin or 5
  for i = 1, #str do
    local c = str:sub(i,i)
    outlined_print(c, 
          x + w *(i-1)/#str + margin,
          y                 + sin(i / #str - t() / 2) * 5 + margin , 
          _p_n("black"),
          _p_n("black"))
          
    outlined_print(c, 
          x + w *(i-1)/#str,
          y                 + sin(i / #str - t() / 2) * 5 , 
          inner_col,
          outer_col or _p_n("black"))
  end

end

function outlined_print(str, x, y, inner_col, outer_col)
  if not str then return end
  
  local x = x or 0
  local y = y or 0
  
  local w = str_width(str)
  local h = str_height(str)
  
  local x = x - w/2
  local y = y - h/2
  
  local inner_col = inner_col or 1
  local outer_col = outer_col or 5
  local margin = 1
  color(outer_col)
  
  print(str, x-margin, y-margin)
  print(str, x-margin, y)
  print(str, x-margin, y+margin)
  
  print(str, x+margin, y-margin)
  print(str, x+margin, y)
  print(str, x+margin, y+margin)
  
  print(str, x, y-margin)
  print(str, x, y+margin)
  
  color(inner_col)
  print(str, x, y)

end

function str_width(str)
  str = str or ""
  return love.graphics.getFont():getWidth(str)
end
function str_height(str)
  str = str or ""
  return love.graphics.getFont():getHeight(str)
end

function outlined(sp, x, y, w, h, fx, flash)
  if not sp or not x or not y then return end
  
  local w = w or 1
  local h = h or 1
  
  all_colors_to(flash or _p_n("black"))
  spr(sp, x - 1, y - 1, w, h, fx) 
  spr(sp, x - 1, y,     w, h, fx) 
  spr(sp, x - 1, y + 1, w, h, fx) 
  
  spr(sp, x,     y - 1, w, h, fx) 
  spr(sp, x,     y + 1, w, h, fx) 
  
  spr(sp, x + 1, y - 1, w, h, fx) 
  spr(sp, x + 1, y,     w, h, fx) 
  spr(sp, x + 1, y + 1, w, h, fx) 
  
  
  all_colors_to(flash)
  spr(sp, x, y, w, h, fx) 
  if flash then all_colors_to() end
  
end

function a_outlined(sp, x, y, a, w, h, anchor_x, anchor_y, outline_color, from_to, scale_x, scale_y)
  if not sp or not x or not y then return end
  
  all_colors_to(outline_color or _p_n("black"))
  
  local margin = 1
  a = a or 1
  w = w or 1
  h = h or 1
  
  aspr(sp, x - margin, y - margin, a, w, h, anchor_x, anchor_y, scale_x, scale_y) 
  aspr(sp, x - margin, y,          a, w, h, anchor_x, anchor_y, scale_x, scale_y)    
  aspr(sp, x - margin, y + margin, a, w, h, anchor_x, anchor_y, scale_x, scale_y) 
  
  aspr(sp, x,          y - margin, a, w, h, anchor_x, anchor_y, scale_x, scale_y) 
  aspr(sp, x,          y + margin, a, w, h, anchor_x, anchor_y, scale_x, scale_y) 
  
  aspr(sp, x + margin, y - margin, a, w, h, anchor_x, anchor_y, scale_x, scale_y) 
  aspr(sp, x + margin, y,          a, w, h, anchor_x, anchor_y, scale_x, scale_y) 
  aspr(sp, x + margin, y + margin, a, w, h, anchor_x, anchor_y, scale_x, scale_y) 
  
  all_colors_to()
  
  for i, swap in pairs(from_to or {}) do
    pal (swap[1],swap[2])
  end
  
  aspr(sp, x, y , a, w, h, anchor_x, anchor_y) 
  pal()
  
end


  
function get_ordered_tab(mode, tab, key)
  local copy_t = copy_table(tab)
  local sorted_list = {}
  if not mode or mode == "descending" then
    while count(copy_t) > 0 do
      local mx, i = get_max(copy_t, key)
      sorted_list[#sorted_list + 1] = tab[i]
      copy_t[i] = nil
    end  
  -- elseif mode == "ascending" then
  end
  
  return sorted_list
end

function get_max(tab, key)
  if tab == {} or not key then return end
  local mx
  local index
  for i, l in pairs(tab) do
    mx = mx or l[key]    
    index = index or i   
    if l[key] then 
      if l[key] > mx then 
        mx = l[key] 
        index = i 
      end    
    end    
  end
  return mx, index
end









