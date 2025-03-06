local webhookURL = "https://discord.com/api/webhooks/1347045410107035730/MceuTphQXKhJS5XdAcI5mDRj9oeZSzSqshepQ_JQMD5QFRQ_8xyEZnf7GSpa4sbp2Nqx"

RegisterServerEvent("playerDied")
AddEventHandler("playerDied", function(killedBy, weapon)
    local victim = source
    local killer = killedBy

    if victim == nil or killer == nil then return end

    local victimName = GetPlayerName(victim)
    local killerName = GetPlayerName(killer)

    local victimHealth = GetEntityHealth(GetPlayerPed(victim))
    local killerHealth = GetEntityHealth(GetPlayerPed(killer))

    local victimPing = GetPlayerPing(victim)
    local killerPing = GetPlayerPing(killer)

    local victimDiscord = GetDiscord(victim)
    local killerDiscord = GetDiscord(killer)

    local victimID = GetPlayerServerId(victim)
    local killerID = GetPlayerServerId(killer)

    -- Get Nearest Postal (if available)
    local victimCoords = GetEntityCoords(GetPlayerPed(victim))
    local postal = GetNearestPostal(victimCoords) or "Unknown"

    -- Construct the embed message
    local embedData = {
        {
            ["title"] = "🔫 Kill Log",
            ["color"] = 16711680, -- Red color
            ["fields"] = {
                {["name"] = "💀 Victim", ["value"] = victimName .. " (ID: " .. victimID .. ")", ["inline"] = true},
                {["name"] = "🔪 Killer", ["value"] = killerName .. " (ID: " .. killerID .. ")", ["inline"] = true},
                {["name"] = "📍 Nearest Postal", ["value"] = postal, ["inline"] = false},
                {["name"] = "📊 Victim Health", ["value"] = tostring(victimHealth), ["inline"] = true},
                {["name"] = "📊 Killer Health", ["value"] = tostring(killerHealth), ["inline"] = true},
                {["name"] = "📶 Victim Ping", ["value"] = tostring(victimPing) .. "ms", ["inline"] = true},
                {["name"] = "📶 Killer Ping", ["value"] = tostring(killerPing) .. "ms", ["inline"] = true},
                {["name"] = "🎮 Weapon Used", ["value"] = weapon or "Unknown", ["inline"] = false},
                {["name"] = "🔗 Discord Mentions", ["value"] = victimDiscord .. " | " .. killerDiscord, ["inline"] = false}
            },
            ["footer"] = {["text"] = "FiveM Kill Logs", ["icon_url"] = "https://i.imgur.com/AfFp7pu.png"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }

    -- Send to Discord
    PerformHttpRequest(webhookURL, function(err, text, headers) end, "POST", json.encode({username = "Kill Logger", embeds = embedData}), {["Content-Type"] = "application/json"})
end)

-- Function to get Discord ID
function GetDiscord(player)
    for _, id in ipairs(GetPlayerIdentifiers(player)) do
        if string.match(id, "discord:") then
            return "<@" .. string.sub(id, 9) .. ">"
        end
    end
    return "Not Linked"
end

-- Function to get nearest postal (if you use a postal script)
function GetNearestPostal(coords)
    local postal = exports["nearest-postal"]:getPostal(coords)
    return postal and postal.code or nil
end
