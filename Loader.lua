player.Namelocal Fluent = loadstring(Game:HttpGet("https://raw.githubusercontent.com/discoart/FluentPlus/refs/heads/main/release.lua", true))()
 
local Window = Fluent:CreateWindow({
    Title = "Blox fruits",
    SubTitle = "Feito por Lucas",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark"
})

local main = Window:AddTab({ Title = "monitor pvp", Icon = "home" })
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


local playerParagraphs = {}
local MyLevel = 0
local DIFERENCA_LEVEL = 700

local function getPlayerLevel(player)

    if player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") then
        return player.Data.Level.Value
    end
    

    if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") then
        return player.leaderstats.Level.Value
    end
    

    if player:FindFirstChild("Stats") and player.Stats:FindFirstChild("Level") then
        return player.Stats.Level.Value
    end
    
    return 0 
end


local function atualizarMeuLevel()
    local player = Players.LocalPlayer
    

    if player:FindFirstChild("Data") and player.Data:FindFirstChild("Level") then
        MyLevel = player.Data.Level.Value
        return
    end
    

    if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Level") then
        MyLevel = player.leaderstats.Level.Value
        return
    end
    
    
    if player:FindFirstChild("Stats") and player.Stats:FindFirstChild("Level") then
        MyLevel = player.Stats.Level.Value
        return
    end
    
    MyLevel = 0 
end


local function possoMatar(levelAlvo)
    local diferenca = math.abs(MyLevel - levelAlvo)
    return diferenca <= DIFERENCA_LEVEL
end


local function atualizarJogadores()
    atualizarMeuLevel() 
    
    
    local outrosJogadores = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            table.insert(outrosJogadores, player)
        end
    end
    
    
    for nome, paragraph in pairs(playerParagraphs) do
        local aindaExiste = false
        for _, player in ipairs(outrosJogadores) do
            if player.Name == nome then
                aindaExiste = true
                break
            end
        end
        
        if not aindaExiste then
            paragraph:Remove()
            playerParagraphs[nome] = nil
        end
    end
    

    for _, player in ipairs(outrosJogadores) do
        local level = getPlayerLevel(player)
        local podeMatar = possoMatar(level)
        local status = podeMatar and "✅ Pode matar" or "❌ Não pode matar"
        local diferenca = MyLevel - level
        
        local textoDiferenca
        if diferenca > 0 then
            textoDiferenca = string.format("(%d níveis abaixo de você)", math.abs(diferenca))
        elseif diferenca < 0 then
            textoDiferenca = string.format("(%d níveis acima de você)", math.abs(diferenca))
        else
            textoDiferenca = "(mesmo nível que você)"
        end
        
        if playerParagraphs[player.Name] then
            
            playerParagraphs[player.Name]:SetDesc(string.format(
                "Level: %d %s\n%s",
                level,
                textoDiferenca,
                status
            ))
        else
            
            playerParagraphs[player.Name] = Tabs.Main:AddParagraph({
                Title = player.Name,
                Content = string.format(
                    "Level: %d %s\n%s",
                    level,
                    textoDiferenca,
                    status
                )
            })
        end
    end
    
    
    if #outrosJogadores == 0 then
        if not playerParagraphs["SemJogadores"] then
            playerParagraphs["SemJogadores"] = Tabs.Main:AddParagraph({
                Title = "Servidor vazio",
                Content = "Não há outros jogadores no servidor."
            })
        end
    else
        if playerParagraphs["SemJogadores"] then
            playerParagraphs["SemJogadores"]:Remove()
            playerParagraphs["SemJogadores"] = nil
        end
    end
end


while true do
    atualizarJogadores()
    wait(2)
end
