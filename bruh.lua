-- [[ ♾️ INFINITE ROOM CREATOR & RANDOMIZER ]] --
local RS = game:GetService("ReplicatedStorage")

-- 1. Configuration
local GAMEPASS_LIST = {
    "890717187", -- Your first GamePass ID
    "890513823", -- Add more IDs here in quotes!
    "890725129"
}

local function find(path)
    local current = RS
    for _, name in pairs(path:split(".")) do
        current = current:WaitForChild(name, 5)
        if not current then return nil end
    end
    return current
end

-- 2. The Main Loop
task.spawn(function()
    local cnt=0;
    while true do
        cnt=cnt%3
        local create = find("RemoteCalls.GameSpecific.Tickets.CreateRoom")
        
        if create then
            -- 🎲 Pick a random GamePass from your list
            local randomID = GAMEPASS_LIST[cnt+1]
            
            print("🎲 Randomizing: Using GamePass ID " .. randomID)

            local args = {
                [1] = "TicTacToe",
                [2] = 10,
                [3] = {
                    ["assetType"] = "GamePass",
                    ["assetId"] = randomID -- String from our random list
                },
                [4] = true
            }

            -- Try to create the room
            local success, result = pcall(function()
                return create:InvokeServer(unpack(args))
            end)

            if success then
                print("🏠 Room Created! Waiting for match to end...")
            else
                warn("⚠️ Room Creation Failed, retrying in 10s...")
            end
        end

        -- ⏳ The "Cooldown" 
        -- This waits 30 seconds before checking to create a NEW room.
        -- Adjust this based on how long your matches usually last!
        task.wait(30)
        cnt=cnt+1
    end
end)

-- 3. Daily Spinner (Runs once on join)
task.spawn(function()
    local daily = find("RemoteCalls.GameSpecific.DailySpinner.ClaimDailySpinner") 
    if daily then
        pcall(function() daily:InvokeServer() end)
        print("🎡 Daily Spinner Claimed!")
    end
end)
