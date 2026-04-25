-- [[ ♾️ INFINITE ROOM CREATOR & RANDOMIZER ]] --
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer

-- 1. Configuration
local GAMEPASS_LIST = {
    "890717187", 
    "890513823", 
    "890725129"
}
local cnt = 0 -- Moved outside so both tasks can access the same counter

-- 🔍 Fix: Added the missing helper function to prevent "nil" errors
local function getRemote(name)
    local target = RS:FindFirstChild(name, true)
    if target and (target:IsA("RemoteFunction") or target:IsA("RemoteEvent")) then
        return target
    end
    return nil
end

-- 🔍 Logic: Per your request, Room is "Closed" only if UI is Enabled
local function isRoomClosed()
    local lobbyGui = LP.PlayerGui:FindFirstChild("Lobby_Main")
    if lobbyGui and lobbyGui.Enabled == true then
        return true -- Room is closed/Lobby is open
    end
    return false
end

print("🚀 Script Running. Waiting for Lobby...")

-- 2. Loop A: The 270s Auto-Reset (Destroys match if it lasts too long)
task.spawn(function()
    while true do
        task.wait(270)
        
        local lobbyGui = LP.PlayerGui:FindFirstChild("Lobby_Main")
        local isInMatch = lobbyGui and lobbyGui.Enabled == false

        if isInMatch then
            -- Fix: Using getRemote instead of the undefined findRemote
            local destroyRemote = getRemote("DestroyRoom")
            if destroyRemote then
                print("💥 270s reached! Forcing room close...")
                pcall(function() destroyRemote:InvokeServer() end)
                task.wait(5)
            end
        end
    end
end)

-- 3. Loop B: The Main Room Creator
task.spawn(function()
    task.wait(10) -- Initial load wait
    local firstRun = true
    
    while true do
        -- Triggers when you are in Lobby (Enabled == true) or first start
        if isRoomClosed() or firstRun == true then
            if not firstRun then
                print("🏠 Lobby detected. Starting creation sequence...")
            end
            
            firstRun = false
            
            -- If you are in the lobby, wait for the player to be ready
            while isRoomClosed() do
                task.wait(1)
            end
            
            -- Now that lobby closed (game starting), find the remote
            local create = getRemote("CreateRoom")
            if create then
                cnt = cnt % #GAMEPASS_LIST
                local randomID = GAMEPASS_LIST[cnt+1]
                
                print("🎯 Attempting Room Creation: " .. randomID)

                local args = {
                    [1] = "Colors",
                    [2] = 10,
                    [3] = {
                        ["assetType"] = "GamePass",
                        ["assetId"] = randomID
                    },
                    [4] = true
                }

                local success, result = pcall(function()
                    return create:InvokeServer(unpack(args))
                end)

                if success then
                    print("✅ Room Successfully Created!")
                    cnt = cnt + 1
                    task.wait(15) 
                else
                    warn("⚠️ Remote Call Failed: " .. tostring(result))
                    task.wait(5)
                end
            end
        end
        task.wait(2) -- Check frequency
    end
end)

-- 4. Loop C: Daily Spinner
task.spawn(function()
    while true do
        local daily = getRemote("ClaimDailySpinner") 
        if daily then
            pcall(function() daily:InvokeServer() end)
            print("🎡 Daily Spinner Claimed!")
        end
        task.wait(5) 
    end
end)
