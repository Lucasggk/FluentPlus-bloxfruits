local Fluent = loadstring(Game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()
 
local Window = Fluent:CreateWindow({
    Title = "Blox fruits",
    SubTitle = "Feito por Lucas",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark"
})

local main = Window:AddTab({ Title = "main farm", Icon = "home" })
local config = Window:AddTab({ Title = "configurações", Icon = "settings" })

FastAttackmob = true 
FastAttackplayer = true 

local section = config:AddSection("Fast Attack")

config:AddToggle("", {
    Title = "FastAttack em mob",
    Default = true,
    Callback = function(value)
        FastAttackmob = value
    end
})

config:AddToggle("", {
    Title = "FastAttack em player",
    Default = true,
    Callback = function(value)
        FastAttackplayer = value
    end
})

config:AddToggle("", {
    Title = "Fast Attack",
    Default = true,
    Callback = function(value)
        if not value then return end

        local Player = game.Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RunService = game:GetService("RunService")

        local function SafeWaitForChild(parent, childName)
            local obj
            pcall(function()
                obj = parent:WaitForChild(childName, 5)
            end)
            return obj
        end

        local Remotes = SafeWaitForChild(ReplicatedStorage, "Remotes")
        if not Remotes then return end

        local Net = SafeWaitForChild(SafeWaitForChild(ReplicatedStorage, "Modules"), "Net")
        local RegisterAttack = SafeWaitForChild(Net, "RE/RegisterAttack")
        local RegisterHit = SafeWaitForChild(Net, "RE/RegisterHit")

        local Enemies = SafeWaitForChild(workspace, "Enemies")
        local Characters = SafeWaitForChild(workspace, "Characters")

        local FastAttack = {
            Distance = 100
        }

        local function IsAlive(character)
            return character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0
        end

        local function ProcessEnemies(OthersEnemies, Folder)
            for _, Enemy in Folder:GetChildren() do
                local Head = Enemy:FindFirstChild("Head")
                if Head and IsAlive(Enemy) and Player:DistanceFromCharacter(Head.Position) < FastAttack.Distance then
                    if Enemy ~= Player.Character then
                        table.insert(OthersEnemies, { Enemy, Head })
                    end
                end
            end
        end

        local function AttackNearest()
            local OthersEnemies = {}
            if FastAttackmob then ProcessEnemies(OthersEnemies, Enemies) end
            if FastAttackplayer then ProcessEnemies(OthersEnemies, Characters) end

            local character = Player.Character
            if not character then return end
            local equippedWeapon = character:FindFirstChildOfClass("Tool")

            if equippedWeapon and equippedWeapon:FindFirstChild("LeftClickRemote") then
                for _, enemyData in ipairs(OthersEnemies) do
                    local enemy = enemyData[1]
                    local direction = (enemy.HumanoidRootPart.Position - character:GetPivot().Position).Unit
                    pcall(function()
                        equippedWeapon.LeftClickRemote:FireServer(direction, 1)
                    end)
                end
            elseif #OthersEnemies > 0 then
                RegisterAttack:FireServer(0)
                RegisterHit:FireServer(OthersEnemies[1][2], OthersEnemies)
            end
        end

        task.spawn(function()
            while value do
                AttackNearest()
                task.wait(0)
            end
        end)
    end
})

local section = config:AddSection("FPS")

config:AddToggle("", {
    Title = "Exibir FPS",
    Default = false,
    Callback = function(value)
        if value then
            local Players = game:GetService("Players")
            local RunService = game:GetService("RunService")
            local LocalPlayer = Players.LocalPlayer

            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            ScreenGui.IgnoreGuiInset = true

            local Frame = Instance.new("Frame")
            Frame.Parent = ScreenGui
            Frame.Size = UDim2.new(0, 200, 0, 80)
            Frame.Position = UDim2.new(0, 10, 0, 10)
            Frame.BackgroundTransparency = 1
            Frame.Active = true
            Frame.Draggable = true

            local FPSLabel = Instance.new("TextLabel")
            FPSLabel.Parent = Frame
            FPSLabel.Size = UDim2.new(1, 0, 1, 0)
            FPSLabel.Position = UDim2.new(0, 0, 0, 0)
            FPSLabel.BackgroundTransparency = 1
            FPSLabel.Text = "FPS: 0"
            FPSLabel.TextColor3 = Color3.new(1, 1, 1)
            FPSLabel.Font = Enum.Font.SourceSansBold
            FPSLabel.TextSize = 50
            FPSLabel.TextStrokeTransparency = 0.5
            FPSLabel.TextXAlignment = Enum.TextXAlignment.Center
            FPSLabel.TextYAlignment = Enum.TextYAlignment.Center

            local LastUpdate = tick()
            local FrameCount = 0

            RunService.RenderStepped:Connect(function()
                FrameCount = FrameCount + 1
                if tick() - LastUpdate >= 1 then
                    FPSLabel.Text = "FPS: " .. FrameCount
                    FrameCount = 0
                    LastUpdate = tick()
                end
            end)
        else
            local ScreenGui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChildOfClass("ScreenGui")
            if ScreenGui then
                ScreenGui:Destroy()
            end
        end
    end
})



local section = main:AddSection("auto farm level")



main:AddToggle("", {
    Title = "AutoFarm Level",
    Default = false,
    Callback = function(value)
        _G().AutoFarm = value
        
        if value then
            loadstring(Game:HttpGet("https://raw.githubusercontent.com/Lucasggk/BloxFruits-/blob/main/Farm.Loader.lua", true))()
        end
    end
})
