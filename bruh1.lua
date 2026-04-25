-- [[ SMART SERVER HOPPER ]] --
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- CONFIGURATION
local MIN_PLAYERS = 10 -- Hop if there are fewer than 5 people
local PLACE_ID = game.PlaceId

local function hop()
    print("🏃 Server has too few players. Finding a new one...")
    
    -- Get a list of public servers from the Roblox API
    local url = "https://games.roblox.com/v1/games/" .. PLACE_ID .. "/servers/Public?sortOrder=Desc&limit=100"
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)

    if success and result and result.data then
        for _, server in pairs(result.data) do
            -- Find a server that is NOT our current one and has space
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                if server.playing >= MIN_PLAYERS then
                    print("🚀 Teleporting to server with " .. server.playing .. " players!")
                    TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, Players.LocalPlayer)
                    return
                end
            end
        end
    end
    warn("❌ Couldn't find a better server right now. Retrying in 10s...")
end

-- Start the check loop
task.spawn(function()
    while true do
        local playerCount = #Players:GetPlayers()
        print("📊 Current Players: " .. playerCount)

        if playerCount < MIN_PLAYERS then
            hop()
        end
        
        task.wait(30) -- Check every 30 seconds
    end
end)
