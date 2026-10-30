--[[
    Script: Auto Trade & Freeze Trade para Blox Fruits
    Plataforma: Roblox (Delta Executor)
    Creado desde cero para el reto
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Intentar localizar los RemoteEvents oficiales de Trade en Blox Fruits
local Network = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage:FindFirstChild("Network")
local StartTradeEvent = Network and Network:FindFirstChild("CommF_")

-- Variables de control del Auto Trade
getgenv().AutoTradeConfig = {
    Enabled = false,
    TargetPlayer = "", -- Nombre del usuario con el que deseas tradear
    AutoFreeze = true, -- Congelar automáticamente cuando el otro acepte
    ItemToOffer = ""   -- Nombre de la fruta u objeto que deseas ofrecer (opcional)
}

-- Función para enviar solicitud de trade a un jugador
local function SendTradeRequest(targetName)
    local target = Players:FindFirstChild(targetName)
    if target and StartTradeEvent then
        StartTradeEvent:InvokeServer("RequestTrade", target)
        print("[AutoTrade] Solicitud enviada a: " + targetName)
    else
        warn("[AutoTrade] Jugador no encontrado o Remote no disponible.")
    end
end

-- Función para congelar/asegurar el trade (Freeze Trade)
local function FreezeTrade()
    if StartTradeEvent then
        StartTradeEvent:InvokeServer("LockTrade")
        print("[AutoTrade] Intercambio congelado/asegurado con éxito.")
    end
end

-- Bucle de monitoreo para el Auto Trade y Freeze Trade
task.spawn(function()
    while task.wait(0.5) do
        if getgenv().AutoTradeConfig.Enabled then
            local tradeGui = PlayerGui:FindFirstChild("TradeGui") or PlayerGui:FindFirstChild("Trade")
            
            if tradeGui and tradeGui.Enabled then
                if getgenv().AutoTradeConfig.AutoFreeze then
                    FreezeTrade()
                    task.wait(1)
                end
            end
        end
    end
end)

-- Interfaz gráfica básica (GUI) en pantalla para controlar el script fácilmente desde Delta
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "BloxFruitsTradeGUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 220, 0, 140)
MainFrame.Active = true
MainFrame.Draggable = true

UICorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "Auto Trade - Blox Fruits"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 176, 0, 40)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Auto Trade: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    getgenv().AutoTradeConfig.Enabled = not getgenv().AutoTradeConfig.Enabled
    
    if getgenv().AutoTradeConfig.Enabled then
        ToggleButton.Text = "Auto Trade: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    else
        ToggleButton.Text = "Auto Trade: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

print("[Script Cargado] Interfaz y sistema de Auto Trade listos.")
