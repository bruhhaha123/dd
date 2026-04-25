-- [[ 🧠 SMART INFINITE ROOM CREATOR - V5 ]] --
local RS = game:GetService("ReplicatedStorage")
local LP = game.Players.LocalPlayer

-- 1. Configuration
local GAMEPASS_LIST = {
    "890717187", 
    "890513823", 
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

-- 2. The Main Smart Loop
task.spawn(function()
    local cnt = 0
    while true do
        -- 🔍 CHECK: Does your room object exist in Workspace?
        local myRoom = workspace:FindFirstChild(LP.Name)
        
        if not myRoom then
            print("📭 Room not found. Creating a new one...")
            
            local create = find("RemoteCalls.GameSpecific.Tickets.CreateRoom")
            if create then
                -- Rotate through the list (1 -> 2 -> 3 -> repeat)
                local currentID = GAMEPASS_LIST[(cnt % #GAMEPASS_LIST) + 1]
                
                print("🎲 Using GamePass ID: " .. currentID)

                local args = {
                    [1] = "TicTacToe",
                    [2] = 10,
                    [3] = {
                        ["assetType"] = "GamePass",
                        ["assetId"] = currentID
                    },
                    [4] = true
                }

                local success, result = pcall(function()
                    return create:InvokeServer(unpack(args))
                end)

                if success then
                    print("🏠 Room Created! 🚀")
                    cnt = cnt + 1 -- Only move to the next GamePass if successful
                else
                    warn("⚠️ Creation Failed, retrying soon...")
                end
            end
        else
            -- Room is already there, don't do anything
            -- print("✅ Room is active. No action needed.")
        end

        task.wait(10) -- Check every 10 seconds to keep the server happy
    end
end)

-- 3. Daily Spinner (Looping check)
task.spawn(function()
    while true do
        local daily = find("RemoteCalls.GameSpecific.DailySpinner.ClaimDailySpinner") 
        if daily then
            pcall(function() daily:InvokeServer() end)
            print("🎡 Daily Spinner Check Performed!")
        end
        task.wait(10) -- Check every 10 minutes (since you can only claim once a day)
    end
end)
