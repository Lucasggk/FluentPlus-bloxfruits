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
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local LocalPlayer = Players.LocalPlayer

        if value then
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "FPSGui"
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
            local gui = LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("FPSGui")
            if gui then
                gui:Destroy()
            end
        end
    end
})



local section = main:AddSection("auto farm level")



main:AddToggle("", {
    Title = "Auto Farm Level",
    Default = false,
    Callback = function(value)
        _G.AutoFarm = value
        if value then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/BloxFruits-/main/Farm.Loader.lua", true))()
        end
    end
})

-- Carrega as configurações de farm do repositório GitHub
local FarmLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasggk/BloxFruits-/main/Farm.Loader.lua"))()

-- Auto Farm Level Completo
local AutoFarm = Tabs.Main:AddToggle("AutoFarm", {
    Title = "Auto Farm Level (Tudo Automático)",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        _G.FastAttack = Value  -- Ativa fast attack junto
        _G.BringMob = Value    -- Ativa bring mob junto
        
        if Value then
            spawn(function()
                while wait() do
                    if _G.AutoFarm then
                        pcall(function()
                            -- Ativa Haki automaticamente
                            if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
                            end
                            
                            -- Usa as configurações carregadas do GitHub
                            local MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
                            local MonData = FarmLoader.GetMonsterData(MyLevel)
                            
                            Mon = MonData.Mon
                            LevelQuest = MonData.LevelQuest
                            NameQuest = MonData.NameQuest
                            CFrameQuest = MonData.CFrameQuest
                            CFrameMon = MonData.CFrameMon
                            
                            -- Sistema de detecção de quest
                            if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                                StartMagnet = false
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
                            elseif game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible == true then
                                pcall(function()
                                    -- Sistema de combate automático
                                    if game:GetService("Workspace").Enemies:FindFirstChild(Mon) then
                                        for i,v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                            if v.Name == Mon and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                                                repeat task.wait()
                                                    -- Equipa a melhor arma automaticamente
                                                    local maxDamage = 0
                                                    local bestWeapon
                                                    for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                                        if weapon:IsA("Tool") and weapon:FindFirstChild("RemoteFunctionShoot") then
                                                            local damage = weapon:FindFirstChild("Damage") and weapon.Damage.Value or 0
                                                            if damage > maxDamage then
                                                                maxDamage = damage
                                                                bestWeapon = weapon.Name
                                                            end
                                                        end
                                                    end
                                                    if bestWeapon then
                                                        EquipWeapon(bestWeapon)
                                                    end
                                                    
                                                    -- Configurações de combate
                                                    v.HumanoidRootPart.CanCollide = false
                                                    v.Humanoid.WalkSpeed = 0
                                                    v.Head.CanCollide = false
                                                    StartMagnet = true
                                                    PosMon = v.HumanoidRootPart.CFrame
                                                    topos(v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 5))
                                                    
                                                    -- Ataque automático
                                                    game:GetService'VirtualUser':CaptureController()
                                                    game:GetService'VirtualUser':Button1Down(Vector2.new(1280, 672))
                                                    
                                                    -- Fast Attack automático
                                                    if _G.FastAttack then
                                                        require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework).activeController.hitboxMagnitude = 50
                                                        require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework).activeController.timeToNextAttack = 0
                                                        require(game:GetService("Players").LocalPlayer.PlayerScripts.CombatFramework).activeController.increment = 3
                                                    end
                                                    
                                                until not _G.AutoFarm or not v.Parent or v.Humanoid.Health <= 0
                                                StartMagnet = false
                                            end
                                        end
                                    else
                                        -- Teleporta para o local do monstro se não encontrado
                                        StartMagnet = false
                                        if game:GetService("ReplicatedStorage"):FindFirstChild(Mon) then
                                            topos(game:GetService("ReplicatedStorage"):FindFirstChild(Mon).HumanoidRootPart.CFrame * CFrame.new(0, 30, 5))
                                        else
                                            if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 15 then
                                                if PosMon ~= nil then
                                                    topos(PosMon * CFrame.new(0, 30, 5))
                                                end
                                            end
                                        end
                                    end
                                end)
                            end
                        end)
                    end
                end
            end)
        else
            -- Desativa tudo quando desligado
            StopTween()
            StartMagnet = false
        end
    end
})

-- Funções auxiliares
function EquipWeapon(ToolSe)
    if not _G.NotAutoEquip then
        if game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe) then
            local Tool = game.Players.LocalPlayer.Backpack:FindFirstChild(ToolSe)
            wait(.1)
            game.Players.LocalPlayer.Character.Humanoid:EquipTool(Tool)
        end
    end
end

function StopTween()
    if not _G.StopTween then
        _G.StopTween = true
        wait()
        topos(game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame)
        wait()
        if game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
        end
        _G.StopTween = false
        _G.Clip = false
    end
end
