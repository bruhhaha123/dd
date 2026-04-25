-- [[ SMART ROOM MANAGER - REFINED CHECK ]] --
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

-- 1. Configuration
local GAMEPASS_LIST = {
    "890717187", 
    "890513823", 
    "890725129"
}

local function findRemote(path)
    local current = RS
    for _, name in pairs(path:split(".")) do
        current = current:WaitForChild(name, 5)
        if not current then return nil end
    end
    return current
end

-- 2. The Main Manager Loop
task.spawn(function()
    local cnt = 0
    while true do
        -- 🔍 SPECIFIC CHECK:
        -- We look for an object in Workspace with your name that IS NOT your character.
        local roomObject = workspace:FindFirstChild(LP.Name)
        local isActuallyARoom = false
        
        if roomObject and roomObject ~= LP.Character then
            isActuallyARoom = true
        end
        
        if not isActuallyARoom then
            print("📭 No room detected (Character doesn't count). Creating...")
            
            local create = findRemote("RemoteCalls.GameSpecific.Tickets.CreateRoom")
            if create then
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
                    cnt = cnt + 1
                else
                    warn("⚠️ Creation Failed: " .. tostring(result))
                end
            end
        else
            -- print("✅ Room detected in Workspace. Waiting...")
        end

        task.wait(10) 
    end
end)

-- 3. Daily Spinner (Safe Interval)
task.spawn(function()
    while true do
        local daily = findRemote("RemoteCalls.GameSpecific.DailySpinner.ClaimDailySpinner") 
        if daily then
            pcall(function() daily:InvokeServer() end)
            print("🎡 Daily Spinner Check Done.")
        end
        task.wait(5) -- Check every 5 minutes
    end
end)
