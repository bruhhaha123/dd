-- [[ ♾️ INFINITE ROOM CREATOR & SIGN CONTROLLER ]] --
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer
local cnt = 0

-- 1. ⚠️ UPDATE THESE IDs
-- Make sure these GamePasses are actually for THIS game!
local GAMEPASS_LIST = {
    "890717187", 
    "890513823", 
    "890725129"
}

-- [ 🛡️ SAFE REMOTE FINDER ] --
local function getRemote(name)
    for _, obj in pairs(RS:GetDescendants()) do
        if obj.Name == name and obj:IsA("RemoteFunction") then
            return obj
        end
    end
    return nil
end

-- [ 🚩 SIGN CONTROL SYSTEM ] --
task.spawn(function()
    task.wait(10) -- Wait for character to load
    local signFolder = RS:FindFirstChild("RemoteCalls", true) 
    if signFolder then
        local signPath = signFolder:FindFirstChild("Sign", true)
        if signPath then
            local change = signPath:FindFirstChild("ChangeSignText")
            local hold = signPath:FindFirstChild("HoldSign")
            
            if change and hold then
                local txt = "FREE 10-500!"
                if change:IsA("RemoteEvent") then change:FireServer(txt) else change:InvokeServer(txt) end
                task.wait(1)
                if hold:IsA("RemoteEvent") then hold:FireServer(true) end
                print("🚩 Sign text set and character is holding it!")
            end
        end
    end
end)

-- [ 🏠 MAIN ROOM LOOP ] --
task.spawn(function()
    print("🚀 Script Running. Watching for room status...")
    while true do
        local lobbyGui = LP.PlayerGui:FindFirstChild("Lobby_Main")
        -- If Lobby UI is NOT visible, we are likely not in a room
        if lobbyGui and lobbyGui.Enabled == false then
            local create = getRemote("CreateRoom")
            
            if create then
                cnt = cnt % #GAMEPASS_LIST
                local currentID = GAMEPASS_LIST[cnt + 1]
                
                print("🎯 Attempting Room with ID: " .. currentID)
                
                local args = {
                    [1] = "Colors",
                    [2] = 10,
                    [3] = {["assetType"] = "GamePass", ["assetId"] = currentID},
                    [4] = true
                }

                local success, result = pcall(function() 
                    return create:InvokeServer(unpack(args)) 
                end)

                if success then
                    print("✅ Room Created successfully!")
                    cnt = cnt + 1
                    task.wait(300) -- Wait 5 minutes before checking again
                else
                    -- If you see "User changed price" here, the ID in your list is wrong
                    warn("❌ Server Error: " .. tostring(result))
                    task.wait(10)
                end
            end
        end
        task.wait(5)
    end
end)

-- [ 🎡 DAILY SPINNER ] --
task.spawn(function()
    while true do
        local daily = getRemote("ClaimDailySpinner")
        if daily then pcall(function() daily:InvokeServer() end) end
        task.wait(60) 
    end
end)
