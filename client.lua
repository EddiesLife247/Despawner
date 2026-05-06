local QBCore = exports['qb-core']:GetCoreObject()

local playerJob = nil

-- Update job when player loads or changes job
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    playerJob = QBCore.Functions.GetPlayerData().job.name
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    playerJob = job.name
end)

-- Discord webhook URL (replace with your actual webhook URL)
local discordWebhookURL = "https://discord.com/api/webhooks/1365007701498789978/0yCDn32NEEIw7ujov0qNdzLmrXMtnWRkrSDeJcHt5u4cjcMg4tnXoWoQM-hvPg2u4jEv"

-- Function to send a Discord log
function sendDiscordLog(message)
    local embed = {
        {
            ["color"] = 16711680,  -- Red color for alerts
            ["title"] = "Vehicle Weapon Fired",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "FiveM Server",
            },
        }
    }

    local data = json.encode({
        username = "Vehicle Weapon Log",
        embeds = embed
    })

    PerformHttpRequest(discordWebhookURL, function(err, text, headers) end, 'POST', data, {['Content-Type'] = 'application/json'})
end

local allowedJobs = {
    staff = true,
    police = true,
    firearms = true,
    response = true,
    cid = true,
    roadspolicing = true,
}

-- Main thread to disable vehicle weapons
CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()

        -- Check if player is in a vehicle
        if IsPedInAnyVehicle(ped, false) then
            -- Only disable for non-authorised jobs
if not allowedJobs[playerJob] then
                -- Check if weapon is fired
                if IsControlJustPressed(0, 69) or IsControlJustPressed(0, 70) or IsControlJustPressed(0, 92) or IsControlJustPressed(0, 257) or IsControlJustPressed(0, 331) then
                    sendDiscordLog("A vehicle weapon was fired by player with job: " .. playerJob)
                end

                -- Disable vehicle weapon controls
                DisableControlAction(0, 69, true)  -- INPUT_VEH_ATTACK
                DisableControlAction(0, 70, true)  -- INPUT_VEH_ATTACK2
                DisableControlAction(0, 92, true)  -- INPUT_VEH_PASSENGER_ATTACK
                DisableControlAction(0, 114, true) -- INPUT_VEH_FLY_ATTACK
                DisableControlAction(0, 257, true) -- INPUT_ATTACK (e.g. aircraft)
                DisableControlAction(0, 331, true) -- INPUT_VEH_FLY_ATTACK_CAMERA
                DisablePlayerFiring(ped, true)     -- Just in case
            end
        end
    end
end)
