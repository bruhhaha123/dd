-- [[ ♾️ INFINITE ROOM CREATOR & RANDOMIZER ]] --
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer
local cnt = 0

-- 1. Configuration
local GAMEPASS_LIST = {"890717187", "890513823", "890725129"}

-- [ 🛡️ SAFE REMOTE FINDER ] --
-- This fixes the "BindableFunction" error by checking the Object Type
local function getRemote(name)
    for _, obj in pairs(RS:GetDescendants()) do
        if obj.Name == name and obj:IsA("RemoteFunction") then
            return obj
        end
    end
    return nil
end

local function chat(msg)
    local tcs = game:GetService("TextChatService"):FindFirstChild("TextChannels")
    if tcs and tcs:FindFirstChild("RBXGeneral") then
        tcs.RBXGeneral:SendAsync(msg)
    else
        local legacy = RS:FindFirstChild("DefaultChatSystemChatEvents")
        if legacy then legacy.SayMessageRequest:FireServer(msg, "All") end
    end
end

local function isRoomClosed()
    local lobbyGui = LP:WaitForChild("PlayerGui"):FindFirstChild("Lobby_Main")
    if not lobbyGui then return true end
    return lobbyGui.Enabled == false 
end

-- [[ 🚩 SIGN CONTROL ]] --
task.spawn(function()
    task.wait(12) 
    local remotePath = RS:WaitForChild("RemoteCalls"):WaitForChild("GameSpecific"):WaitForChild("Sign")
    local change = remotePath:WaitForChild("ChangeSignText")
    local hold = remotePath:WaitForChild("HoldSign")

    local txt = "FREE 10-500!"
    if change:IsA("RemoteEvent") then change:FireServer(txt) else change:InvokeServer(txt) end
    task.wait(2)
    if hold:IsA("RemoteEvent") then hold:FireServer(true) else hold:InvokeServer(true) end
    print("🚩 Sign Active!")
end)

-- [[ 🏠 MAIN ROOM LOOP ]] --
task.spawn(function()
    local firstRun = true
    local canChat = true 

    while true do
        if isRoomClosed() or firstRun then
            if not firstRun and canChat then
                chat("tyyyyyyy!")
                canChat = false 
            end
            firstRun = false

            -- This now finds the REAL RemoteFunction
            local create = getRemote("CreateRoom")
            if create then
                cnt = cnt % #GAMEPASS_LIST
                local randomID = GAMEPASS_LIST[cnt+1]
                
                local args = {[1] = "Colors", [2] = 10, [3] = {["assetType"] = "GamePass", ["assetId"] = randomID}, [4] = true}
                
                local success, result = pcall(function() return create:InvokeServer(unpack(args)) end)

                if success then
                    print("🏠 Room Created: " .. randomID)
                    canChat = true 
                    task.wait(60) -- Longer wait after success
                else
                    warn("⚠️ Creation Failed: " .. tostring(result))
                    task.wait(5)
                end
            end
        end
        task.wait(5)
    end
end)

-- [[ 🎡 DAILY SPINNER ]] --
task.spawn(function()
    while true do
        local daily = getRemote("ClaimDailySpinner")
        if daily then pcall(function() daily:InvokeServer() end) end
        task.wait(60) 
    end
end)

print("🚀 Script Fixed & Running!")
