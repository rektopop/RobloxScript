local Window = Fluent:CreateWindow({
Title = "Sara Hub",
SubTitle = "Steal an Egg",
TabWidth = 160,
Size = UDim2.fromOffset(580, 460),
Acrylic = true,
Theme = "Dark",
MinimizeKey = Enum.KeyCode.RightControl
})

-- Вкладки
local Tabs = {
HatchESP = Window:AddTab({ Title = "Hatch & ESP", Icon = "eye" }),
EquipSell = Window:AddTab({ Title = "Equip & Sell", Icon = "coins" }),
VisualPets = Window:AddTab({ Title = "Visual Pets", Icon = "star" }),
ClaimUpgrade = Window:AddTab({ Title = "Claim & Upgrade", Icon = "box" }),
Treadmill = Window:AddTab({ Title = "Treadmill", Icon = "activity" }),
Settings = Window:AddTab({ Title = "Configuration", Icon = "settings" })
}

local Options = Fluent.Options

-- Глобальные переменные
getgenv().AutoClaim = false
getgenv().ClaimInterval = 20
getgenv().AutoUpgrade = false

-- Функции взаимодействия с игрой
local function DoClaim()
pcall(function()
local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
if remotes and remotes:FindFirstChild("ClaimReward") then
remotes.ClaimReward:FireServer()
end
end)
end

local function DoUpgrade()
pcall(function()
local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
if remotes and remotes:FindFirstChild("BuyUpgrade") then
remotes.BuyUpgrade:FireServer("All")
end
end)
end

-- Наполнение вкладки Claim & Upgrade
local Section = Tabs.ClaimUpgrade:AddSection("Claim & Upgrade")

local ToggleAutoClaim = Tabs.ClaimUpgrade:AddToggle("AutoClaimToggle", {
Title = "Enable Auto Claim",
Description = "Collects base earnings and finished quest rewards",
Default = false
})

ToggleAutoClaim:OnChanged(function(State)
getgenv().AutoClaim = State
if State then
task.spawn(function()
while getgenv().AutoClaim do
DoClaim()
task.wait(getgenv().ClaimInterval)
end
end)
end
end)

local SliderClaimInterval = Tabs.ClaimUpgrade:AddSlider("ClaimIntervalSlider", {
Title = "Claim Interval",
Description = "Seconds between claims",
Default = 20,
Min = 1,
Max = 60,
Rounding = 0
})

SliderClaimInterval:OnChanged(function(Value)
getgenv().ClaimInterval = Value
end)

Tabs.ClaimUpgrade:AddButton({
Title = "Claim Now",
Description = "Manually trigger claim",
Callback = function()
DoClaim()
end
})

local ToggleAutoUpgrade = Tabs.ClaimUpgrade:AddToggle("AutoUpgradeToggle", {
Title = "Enable Auto Upgrade",
Description = "Raises the base tier and buys whatever upgrade is in reach",
Default = false
})

ToggleAutoUpgrade:OnChanged(function(State)
getgenv().AutoUpgrade = State
if State then
task.spawn(function()
while getgenv().AutoUpgrade do
DoUpgrade()
task.wait(2)
end
end)
end
end)

Window:SelectTab(4) -- Сразу открываем 4-ю вкладку (Claim & Upgrade)
Fluent:Notify({
Title = "Sara Hub",
Content = "Запущено через Wave",
Duration = 5
})
