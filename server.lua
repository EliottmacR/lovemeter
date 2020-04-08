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

WAIT_TIME_SETCOUNT = 2
wait_time = 0
doingalphaornot = false
doingsetcount = false
doingiamthealpha = false
refreshing_data = false

waiting_for_conf = 0
not_send = 0
send_clicks = 0

function server.update()
  if not initialized then return end

  if ROLE then server.preupdate(dt()) end
  
  update_network()
  
  update_data_timer = update_data_timer - dt()
  
  if server_key then
  
    -- if update_data_timer < 0 and not refreshing_data then
      -- update_data_timer = 3
      
      -- network.async(function()
        -- refreshing_data = true
        -- server_keys = castle.storage.getGlobal('server_keys') or {}
        -- global_count = castle.storage.getGlobal('global_key') or 0
        -- my_meter = castle.storage.getGlobal(server_key) or 0
        
        
        -- if my_meter == 0 then
          -- send_clicks = send_clicks + waiting_for_conf
          -- waiting_for_conf = 0
        -- end
        
        
        -- refreshing_data = false
      -- end)
      
      
    -- end
  
    if server_state == "alphaornot" then
    
      if not doingalphaornot then
        network.async(function()
          doingalphaornot = true
          server_keys = castle.storage.getGlobal('server_keys') or {}
          alpha_server = castle.storage.getGlobal("alpha")
          
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
            local old_count = castle.storage.getGlobal(server_key)
            global_count = castle.storage.getGlobal('global_key') or 0
            
            if old_count == 0 then     
              send_clicks = send_clicks + waiting_for_conf
              waiting_for_conf = get_all_clicks() - send_clicks
              
              castle.storage.setGlobal(server_key, waiting_for_conf)
            end
            
            alpha_server = castle.storage.getGlobal("alpha")
            
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
            doingiamthealpha = true
              
            global_count = castle.storage.getGlobal('global_key') or 0
            
            server_keys = castle.storage.getGlobal('server_keys')
            
            for i, v in pairs(server_keys) do
              if v then
                local count = castle.storage.getGlobal(tostring(v)) or 0          
                if count then
                  global_count = global_count + count
                  if v == server_key then
                    send_clicks = send_clicks + waiting_for_conf
                    waiting_for_conf = 0
                  end
                  castle.storage.setGlobal(tostring(v), 0)
                end
              end
              
            end
            
            castle.storage.setGlobal('global_key', global_count)
            
            castle.storage.setGlobal("alpha", {server_key, get_time()})
            
            server_state = "alphaornot"
            doingiamthealpha = false
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

