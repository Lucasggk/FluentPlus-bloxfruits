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
local config = Window:AddTab({ Title = "configurações", Icon = "Setting" })


