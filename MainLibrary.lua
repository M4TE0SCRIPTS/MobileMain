-- [[ Librería de UI para Roblox (Delta Mobile) ]] --
local Library = {}

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

function Library:CreateWindow(config)
    config = config or {}
    local name = config.Name or "Hub"
    local subtitle = config.Subtitle or ""
    local useKey = config.KeySystem or false
    local validKeys = config.Key or {""}

    -- Evitar duplicados
    if CoreGui:FindFirstChild("CustomLibraryGUI") then
        CoreGui.CustomLibraryGUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomLibraryGUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Sistema de Notificaciones
    function Library:Notify(title, message)
        local Banner = Instance.new("Frame")
        Banner.Size = UDim2.new(0, 260, 0, 50)
        Banner.Position = UDim2.new(0.5, -130, 0, -60)
        Banner.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Banner.BorderSizePixel = 0
        Banner.Parent = ScreenGui

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = Banner

        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(0, 255, 128)
        UIStroke.Thickness = 2
        UIStroke.Parent = Banner

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -10, 0, 20)
        TitleLabel.Position = UDim2.new(0, 5, 0, 5)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        TitleLabel.TextSize = 14
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Text = title
        TitleLabel.Parent = Banner

        local MsgLabel = Instance.new("TextLabel")
        MsgLabel.Size = UDim2.new(1, -10, 0, 20)
        MsgLabel.Position = UDim2.new(0, 5, 0, 25)
        MsgLabel.BackgroundTransparency = 1
        MsgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        MsgLabel.TextSize = 12
        MsgLabel.Font = Enum.Font.Gotham
        MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
        MsgLabel.Text = message
        MsgLabel.Parent = Banner

        Banner:TweenPosition(UDim2.new(0.5, -130, 0, 20), "Out", "Back", 0.5, true)
        
        task.delay(3, function()
            Banner:TweenPosition(UDim2.new(0.5, -130, 0, -60), "In", "Quad", 0.5, true)
            task.wait(0.5)
            Banner:Destroy()
        end)
    end

    local mainLoaded = false
    local function loadMainGUI()
        if mainLoaded then return end
        mainLoaded = true

        -- Botón Flotante para Abrir/Cerrar
        local OpenBtn = Instance.new("TextButton")
        OpenBtn.Size = UDim2.new(0, 45, 0, 45)
        OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
        OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        OpenBtn.TextColor3 = Color3.fromRGB(0, 255, 128)
        OpenBtn.TextSize = 12
        OpenBtn.Font = Enum.Font.GothamBold
        OpenBtn.Text = "GUI"
        OpenBtn.Parent = ScreenGui

        local OpenCorner = Instance.new("UICorner")
        OpenCorner.CornerRadius = UDim.new(1, 0)
        OpenCorner.Parent = OpenBtn

        local OpenStroke = Instance.new("UIStroke")
        OpenStroke.Color = Color3.fromRGB(0, 255, 128)
        OpenStroke.Thickness = 2
        OpenStroke.Parent = OpenBtn

        -- Ventana Principal
        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 320, 0, 320)
        MainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
        MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        MainFrame.BorderSizePixel = 0
        MainFrame.ClipsDescendants = true
        MainFrame.Parent = ScreenGui

        local MainCorner = Instance.new("UICorner")
        MainCorner.CornerRadius = UDim.new(0, 12)
        MainCorner.Parent = MainFrame

        local MainStroke = Instance.new("UIStroke")
        MainStroke.Color = Color3.fromRGB(0, 255, 128)
        MainStroke.Thickness = 1.5
        MainStroke.Parent = MainFrame

        -- Header
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -40, 0, 20)
        Title.Position = UDim2.new(0, 10, 0, 5)
        Title.BackgroundTransparency = 1
        Title.TextColor3 = Color3.fromRGB(0, 255, 128)
        Title.TextSize = 14
        Title.Font = Enum.Font.GothamBold
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Text = name
        Title.Parent = MainFrame

        local SubTitleLabel = Instance.new("TextLabel")
        SubTitleLabel.Size = UDim2.new(1, -40, 0, 15)
        SubTitleLabel.Position = UDim2.new(0, 10, 0, 22)
        SubTitleLabel.BackgroundTransparency = 1
        SubTitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        SubTitleLabel.TextSize = 10
        SubTitleLabel.Font = Enum.Font.Gotham
        SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        SubTitleLabel.Text = subtitle
        SubTitleLabel.Parent = MainFrame

        -- Botón Minimizar (-)
        local MinBtn = Instance.new("TextButton")
        MinBtn.Size = UDim2.new(0, 30, 0, 30)
        MinBtn.Position = UDim2.new(1, -35, 0, 5)
        MinBtn.BackgroundTransparency = 1
        MinBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        MinBtn.TextSize = 14
        MinBtn.Font = Enum.Font.GothamBold
        MinBtn.Text = "-"
        MinBtn.Parent = MainFrame

        MinBtn.MouseButton1Click:Connect(function()
            MainFrame.Visible = false
            OpenBtn.Visible = true
        end)

        OpenBtn.MouseButton1Click:Connect(function()
            OpenBtn.Visible = false
            MainFrame.Visible = true
        end)

        -- Contenedor de Pestañas
        local TabButtonsFrame = Instance.new("ScrollingFrame")
        TabButtonsFrame.Size = UDim2.new(1, -20, 0, 30)
        TabButtonsFrame.Position = UDim2.new(0, 10, 0, 42)
        TabButtonsFrame.BackgroundTransparency = 1
        TabButtonsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabButtonsFrame.ScrollBarThickness = 0
        TabButtonsFrame.Parent = MainFrame

        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.FillDirection = Enum.FillDirection.Horizontal
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabListLayout.Padding = UDim.new(0, 5)
        TabListLayout.Parent = TabButtonsFrame

        -- Contenedor de Páginas
        local PagesContainer = Instance.new("Frame")
        PagesContainer.Size = UDim2.new(1, -20, 1, -85)
        PagesContainer.Position = UDim2.new(0, 10, 0, 78)
        PagesContainer.BackgroundTransparency = 1
        PagesContainer.Parent = MainFrame

        local WindowFunctions = {}
        local firstTab = true

        function WindowFunctions:CreateTab(tabName)
            local Tab = {}

            local TabBtn = Instance.new("TextButton")
            TabBtn.Size = UDim2.new(0, 85, 1, 0)
            TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
            TabBtn.TextSize = 11
            TabBtn.Font = Enum.Font.GothamMedium
            TabBtn.Text = tabName
            TabBtn.Parent = TabButtonsFrame

            local TabCorner = Instance.new("UICorner")
            TabCorner.CornerRadius = UDim.new(0, 6)
            TabCorner.Parent = TabBtn

            local TabScroll = Instance.new("ScrollingFrame")
            TabScroll.Size = UDim2.new(1, 0, 1, 0)
            TabScroll.BackgroundTransparency = 1
            TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
            TabScroll.ScrollBarThickness = 3
            TabScroll.Visible = false
            TabScroll.Parent = PagesContainer

            local ScrollLayout = Instance.new("UIListLayout")
            ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ScrollLayout.Padding = UDim.new(0, 6)
            ScrollLayout.Parent = TabScroll

            ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                TabScroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 10)
            end)

            if firstTab then
                firstTab = false
                TabScroll.Visible = true
                TabBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
                TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end

            TabBtn.MouseButton1Click:Connect(function()
                for _, child in pairs(PagesContainer:GetChildren()) do
                    if child:IsA("ScrollingFrame") then child.Visible = false end
                end
                for _, child in pairs(TabButtonsFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        child.TextColor3 = Color3.fromRGB(180, 180, 180)
                    end
                end
                TabScroll.Visible = true
                TabBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
                TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end)

            function Tab:AddToggle(name, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                btn.TextSize = 11
                btn.Font = Enum.Font.GothamMedium
                btn.Text = name .. ": OFF"
                btn.Parent = TabScroll

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = btn

                local active = false
                btn.MouseButton1Click:Connect(function()
                    active = not active
                    if active then
                        btn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
                        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        btn.Text = name .. ": ON"
                    else
                        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
                        btn.Text = name .. ": OFF"
                    end
                    callback(active)
                end)
            end

            function Tab:AddSlider(name, min, max, default, callback)
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 45)
                container.BackgroundTransparency = 1
                container.Parent = TabScroll

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 18)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(200, 200, 200)
                label.TextSize = 11
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Text = "  " .. name .. ": " .. default
                label.Parent = container

                local bgSlider = Instance.new("TextButton")
                bgSlider.Size = UDim2.new(1, 0, 0, 18)
                bgSlider.Position = UDim2.new(0, 0, 0, 20)
                bgSlider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                bgSlider.Text = ""
                bgSlider.Parent = container

                local scCorner = Instance.new("UICorner")
                scCorner.CornerRadius = UDim.new(0, 4)
                scCorner.Parent = bgSlider

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
                fill.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                fill.BorderSizePixel = 0
                fill.Parent = bgSlider

                local fCorner = Instance.new("UICorner")
                fCorner.CornerRadius = UDim.new(0, 4)
                fCorner.Parent = fill

                local dragging = false
                bgSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                        local pos = math.clamp((input.Position.X - bgSlider.AbsolutePosition.X) / bgSlider.AbsoluteSize.X, 0, 1)
                        fill.Size = UDim2.new(pos, 0, 1, 0)
                        local val = math.floor(min + ((max - min) * pos))
                        label.Text = "  " .. name .. ": " .. val
                        callback(val)
                    end
                end)
            end

            function Tab:AddTextBox(placeholder, callback)
                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1, 0, 0, 30)
                box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                box.TextColor3 = Color3.fromRGB(255, 255, 255)
                box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                box.PlaceholderText = placeholder
                box.TextSize = 11
                box.Font = Enum.Font.Gotham
                box.Text = ""
                box.Parent = TabScroll

                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(0, 6)
                corner.Parent = box

                box.FocusLost = function(enterPressed)
                    if enterPressed then
                        callback(box.Text)
                    end
                end
            end

            return Tab
        end

        return WindowFunctions
    end

    if useKey then
        local KeyGui = Instance.new("Frame")
        KeyGui.Size = UDim2.new(0, 260, 0, 160)
        KeyGui.Position = UDim2.new(0.5, -130, 0.5, -80)
        KeyGui.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        KeyGui.Parent = ScreenGui

        local kCorner = Instance.new("UICorner")
        kCorner.CornerRadius = UDim.new(0, 10)
        kCorner.Parent = KeyGui

        local kStroke = Instance.new("UIStroke")
        kStroke.Color = Color3.fromRGB(0, 255, 128)
        kStroke.Thickness = 1.5
        kStroke.Parent = KeyGui

        local kTitle = Instance.new("TextLabel")
        kTitle.Size = UDim2.new(1, 0, 0, 35)
        kTitle.BackgroundTransparency = 1
        kTitle.TextColor3 = Color3.fromRGB(0, 255, 128)
        kTitle.TextSize = 13
        kTitle.Font = Enum.Font.GothamBold
        kTitle.Text = "Key System - " .. name
        kTitle.Parent = KeyGui

        local kBox = Instance.new("TextBox")
        kBox.Size = UDim2.new(0.9, 0, 0, 35)
        kBox.Position = UDim2.new(0.05, 0, 0, 45)
        kBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        kBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        kBox.PlaceholderText = "Ingresa tu key..."
        kBox.TextSize = 12
        kBox.Font = Enum.Font.Gotham
        kBox.Parent = KeyGui

        local bCorner = Instance.new("UICorner")
        bCorner.CornerRadius = UDim.new(0, 6)
        bCorner.Parent = kBox

        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.Size = UDim2.new(0.9, 0, 0, 35)
        SubmitBtn.Position = UDim2.new(0.05, 0, 0, 95)
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
        SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        SubmitBtn.TextSize = 12
        SubmitBtn.Font = Enum.Font.GothamBold
        SubmitBtn.Text = "Comprobar Key"
        SubmitBtn.Parent = KeyGui

        local sCorner = Instance.new("UICorner")
        sCorner.CornerRadius = UDim.new(0, 6)
        sCorner.Parent = SubmitBtn

        SubmitBtn.MouseButton1Click:Connect(function()
            local enteredKey = kBox.Text
            local success = false
            for _, k in pairs(validKeys) do
                if enteredKey == k then
                    success = true
                    break
                end
            end

            if success then
                KeyGui:Destroy()
                loadMainGUI()
            else
                kBox.Text = "Key Incorrecta!"
            end
        end)
    else
        loadMainGUI()
    end

    return Library
end

return Library
