if castle then
  cs = require("https://raw.githubusercontent.com/castle-games/share.lua/master/cs.lua")
else
  cs = require("sharelua/cs")
end

do -- General init and update

  delay = 0
  my_id = nil
  connected = false
  connecting = false
  
  function init_network()
    if IS_SERVER then
      server_init()
    else
      client_init()
    end
  end
  
  local network_t = 0
  function update_network()
    network_t = network_t - dt()
    if network_t > 0 then
      return
    end
    
    if IS_SERVER then
      server_output()
    else
      client_output()
    end
    
    network_t = 0.05
  end
  
end

do -- start-up stuff

  function start_client()
    client = cs.client
    
    if castle then
      client.useCastleConfig()
    else
      start_client = function()
        client.enabled = true
        client.start('127.0.0.1:22122') -- IP address ('127.0.0.1' is same computer) and port of server
        
        love.update, love.draw = client.update, client.draw
        client.load()
        
        ROLE = client
      end
    end
    
    client.changed = client_input
    client.connect = client_connect
    client.disconnect = client_disconnect
  end
  
  function start_server(max_clients)
    server = cs.server
    server.maxClients = max_clients
    
    if castle then
      server.useCastleConfig()
    else
      start_server = function()
        server.enabled = true
        server.start('22122') -- Port of server
        
        love.update = server.update
        server.load()
        
        ROLE = server
      end
    end
    
    server.changed = server_input
    server.connect = server_new_client
    server.disconnect = server_lost_client
  end

end


do -- client
  _SK = "not found"
  alpha_s = "not found"
  function client_init()
  
  end
  
  function client_input(diff)
    my_id = client.id
    
    if client.share[1] then
      local timestamp = client.share[1][my_id]
      if timestamp then
        delay = (t() - timestamp) / 2
        connected = true
        
        delay = min(delay, 0.5)
      else
        return
      end
    else
      return
    end
    
    if client.share[2] then
      lm.server_count = client.share[2][my_id] or lm.server_count
    end
        
    _SK = client.share[3] or _SK
    _SKs = client.share[4] or _SKs
    alpha_s = client.share[5] or alpha_s
    
  end
  
  function client_output(diff)
  
      client.home[1] = t()
      
      client.home[2] = lm.client_count
      
  end
  
  function client_connect()
    log("Connected to server!")
    -- variable = "Connected to server!"
    my_id = client.id
    
  end
  
  function client_disconnect()
    disconnected = true
    
    log("Disconnected from server!")
    
    
    
  end
  
  
  
end

global_key = "love"

do -- server

  local clicks
  
  function server_init()
    clicks = {}
    server.share[1] = {}
    server.share[2] = {}
    
    server_meter = 0
    global_meter = 0
    server_key = 0
    
    -- network.async(function () castle.storage.setGlobal('server_keys', {}) end)
    
    
  end
  
  function server_input(id, diff)
    local ho = server.homes[id]
    
    for id,ho in pairs(server.homes) do
      if ho[2] and ho[2] > clicks[id] then
        clicks[id] = ho[2]
      end
    end
    
  end
  
  function server_output(id, diff)
    
    for id,ho in pairs(server.homes) do
      server.share[1][id] = ho[1]
      server.share[2][id] = get_all_clicks() - clicks[id]
      server.share[3] = server_key or "no server key"
      server.share[4] = server_keys or {}
      server.share[5] = alpha_server or "no alpha key"
    end
    
  end
  
  function server_new_client(id)
    log("New client: #"..id)
    
    clicks = clicks or {}
    
    clicks[id] = 0
    client_connected = (client_connected or 0) + 1
    
    if client_connected == 1 then 
    
      network.async(function ()
        
        global_meter = castle.storage.getGlobal('global_key') or 0
        castle.storage.setGlobal('global_key', global_meter)
        
        server_keys = castle.storage.getGlobal('server_keys') or {}
        -- server_keys = {}
        
        local found = true
        server_key = tostring(rnd(1000000000)) 
        
        while not found do
          found = false
          if is_in (server_key, server_keys) then 
            found = true 
            server_key = tostring(rnd(1000000000))
          end
        end
        
        add(server_keys, server_key)
        
        castle.storage.setGlobal('server_keys', server_keys)
        castle.storage.setGlobal(server_key, server_meter )    
        server_state = "alphaornot"
      end)
    
    end
    
  end
  
  function server_lost_client(id)
    log("Client #"..id.." disconnected.")
    client_connected = client_connected - 1
    
    if client_connected == 0 then
      
      network.async(function ()
        server_keys = castle.storage.getGlobal('server_keys') or {}
        
        for i, v in pairs(server_keys) do 
          if v == server_key then 
            server_keys[i] = nil
          end
        end
        
        castle.storage.setGlobal('server_keys', server_keys)
        
        alpha_server = castle.storage.getGlobal("alpha")
        
        if alpha_server == server_key then 
          castle.storage.setGlobal("alpha", nil) 
        end
        
        castle.storage.setGlobal(server_key, nil)
        
        server_key = nil
      end)
    end
  end
  
  function get_all_clicks()
    local cl = 0
    for i, c in pairs (clicks) do cl = cl + c end
    return cl + (global_meter or 0)
  end

end

























