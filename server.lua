SUGAR_SERVER_MODE = true

require("sugarcoat/sugarcoat")
sugar.utility.using_package(sugar.S, true)

require("game/nnetwork")
start_server(8)

require("game/game")  -- where all the fun happens
require("game/palette")
require("game/random_functions")

function server.load()
  IS_SERVER = true
  init_sugar("? Are you the pizza person ?", 128, 128, 2 )

  love.math.setRandomSeed(os.time())
  love.mouse.setVisible(true)
  
  init_game()
  initialized = true
  
  loged = 0
  update_data_timer = 0
  
  
end

WAIT_TIME_SETCOUNT = 0
wait_time = 0
doingalphaornot = false
doingsetcount = false
doingiamthealpha = false
refreshing_data = false

waiting_for_conf = 0
not_send = 0
send_clicks = 0

clear_sks = true

function server.update()
  if not initialized then return end

  if ROLE then server.preupdate(dt()) end
  
  update_network()
  
  update_data_timer = update_data_timer - dt()
  
  if server_key then
    
    if server_state == "alphaornot" then
    
      if not doingalphaornot then
        network.async(function()
          doingalphaornot = true
          server_keys = get_server_keys() or {}
          
          -- num_server_keys = count(server_keys)
          alpha_server = get_alpha_server()
          
          if not alpha_server or
             not alpha_server[1] or 
             not alpha_server[2] or 
             too_old(alpha_server[2]) or 
             not is_in(alpha_server[1], server_keys)
          then 
            castle.storage.setGlobal("alpha", {server_key, get_time()})
          end
          
          server_state = "setcount"
          wait_time = WAIT_TIME_SETCOUNT
          doingalphaornot = false
        end)
      end
      
    elseif server_state == "setcount" then
      wait_time = wait_time - dt()

      if wait_time < 0 then
      
        if not doingsetcount then
          network.async(function ()
            doingsetcount = true
            local old_count = get_server_keys()
            global_count = castle.storage.getGlobal('global_key') or 0
            
            if old_count == 0 then     
              send_clicks = send_clicks + waiting_for_conf
              waiting_for_conf = get_all_clicks() - send_clicks
              
              castle.storage.setGlobal(server_key, waiting_for_conf)
            end
            
            alpha_server = get_alpha_server()
            
            if server_key == alpha_server[1] then
              server_state = "iamthealpha"
              wait_time = 0
            else
              server_state = "alphaornot"
              wait_time = WAIT_TIME_ALPHAORNOT
            end
            
            doingsetcount = false
          end)
        end
      
      end
      
    elseif server_state == "iamthealpha" then
      
        if not doingiamthealpha then
          network.async(function ()
            time_after_iamthealpha = nil
            t1 = nil
            t2 = nil
            time_before_iamthealpha = get_time()
            doingiamthealpha = true
              
            global_count = castle.storage.getGlobal('global_key') or 0            
            server_keys = get_server_keys()
            
            t1 = get_time()
            
            for i, v in pairs(server_keys) do
              if v then
                if not clear then
                  local count = castle.storage.getGlobal(tostring(v))          
                  if count then
                    global_count = global_count + count
                    if v == server_key then
                      send_clicks = send_clicks + waiting_for_conf
                      waiting_for_conf = 0
                    end
                    castle.storage.setGlobal(tostring(v), 0)
                  end
                else
                  server_keys[i] = nil
                  castle.storage.setGlobal(tostring(v), nil)
                end
              end
            end
            
            t2 = get_time()
            
            castle.storage.setGlobal('global_key', global_count)
            
            castle.storage.setGlobal("alpha", {server_key, get_time()})
            
            server_state = "alphaornot"
            doingiamthealpha = false
            time_after_iamthealpha = get_time()
          end)
        
      end  
    end  
  end  
    
  if ROLE then server.postupdate(dt()) end
end

function too_old(time_stamp)
  return (get_time() - time_stamp) > 20
  -- return false
end

function get_time()
  return os.time(os.date('!*t'))
end
          

-- last_time_got_as = 0
function get_alpha_server()
  -- if get_time() - last_time_got_as > 4 then
    -- _ALPHA = castle.storage.getGlobal("alpha")
    -- last_time_got_as = get_time()
  -- end
  -- return _ALPHA 
  return castle.storage.getGlobal("alpha")
end

last_time_got_sk = 0
function get_server_keys()
  if get_time() - last_time_got_sk > 4 then
    _SERVER_K = castle.storage.getGlobal("server_keys")
    last_time_got_sk = get_time()
  end
  return _SERVER_K
end





