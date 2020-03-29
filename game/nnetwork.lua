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
    
    -- add_log(client.share[2] or "no client share 2")
    -- add_log(lm.server_count or "no client share 2")
    
    -- clicks = client.share[3]
    -- server_id = client.share[4]
    
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

do -- server

  local clicks
  
  function server_init()
    clicks = {}
    server.share[1] = {}
    server.share[2] = {}
    
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
    end
    
    
    
    
  end
  
  function server_new_client(id)
    log("New client: #"..id)
    
    clicks = clicks or {}
    
    clicks[id] = 0
    
  end
  
  function server_lost_client(id)
    log("Client #"..id.." disconnected.")
    -- clicks[id] = nil
  end
  
  function get_all_clicks()
    local cl = 0
    for i, c in pairs (clicks) do cl = cl + c end
    return cl
  end

end
























