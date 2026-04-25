-- [[ SCRIPT 1: UPGRADED HUMANIZED AUTO-CHAT ]] --
task.spawn(function()
    local chatMessages = {
        "free 10-500!",
        "yo who wants free 10-500??",
        "giving out free 10-500 right now",
        "free 10-500! first come first serve",
        "anyone need free 10-500? lmk",
        "free 10-500 guys, check it out",
        "drop a message if u want free 10-500",
        "easy free 10-500 lol"
    }

    local delayTime = 180 -- 3 minutes
    local rng = Random.new() -- More reliable than math.random
    local lastIndex = 0

    while true do
        -- Ensure we don't pick the same message twice in a row
        local newIndex
        repeat
            newIndex = rng:NextInteger(1, #chatMessages)
        until newIndex ~= lastIndex
        
        lastIndex = newIndex
        local selectedMsg = chatMessages[newIndex]

        local success, err = pcall(function()
            -- Modern Chat System
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(selectedMsg)
        end)
        
        if not success then
            -- Legacy Chat System
            local legacyRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if legacyRemote then
                legacyRemote.SayMessageRequest:FireServer(selectedMsg, "All")
            end
        end
        
        print("🎲 [Randomizer] Sent: " .. selectedMsg)
        task.wait(delayTime)
    end
end)

-- [[ SCRIPT 2: ANTI-AFK / ANTI-KICK ]] --
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Anti-Kick/main/Anti-Kick.lua"))()

-- [[ SYSTEM STATUS ]] --
print("✨ ----------------------------------- ✨")
print("🔥 RANDOMIZER UPGRADED")
print("✅ No-Repeat Logic: ENABLED")
print("🛡️ Anti-Kick: ACTIVE")
print("✨ ----------------------------------- ✨")
