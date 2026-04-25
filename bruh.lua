-- [[ ♾️ INFINITE ROOM CREATOR & RANDOMIZER ]] --
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer
cnt=0
-- 1. Configuration
local GAMEPASS_LIST = {
    "890717187", 
    "890513823", 
    "890725129"
}

-- 🔍 Improved Remote Search (Fixed the Bindable/Remote issue)
local function getRemote()
    local create = RS:FindFirstChild("CreateRoom", true) 
    if create and create:IsA("RemoteFunction") then
        return create
    end
    -- Fallback to the known path if the search fails
    local folderPath = RS:FindFirstChild("RemoteCalls", true)
    if folderPath then
        local target = folderPath:FindFirstChild("CreateRoom", true)
        if target and target:IsA("RemoteFunction") then return target end
    end
    return nil
end
local function getDestroyRemote()
    local create = RS:FindFirstChild("DestroyRoom", true) 
    if create and create:IsA("RemoteFunction") then
        return create
    end
    -- Fallback to the known path if the search fails
    local folderPath = RS:FindFirstChild("RemoteCalls", true)
    if folderPath then
        local target = folderPath:FindFirstChild("DestroyRoom", true)
        if target and target:IsA("RemoteFunction") then return target end
    end
    return nil
end
-- 🔍 Simplified Button Detection
local function isRoomClosed()
local lobbyGui = LP.PlayerGui:FindFirstChild("Lobby_Main")
if lobbyGui.Enabled == true then
    return false
    end
    return true
end
task.spawn(function()
    task.wait(800)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end)
print("🚀 Script Running. Waiting for 'Play' button...")
task.spawn(function()
    while true do
        task.wait(400)
        local destroyRemote = getDestroyRemote()

-- 2. Check if the remote actually exists
        if destroyRemote then
        print("📡 Sending DestroyRoom signal...")
    
    -- 3. Use pcall to fire it safely
        local success, result = pcall(function()
            return destroyRemote:InvokeServer()
        end)

        if success then
            print("✅ Room destroyed successfully!")
        else
            warn("⚠️ Failed to fire remote: " .. tostring(result))
        end
        else
            warn("❌ Could not find the DestroyRoom RemoteFunction!")
        end
            task.wait(2)
        local create = getRemote()
            
        if create then
            cnt = cnt % #GAMEPASS_LIST
            local randomID = GAMEPASS_LIST[cnt+1]
            print("🎯 auto create: " .. randomID)
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
                print("🏠 Room Successfully Created!")
                cnt = cnt + 1
                task.wait(15) -- Prevent instant double-creation
            else
                warn("⚠️ Remote Call Failed: " .. tostring(result))
                task.wait(5)
            end
        else
            warn("⚠️ 'CreateRoom' RemoteFunction not found!")
            task.wait(10)
        end
    end
end)
            
            
-- 2. The Main Loop (Room Creator)
task.spawn(function()
    task.wait(10)
    local firstRun=true
    while true do
        if isRoomClosed() or firstRun==true then
            print("yo")
                firstRun=false
            while isRoomClosed() do
            task.wait(1)
            end
            local create = getRemote()
            
            if create then
                cnt = cnt % #GAMEPASS_LIST
                local randomID = GAMEPASS_LIST[cnt+1]
                
                print("🎯 Play Button Found! Attempting Room Creation: " .. randomID)

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
                    print("🏠 Room Successfully Created!")
                    cnt = cnt + 1
                    task.wait(15) -- Prevent instant double-creation
                else
                    warn("⚠️ Remote Call Failed: " .. tostring(result))
                    task.wait(5)
                end
            else
                warn("⚠️ 'CreateRoom' RemoteFunction not found!")
                task.wait(10)
            end
        end
        task.wait(2) -- Scan frequency
    end
end)

-- 3. Daily Spinner
task.spawn(function()
    while true do
        local daily = RS:FindFirstChild("ClaimDailySpinner", true) 
        if daily and daily:IsA("RemoteFunction") then
            pcall(function() daily:InvokeServer() end)
            print("🎡 Daily Spinner Claimed!")
        end
        task.wait(2) 
    end
end)
