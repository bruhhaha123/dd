-- [[ ♾️ INFINITE ROOM CREATOR & RANDOMIZER ]] --
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer
local cnt = 0
wait(15)
-- 1. Configuration
local GAMEPASS_LIST = {"890717187", "890513823", "890725129"}

local function chat(msg)
    local tcs = game:GetService("TextChatService"):FindFirstChild("TextChannels")
    if tcs and tcs:FindFirstChild("RBXGeneral") then
        tcs.RBXGeneral:SendAsync(msg)
    else
        local legacy = RS:FindFirstChild("DefaultChatSystemChatEvents")
        if legacy then legacy.SayMessageRequest:FireServer(msg, "All") end
    end
end

-- 🔍 Improved Remote Search
local function getRemote(name)
    return RS:FindFirstChild(name, true)
end

-- 🔍 Improved UI Detection (Checks if Lobby is actually visible)
local function isRoomClosed()
    local lobbyGui = LP:WaitForChild("PlayerGui"):FindFirstChild("Lobby_Main")
    if not lobbyGui then return true end
    return lobbyGui.Enabled == false -- If lobby is NOT enabled, room is closed/active
end

-- [[ 🚩 SIGN CONTROL SYSTEM ]] --
task.spawn(function()
    local signText = "FREE 10-500!"
    task.wait(10) -- Wait for character to load
    
    local remotePath = RS:WaitForChild("RemoteCalls"):WaitForChild("GameSpecific"):WaitForChild("Sign")
    local changeRemote = remotePath:WaitForChild("ChangeSignText")
    local holdRemote = remotePath:WaitForChild("HoldSign")

    -- Change Text
    if changeRemote:IsA("RemoteEvent") then
        changeRemote:FireServer(signText)
    else
        changeRemote:InvokeServer(signText)
    end
    
    task.wait(2)

    -- Hold Sign
    if holdRemote:IsA("RemoteEvent") then
        holdRemote:FireServer(true)
    else
        holdRemote:InvokeServer(true)
    end
    print("🚩 Sign is up and text is set!")
end)

-- [[ 🏠 MAIN ROOM LOOP ]] --
task.spawn(function()
    local firstRun = true
    local canChat = true -- Debounce for the chat spam

    while true do
        if isRoomClosed() or firstRun then
            print("🔄 Checking Room Status...")
            
            -- Only chat if we haven't just chatted
            if not firstRun and canChat then
                chat("tyyyyyyy!")
                canChat = false -- Stop spamming until next successful creation
            end
            
            firstRun = false

            -- Try to create room
            local create = getRemote("CreateRoom")
            if create then
                cnt = cnt % #GAMEPASS_LIST
                local randomID = GAMEPASS_LIST[cnt+1]
                
                local args = {[1] = "Colors", [2] = 10, [3] = {["assetType"] = "GamePass", ["assetId"] = randomID}, [4] = true}
                
                local success, result = pcall(function() return create:InvokeServer(unpack(args)) end)

                if success then
                    print("🏠 Room Successfully Created!")
                    cnt = cnt + 1
                    canChat = true -- Allow chatting for the NEXT room
                    task.wait(30) -- Wait for room to actually open
                else
                    warn("⚠️ Creation Failed: " .. tostring(result))
                end
            end
        end
        task.wait(5) -- Scan frequency
    end
end)

-- [[ 🎡 DAILY SPINNER ]] --
task.spawn(function()
    while true do
        local daily = getRemote("ClaimDailySpinner")
        if daily then pcall(function() daily:InvokeServer() end) end
        task.wait(2) 
    end
end)

print("🚀 Mega-Script Loaded and Running!")
