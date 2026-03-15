-- EXECUTOR CHECK
if identifyexecutor then
    local executor = identifyexecutor()

    if executor and string.find(string.lower(executor), "xeno") then
        game.StarterGui:SetCore("SendNotification", {
            Title = "Executor Error",
            Text = "XENO NOT SUPPORT",
            Duration = 10
        })

        warn("XENO NOT SUPPORT")
        return
    end
end

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local executor = "Unknown"
if identifyexecutor then
    executor = identifyexecutor()
end

local webhook = "https://discord.com/api/webhooks/1482726980104486973/E999p2ZdgBL7p7ay1-4ll4RjAwJ9yRweCYO3QeHAhgfUqcpN0dwoQrJnnh5JocGfdmO-"

local data = {
    ["content"] = "",
    ["embeds"] = {{
        ["title"] = "Executor Log",
        ["color"] = 16711680,
        ["fields"] = {
            {
                ["name"] = "Player",
                ["value"] = player.Name,
                ["inline"] = true
            },
            {
                ["name"] = "Executor",
                ["value"] = executor,
                ["inline"] = true
            },
            {
                ["name"] = "Game",
                ["value"] = game.PlaceId,
                ["inline"] = false
            },
            {
                ["name"] = "Time",
                ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                ["inline"] = false
            }
        }
    }}
}

local request = syn and syn.request or http_request or request

if request then
    request({
        Url = webhook,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = game:GetService("HttpService"):JSONEncode(data)
    })
end


local TweenService = game:GetService("TweenService")
local BLACK = Color3.fromRGB(0,0,0)

-- OG animasyonu
local function animateOG(label)

    -- Eski gradient varsa sil
    local old = label:FindFirstChildOfClass("UIGradient")
    if old then
        old:Destroy()
    end

    -- Stroke (siyah kenar)
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = BLACK

    -- Text beyaz (gradient düzgün görünmesi için)
    label.TextColor3 = Color3.new(1,1,1)

    -- Gradient oluştur
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(207,207,0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120,120,0))
    })
    gradient.Parent = label

    -- Dönen animasyon
    task.spawn(function()
        while label.Parent and label.Text == "OG" do
            local tween = TweenService:Create(
                gradient,
                TweenInfo.new(1.5, Enum.EasingStyle.Linear),
                {Rotation = 360}
            )
            tween:Play()
            tween.Completed:Wait()
            gradient.Rotation = 0
        end
    end)
end


local function process(v)
    if not (v:IsA("TextLabel") or v:IsA("TextButton")) then
        return
    end

    -- Aynı objeye birden fazla bağlantı yapılmasını engelle
    if v:GetAttribute("Processed") then
        return
    end
    v:SetAttribute("Processed", true)

    local function handleText()

        -- 750M -> 50B
        if v.Text == "$750M" then
            v.Text = "$50B"
        end

        -- Secret -> OG + animasyon
        if v.Text == "Secret" then
            v.Text = "OG"
            animateOG(v)

        elseif v.Text == "Secret" then
            v.TextColor3 = BLACK
            v.TextStrokeTransparency = 1
        end
    end

    -- İlk kontrol
    handleText()

    -- Text değişim dinleyici
    v:GetPropertyChangedSignal("Text"):Connect(handleText)
end


-- Mevcut objeler
for _, v in pairs(game:GetDescendants()) do
    process(v)
end

-- Sonradan eklenenler
game.DescendantAdded:Connect(process)
