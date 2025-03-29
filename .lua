-- Setup the basic GUI
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui
screenGui.Name = "CustomGUI"
screenGui.Enabled = true  -- Start with the GUI enabled

-- Frame Setup for the GUI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.01, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.Parent = screenGui

-- Camlock Button (Text Label now, not a button)
local camlockLabel = Instance.new("TextLabel")
camlockLabel.Size = UDim2.new(0, 120, 0, 40)
camlockLabel.Position = UDim2.new(0, 10, 0, 10)
camlockLabel.Text = "Camlock Off"
camlockLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
camlockLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
camlockLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
camlockLabel.TextScaled = true
camlockLabel.TextButtonMode = Enum.TextButtonMode.Button
camlockLabel.Parent = mainFrame

-- Toggle GUI Button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 60)
toggleButton.Text = "Toggle GUI"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
toggleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.TextScaled = true
toggleButton.Parent = mainFrame

-- Camlock Settings
local camlockEnabled = false
local targetPlayer = nil
local predictionFactor = 0.5  -- Controls how much to predict movement

-- Toggle Camlock Function
local function toggleCamlock()
    camlockEnabled = not camlockEnabled
    if camlockEnabled then
        camlockLabel.Text = "Camlock On"
    else
        camlockLabel.Text = "Camlock Off"
    end
end

-- Function to handle Camlock with Prediction
local function camlockWithPrediction()
    while camlockEnabled do
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            local targetVelocity = targetPlayer.Character.HumanoidRootPart.Velocity
            -- Simple prediction: target's future position based on velocity
            local predictedPos = targetPos + targetVelocity * predictionFactor
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, predictedPos)
        end
        wait(0.1)
    end
end

-- Keybind for Q to Toggle Camlock
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Q then
        toggleCamlock()
        -- Enable Camlock prediction when Camlock is toggled on
        if camlockEnabled then
            coroutine.wrap(camlockWithPrediction)() -- Start camlock prediction when Camlock is enabled
        end
    end
end)

-- Toggle GUI Visibility when Button is Clicked
toggleButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = not screenGui.Enabled  -- Toggle visibility of the entire GUI
end)

-- Dragging Logic for the Button
local dragging = false
local dragInput
local dragStart
local startPos

camlockLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = camlockLabel.Position
    end
end)

camlockLabel.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        camlockLabel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

camlockLabel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
