-- [[ SCRIPT 1: HUMANIZED AUTO-CHAT ]] --
task.spawn(function()
    -- 📝 Your original message but styled like a real person typing
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

    local delayTime = 120 -- 3 minutes
    math.randomseed(tick())

    while true do
        -- Pick a random version of your message
        local selectedMsg = chatMessages[math.random(1, #chatMessages)]

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
        
        print("🤖 Humanized Chat Sent: " .. selectedMsg)
        task.wait(delayTime)
    end
end)

-- [[ SCRIPT 2: ANTI-AFK / ANTI-KICK ]] --
-- Keeps you in the server 24/7
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Anti-Kick/main/Anti-Kick.lua"))()

-- [[ SYSTEM STATUS ]] --
print("✨ ----------------------------------- ✨")
print("✅ SCRIPT LOADED SUCCESSFULLY")
print("💬 Message Style: Informal / Human")
print("🛡️ Anti-Kick: Active")
print("✨ ----------------------------------- ✨")
