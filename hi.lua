-- [[ SCRIPT 1: AUTO-CHAT (Background Thread) ]] --
task.spawn(function()
    local msg = "free 10-500!"
    local delayTime = 180 -- 3 minutes

    while true do
        local success, err = pcall(function()
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(msg)
        end)
        
        if not success then
            -- Fallback for older games
            local legacyRemote = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
            if legacyRemote then
                legacyRemote.SayMessageRequest:FireServer(msg, "All")
            end
        end
        
        task.wait(delayTime)
    end
end)

-- [[ SCRIPT 2: ANTI-AFK / ANTI-KICK ]] --
-- This runs immediately because Script 1 is now in a 'spawn' thread
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Anti-Kick/main/Anti-Kick.lua"))()

print("✅ Both scripts stacked and running!")
