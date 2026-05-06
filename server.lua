local QBCore = exports['qb-core']:GetCoreObject()
local lastDiscordNotification = {}

-- Function to log debug messages
local function debugLog(message, level)
    level = level or 2
    if Config.DebugLevel >= level then
        print("[DEBUG]: " .. message)
    end
end

-- Function to log to Discord
local function sendToDiscord(message, playerId, vehicle)
    if not Config.DiscordWebhook or Config.DiscordWebhook == "" then return end

    local embed = {
        {
            ["color"] = 16711680, -- Red
            ["title"] = "Restricted Vehicle Spawn Attempt",
            ["description"] = string.format(Config.WebhookMessage, GetPlayerName(playerId), playerId, vehicle),
            ["footer"] = {
                ["text"] = "Vehicle Despawner Logs",
            }
        }
    }

    PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({
        username = Config.WebhookUsername or "Vehicle Logger",
        avatar_url = Config.WebhookAvatar or "",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- Check if a vehicle is restricted and verify job permissions
local function canJobSpawnVehicle(modelHash, jobName)
    local allowedJobs = Config.RestrictedVehicleHashes[modelHash]
    if allowedJobs then
        debugLog(string.format("Checking permissions for vehicle: %s (Job: %s)", modelHash, jobName), 2)
        for _, job in ipairs(allowedJobs) do
            if jobName == job then
                debugLog(string.format("Permission granted for vehicle: %s (Job: %s)", modelHash, jobName), 2)
                return true
            end
        end
        debugLog(string.format("Permission denied for vehicle: %s (Job: %s)", modelHash, jobName), 2)
        return false
    end
    return true -- Vehicle not restricted
end

-- Periodically scan the world for restricted vehicles
CreateThread(function()
    while true do
        Wait(Config.ScanInterval)
        debugLog("Scanning world for restricted vehicles...", 2)
        for _, vehicle in ipairs(GetAllVehicles()) do
            local model = GetEntityModel(vehicle)
            local owner = NetworkGetEntityOwner(vehicle)

            if owner ~= -1 then
                -- Vehicle has a network owner (player)
                local player = QBCore.Functions.GetPlayer(owner)
                if player then
                    local playerJob = player.PlayerData.job.name
                    if not canJobSpawnVehicle(model, playerJob) then
                        debugLog(string.format("Deleting unauthorized vehicle: %s (Owner: %s)", model, owner), 1)

                        sendToDiscord("Unauthorized Vehicle Despawned", owner, model)
                        DeleteEntity(vehicle)
                    end
                end
            else
                -- Vehicle has no network owner, treat as unowned
                for restrictedVehicleHash, _ in pairs(Config.RestrictedVehicleHashes) do
                    if model == restrictedVehicleHash then
                        debugLog("Deleting unowned restricted vehicle (hash): " .. model, 1)
                        DeleteEntity(vehicle)
                        break
                    end
                end
            end
        end
    end
end)
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("^2[VEHICLE DESPAWNER]^0 Server-side script loaded, developed by EddiesLife247 Scripts. Support at: https://discord.eddieslife247.co.uk/")

        -- Build the RestrictedVehicleHashes table
        Config.RestrictedVehicleHashes = {}
        for vehicleName, allowedJobs in pairs(Config.RestrictedVehicles) do
            Config.RestrictedVehicleHashes[GetHashKey(vehicleName)] = allowedJobs
        end

        -- Check for updates asynchronously
        if PerformHttpRequest then
            PerformHttpRequest("https://eddieslife247.co.uk/Despawner/version.txt", function(statusCode, response, headers)
                if statusCode == 200 and response then
                    local currentVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
                    local remoteVersion = response:match("%S+") -- Extract the version string

                    if remoteVersion and currentVersion ~= remoteVersion then
                        print("^3[VEHICLE DESPAWNER]^0 A New Update is available on the keymaster site! Version: " .. remoteVersion)
                    else
                        print("^2[VEHICLE DESPAWNER]^0 You are using the latest version.")
                    end
                else
                    print("^1[VEHICLE DESPAWNER]^0 Failed to check for updates. Status Code: " .. tostring(statusCode))
                end
            end, "GET", "", {['Content-Type'] = 'text/plain'})
        else
            print("^1[VEHICLE DESPAWNER]^0 Cannot check for updates: PerformHttpRequest not available.")
        end
    end
end)
