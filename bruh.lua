-- [[ ♾️ INFINITE ROOM CREATOR & RANDOMIZER ]] --
local RS = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer

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

-- 🔍 Simplified Button Detection
local function isRoomClosed()
local lobbyGui = LP.PlayerGui:FindFirstChild("Lobby_Main")
if lobbyGui.Enabled == true then
    return false
    end
    return true
end

print("🚀 Script Running. Waiting for 'Play' button...")
task.spawn(function()
    while true do
        -- 1. ⏳ The 270 Second Wait
        task.wait(270)

        -- 2. 🔍 Logic Check: Are we in a match?
        local lobbyGui = LP.PlayerGui:FindFirstChild("Lobby_Main")
        local isInMatch = lobbyGui and lobbyGui.Enabled == false

        -- 3. 💥 Step A: Destroy Room (Only if in match)
        if isInMatch then
            local destroyRemote = findRemote("DestroyRoom")
            if destroyRemote and destroyRemote:IsA("RemoteFunction") then
                print("💥 Time limit reached! Destroying old room...")
                pcall(function() destroyRemote:InvokeServer() end)
                task.wait(5) -- Give the game time to reset you to lobby
            end
        end

        -- 4. 🏠 Step B: Create New Room (Lobby should be open now)
        local createRemote = findRemote("CreateRoom")
        if createRemote and createRemote:IsA("RemoteFunction") then
            cnt = cnt % #GAMEPASS_LIST
            local randomID = GAMEPASS_LIST[cnt + 1]

            print("🎯 Attempting Room Creation with ID: " .. randomID)

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
                return createRemote:InvokeServer(unpack(args))
            end)

            if success then
                print("✅ Room Successfully Created!")
                cnt = cnt + 1
            else
                warn("⚠️ Creation Failed: " .. tostring(result))
            end
        end
    end
end)
        
-- 2. The Main Loop (Room Creator)
task.spawn(function()
    task.wait(10)
    local firstRun=true
    local cnt = 0
    while true do
        if isRoomClosed()or firstRun==true then
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
        task.wait(60) 
    end
end)
