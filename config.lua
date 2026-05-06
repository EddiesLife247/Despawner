-- config.lua
Config = {}

-- List of restricted vehicles
Config.RestrictedVehicles = {
    ["RHINO"] = { "staff" },  -- RHINO can be spawned by the "military" job
    ["LAZER"] = { "staff" },  -- LAZER can be spawned by "military" and "police"
    ["HYDRA"] = { "staff" },  -- HYDRA can only be spawned by "military"
    ["ambulance"] = {}, 
    ["policeb"] = {}, 
    ["boxville5"] = {},
    ["minitank"] = {},
    ["khankali"] = {},
    ["barrage"] = {},
    ["halftrack"] = {},
    ["apc"] = {},
    ["phantom2"] = {},
    ["menacer"] = {},
    ["insurgent"] = {},
    ["insurgen2"] = {},
    ["insurgent3"] = {},
    ["caracara"] = {},
    ["dune2"] = {},
    ["technical"] = {},
    ["technical2"] = {},
    ["technical3"] = {},
    ["buzzard"] = { "staff" },
    ["firetruk"] = { "staff", "fire" },
}

-- Discord webhook URL for logging
Config.DiscordWebhook = "https://discord.com/api/webhooks/1328133630605922385/s_GDBbP6dfit36S7nWYklh-KwUKx728cXU1B4vviB_yxdnElZS2JKL_z_6ZHWTnTq7V-"

-- Message customization
Config.WebhookMessage = "Player [%s | ID: %s] attempted to spawn a restricted vehicle: %s"
Config.WebhookUsername = "Vehicle Logger"
Config.WebhookAvatar = "https://example.com/avatar.png"

-- Scan interval for world entities (in milliseconds)
Config.ScanInterval = 5000

-- Debug Levels
-- 0 = No debug
-- 1 = Minimal (vehicle removals only)
-- 2 = Verbose (detailed logs)
Config.DebugLevel = 0 -- Set the desired debug level
