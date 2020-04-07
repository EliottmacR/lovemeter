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

WAIT_TIME_SETCOUNT = 5
wait_time = 0
doingalphaornot = false

function server.update()
  if not initialized then return end

  if ROLE then server.preupdate(dt()) end
  
  update_network()
  
  update_data_timer = update_data_timer - dt()
  
  if update_data_timer < 0 and not refreshing_data then
    update_data_timer = 3
    
    network.async(function()
      refreshing_data = true
      server_keys = castle.storage.getGlobal('server_keys') or {}
      global_meter = castle.storage.getGlobal('global_key') or 0
      refreshing_data = false
    end)
    
    
  end
  
  if server_key then
    if server_state == "alphaornot" then
    
      if not doingalphaornot then
        network.async(function()
          doingalphaornot = true
          server_keys = castle.storage.getGlobal('server_keys') or {}
          alpha_server = castle.storage.getGlobal("alpha")
          
          if not alpha_server or not is_in(alpha_server, server_keys) then          
            castle.storage.setGlobal("alpha", server_key)
          end
          
          server_state = "setcount"
          wait_time = WAIT_TIME_SETCOUNT
          doingalphaornot = false
        end)
      end
      
    elseif server_state == "setcount" then
      wait_time = wait_time - dt()

      if wait_time < 0 then
          server_state = "alphaornot"
      
        -- if not doingsetcount then
          -- network.async(function ()
            -- doingsetcount = true
            -- local old count = castle.storage.getGlobal(server_key)
            -- if old_count == 0 then        
              -- castle.storage.setGlobal(server_key, server_count)  
              -- old_server_count = server_count
              -- server_count = 0
            -- end
            
            -- global_count = castle.storage.getGlobal(global_key)
            
            -- alpha_server = castle.storage.getGlobal("alpha")
            
            -- if server_key == alpha_server then
              -- server_state = "iamthealpha"
              -- wait_time = 0
            -- else
              -- server_state = "alphaornot"
              -- wait_time = WAIT_TIME_ALPHAORNOT
            -- end
            
            -- doingsetcount = false
          -- end
        -- end
      
      end
      
    elseif server_state == "iamthealpha" then
      
        -- if not doingiamthealpha then
        -- network.async(function
          -- doingiamthealpha = true
          
          -- server_keys = castle.storage.getGlobal('server_keys')
          
          -- for i, v in pairs(server_keys) do
          
            -- local count = castle.storage.getGlobal(v)          
            -- if count then
              -- global_count = global_count + count
              -- castle.storage.setGlobal(v, 0)
            -- end
            
          -- end
          
          -- castle.storage.setGlobal(last_updated_time, 0)
          
          -- server_state = "alphaornot"
          -- doingiamthealpha = false
        -- end)
        
    end  
  end  
    
  if ROLE then server.postupdate(dt()) end
end







