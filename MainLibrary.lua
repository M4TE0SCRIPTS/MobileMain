local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local MiLib = {}
MiLib.Temas = {
	Oscuro = {Fondo = Color3.fromRGB(25, 25, 25), Pestaña = Color3.fromRGB(35, 35, 35), Elemento = Color3.fromRGB(45, 45, 45), Texto = Color3.fromRGB(255, 255, 255), Acento = Color3.fromRGB(0, 170, 255)},
	Azul = {Fondo = Color3.fromRGB(15, 25, 40), Pestaña = Color3.fromRGB(25, 40, 65), Elemento = Color3.fromRGB(35, 55, 85), Texto = Color3.fromRGB(240, 240, 255), Acento = Color3.fromRGB(0, 195, 255)},
	Morado = {Fondo = Color3.fromRGB(25, 15, 35), Pestaña = Color3.fromRGB(40, 25, 55), Elemento = Color3.fromRGB(55, 35, 75), Texto = Color3.fromRGB(255, 240, 255), Acento = Color3.fromRGB(170, 0, 255)},
	Rojo = {Fondo = Color3.fromRGB(30, 15, 15), Pestaña = Color3.fromRGB(50, 25, 25), Elemento = Color3.fromRGB(70, 35, 35), Texto = Color3.fromRGB(255, 240, 240), Acento = Color3.fromRGB(255, 50, 50)}
}

-- Función auxiliar para arrastrar elementos limitando a la pantalla
local function HacerDragableYLimitado(gui, zonaArrastre)
	zonaArrastre = zonaArrastre or gui
	local dragging, dragInput, dragStart, startPos

	local function UpdateInput(input)
		local delta = input.Position - dragStart
		local nuevaPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		
		-- Limitar dentro de la pantalla
		local camera = workspace.CurrentCamera
		if camera then
			local viewportSize = camera.ViewportSize
			local guiSize = gui.AbsoluteSize
			local xMin, xMax = 0, viewportSize.X - guiSize.X
			local yMin, yMax = 0, viewportSize.Y - guiSize.Y

			local posXClamped = math.clamp(startPos.X.Offset + delta.X, xMin, xMax)
			local posYClamped = math.clamp(startPos.Y.Offset + delta.Y, yMin, yMax)
			nuevaPos = UDim2.new(0, posXClamped, 0, posYClamped)
		end

		gui.Position = nuevaPos
	end

	zonaArrastre.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	zonaArrastre.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			UpdateInput(input)
		end
	end)
end

function MiLib:CrearWindow(config)
	config = config or {}
	local tituloText = config.Nombre or "MiLib"
	local subtituloText = config.Subtitulo or "Por Usuario"
	local tema = MiLib.Temas[config.Tema] or MiLib.Temas.Oscuro
	local botonRgb = config.BotonRGB or false

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MiLibUI"
	ScreenGui.ResetOnSpawn = false

	if gethui then ScreenGui.Parent = gethui()
	elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui); ScreenGui.Parent = game.CoreGui
	else ScreenGui.Parent = game:GetService("CoreGui") end

	-- Marco Principal (Gui Chica)
	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.new(0, 420, 0, 280)
	MainFrame.Position = UDim2.new(0.5, -210, 0.5, -140)
	MainFrame.BackgroundColor3 = tema.Fondo
	MainFrame.BorderSizePixel = 0
	MainFrame.Active = true
	MainFrame.ClipsDescendants = true
	MainFrame.Parent = ScreenGui

	local UICorner = Instance.new("UICorner", MainFrame)
	UICorner.CornerRadius = UDim.new(0, 8)

	HacerDragableYLimitado(MainFrame, MainFrame)

	-- Animación de apertura
	MainFrame.Size = UDim2.new(0, 0, 0, 0)
	TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 420, 0, 280)
	}):Play()

	-- Título y Subtítulo
	local Header = Instance.new("Frame", MainFrame)
	Header.Size = UDim2.new(1, 0, 0, 45)
	Header.BackgroundTransparency = 1

	local Title = Instance.new("TextLabel", Header)
	Title.Size = UDim2.new(1, -90, 0, 20)
	Title.Position = UDim2.new(0, 12, 0, 6)
	Title.BackgroundTransparency = 1
	Title.Text = tituloText
	Title.TextColor3 = tema.Texto
	Title.TextSize = 15
	Title.Font = Enum.Font.SourceSansBold
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Subtitle = Instance.new("TextLabel", Header)
	Subtitle.Size = UDim2.new(1, -90, 0, 15)
	Subtitle.Position = UDim2.new(0, 12, 0, 24)
	Subtitle.BackgroundTransparency = 1
	Subtitle.Text = subtituloText
	Subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
	Subtitle.TextSize = 12
	Subtitle.Font = Enum.Font.SourceSans
	Subtitle.TextXAlignment = Enum.TextXAlignment.Left

	-- Botones de Control (Minimizar y Cerrar)
	local ControlHolder = Instance.new("Frame", Header)
	ControlHolder.Size = UDim2.new(0, 60, 0, 25)
	ControlHolder.Position = UDim2.new(1, -65, 0, 8)
	ControlHolder.BackgroundTransparency = 1

	local MinimizeBtn = Instance.new("TextButton", ControlHolder)
	MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
	MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
	MinimizeBtn.BackgroundColor3 = tema.Pestaña
	MinimizeBtn.Text = "-"
	MinimizeBtn.TextColor3 = tema.Texto
	MinimizeBtn.TextSize = 16
	MinimizeBtn.Font = Enum.Font.SourceSansBold
	local MinCorner = Instance.new("UICorner", MinimizeBtn)
	MinCorner.CornerRadius = UDim.new(0, 4)

	local CloseBtn = Instance.new("TextButton", ControlHolder)
	CloseBtn.Size = UDim2.new(0, 24, 0, 24)
	CloseBtn.Position = UDim2.new(0, 30, 0, 0)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	CloseBtn.Text = "X"
	CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	CloseBtn.TextSize = 12
	CloseBtn.Font = Enum.Font.SourceSansBold
	local CloseCorner = Instance.new("UICorner", CloseBtn)
	CloseCorner.CornerRadius = UDim.new(0, 4)

	-- Botón Flotante para reabrir (UI Chica, Dragable, Limitable, RGB)
	local OpenBtn = Instance.new("TextButton", ScreenGui)
	OpenBtn.Name = "OpenUI_Button"
	OpenBtn.Size = UDim2.new(0, 45, 0, 45)
	OpenBtn.Position = UDim2.new(0, 15, 0.5, -22)
	OpenBtn.BackgroundColor3 = tema.Fondo
	OpenBtn.Text = "UI"
	OpenBtn.TextColor3 = tema.Texto
	OpenBtn.TextSize = 16
	OpenBtn.Font = Enum.Font.SourceSansBold
	OpenBtn.Visible = false
	OpenBtn.Active = true

	local OpenBtnCorner = Instance.new("UICorner", OpenBtn)
	OpenBtnCorner.CornerRadius = UDim.new(1, 0)

	local OpenBtnStroke = Instance.new("UIStroke", OpenBtn)
	OpenBtnStroke.Thickness = 2
	OpenBtnStroke.Color = tema.Acento

	HacerDragableYLimitado(OpenBtn, OpenBtn)

	-- Efecto RGB para el botón flotante (Opcional)
	local rgbConnection
	if botonRgb then
		rgbConnection = RunService.RenderStepped:Connect(function()
			local hue = (tick() % 3) / 3
			OpenBtnStroke.Color = Color3.fromHSV(hue, 0.8, 1)
		end)
	end

	-- Lógica de Minimizar y Reabrir
	MinimizeBtn.MouseButton1Click:Connect(function()
		local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		})
		tw:Play()
		tw.Completed:Connect(function()
			MainFrame.Visible = false
			OpenBtn.Visible = true
		end)
	end)

	OpenBtn.MouseButton1Click:Connect(function()
		OpenBtn.Visible = false
		MainFrame.Visible = true
		TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 420, 0, 280)
		}):Play()
	end)

	-- Lógica de Eliminar GUI
	CloseBtn.MouseButton1Click:Connect(function()
		local tw = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0)
		})
		tw:Play()
		tw.Completed:Connect(function()
			if rgbConnection then rgbConnection:Disconnect() end
			ScreenGui:Destroy()
		end)
	end)

	-- Contenedor de Pestañas (Izquierda)
	local TabHolder = Instance.new("ScrollingFrame", MainFrame)
	TabHolder.Size = UDim2.new(0, 110, 1, -90)
	TabHolder.Position = UDim2.new(0, 10, 0, 45)
	TabHolder.BackgroundTransparency = 1
	TabHolder.ScrollBarThickness = 2

	local TabList = Instance.new("UIListLayout", TabHolder)
	TabList.Padding = UDim.new(0, 5)

	-- Contenedor de Páginas (Derecha)
	local PageHolder = Instance.new("Frame", MainFrame)
	PageHolder.Size = UDim2.new(1, -140, 1, -55)
	PageHolder.Position = UDim2.new(0, 130, 0, 45)
	PageHolder.BackgroundTransparency = 1

	-- Perfil de Usuario (Abajo a la izquierda)
	local UserProfile = Instance.new("Frame", MainFrame)
	UserProfile.Size = UDim2.new(0, 110, 0, 35)
	UserProfile.Position = UDim2.new(0, 10, 1, -40)
	UserProfile.BackgroundColor3 = tema.Pestaña

	local ProfileCorner = Instance.new("UICorner", UserProfile)
	ProfileCorner.CornerRadius = UDim.new(0, 6)

	local ProfileImage = Instance.new("ImageLabel", UserProfile)
	ProfileImage.Size = UDim2.new(0, 25, 0, 25)
	ProfileImage.Position = UDim2.new(0, 5, 0.5, -12)
	ProfileImage.BackgroundTransparency = 1

	local ImgCorner = Instance.new("UICorner", ProfileImage)
	ImgCorner.CornerRadius = UDim.new(1, 0)

	pcall(function()
		local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		ProfileImage.Image = content
	end)

	local UserName = Instance.new("TextLabel", UserProfile)
	UserName.Size = UDim2.new(1, -35, 1, 0)
	UserName.Position = UDim2.new(0, 33, 0, 0)
	UserName.BackgroundTransparency = 1
	UserName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
	UserName.TextColor3 = tema.Texto
	UserName.TextSize = 11
	UserName.Font = Enum.Font.SourceSansBold
	UserName.TextXAlignment = Enum.TextXAlignment.Left
	UserName.TextTruncate = Enum.TextTruncate.AtEnd

	-- Contenedor de Notificaciones
	local NotifHolder = Instance.new("Frame", ScreenGui)
	NotifHolder.Size = UDim2.new(0, 200, 1, 0)
	NotifHolder.Position = UDim2.new(1, -210, 0, 10)
	NotifHolder.BackgroundTransparency = 1

	local NotifList = Instance.new("UIListLayout", NotifHolder)
	NotifList.Padding = UDim.new(0, 8)
	NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom

	local WindowObj = {Pestañas = {}, PestañaActiva = nil}

	function WindowObj:Notificacion(titulo, mensaje, tiempo)
		tiempo = tiempo or 3
		local NotifFrame = Instance.new("Frame", NotifHolder)
		NotifFrame.Size = UDim2.new(1, 0, 0, 50)
		NotifFrame.BackgroundColor3 = tema.Elemento
		NotifFrame.Position = UDim2.new(1, 200, 0, 0)

		local NCorner = Instance.new("UICorner", NotifFrame)
		NCorner.CornerRadius = UDim.new(0, 6)

		local NTitle = Instance.new("TextLabel", NotifFrame)
		NTitle.Size = UDim2.new(1, -10, 0, 20)
		NTitle.Position = UDim2.new(0, 8, 0, 4)
		NTitle.BackgroundTransparency = 1
		NTitle.Text = titulo
		NTitle.TextColor3 = tema.Acento
		NTitle.TextSize = 13
		NTitle.Font = Enum.Font.SourceSansBold
		NTitle.TextXAlignment = Enum.TextXAlignment.Left

		local NMsg = Instance.new("TextLabel", NotifFrame)
		NMsg.Size = UDim2.new(1, -10, 0, 20)
		NMsg.Position = UDim2.new(0, 8, 0, 22)
		NMsg.BackgroundTransparency = 1
		NMsg.Text = mensaje
		NMsg.TextColor3 = tema.Texto
		NMsg.TextSize = 12
		NMsg.Font = Enum.Font.SourceSans
		NMsg.TextXAlignment = Enum.TextXAlignment.Left

		TweenService:Create(NotifFrame, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, 0)}):Play()
		task.delay(tiempo, function()
			local tw = TweenService:Create(NotifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1.5, 0, 0, 0)})
			tw:Play()
			tw.Completed:Connect(function() NotifFrame:Destroy() end)
		end)
	end

	function WindowObj:CrearTab(nombre)
		local TabBtn = Instance.new("TextButton", TabHolder)
		TabBtn.Size = UDim2.new(1, 0, 0, 28)
		TabBtn.BackgroundColor3 = tema.Pestaña
		TabBtn.Text = nombre
		TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
		TabBtn.TextSize = 12
		TabBtn.Font = Enum.Font.SourceSansBold

		local TCorner = Instance.new("UICorner", TabBtn)
		TCorner.CornerRadius = UDim.new(0, 5)

		local Page = Instance.new("ScrollingFrame", PageHolder)
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.Visible = false
		Page.ScrollBarThickness = 3

		local PageList = Instance.new("UIListLayout", Page)
		PageList.Padding = UDim.new(0, 6)

		TabBtn.MouseButton1Click:Connect(function()
			for _, tab in pairs(WindowObj.Pestañas) do
				tab.Page.Visible = false
				TweenService:Create(tab.Btn, TweenInfo.new(0.2), {BackgroundColor3 = tema.Pestaña, TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
			end
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = tema.Acento, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end)

		if not WindowObj.PestañaActiva then
			WindowObj.PestañaActiva = Page
			Page.Visible = true
			TabBtn.BackgroundColor3 = tema.Acento
			TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		end

		local TabObj = {Page = Page, Btn = TabBtn}
		table.insert(WindowObj.Pestañas, TabObj)

		function TabObj:CrearBoton(texto, callback)
			local Btn = Instance.new("TextButton", Page)
			Btn.Size = UDim2.new(1, -5, 0, 30)
			Btn.BackgroundColor3 = tema.Elemento
			Btn.Text = texto
			Btn.TextColor3 = tema.Texto
			Btn.TextSize = 13
			Btn.Font = Enum.Font.SourceSans

			local BCorner = Instance.new("UICorner", Btn)
			BCorner.CornerRadius = UDim.new(0, 5)

			Btn.MouseButton1Click:Connect(function()
				TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 28)}):Play()
				task.wait(0.1)
				TweenService:Create(Btn, TweenInfo.new(0.1), {Size = UDim2.new(1, -5, 0, 30)}):Play()
				if callback then callback() end
			end)
		end

		function TabObj:CrearToggle(texto, callback)
			local estado = false
			local ToggleBtn = Instance.new("TextButton", Page)
			ToggleBtn.Size = UDim2.new(1, -5, 0, 30)
			ToggleBtn.BackgroundColor3 = tema.Elemento
			ToggleBtn.Text = "  " .. texto
			ToggleBtn.TextColor3 = tema.Texto
			ToggleBtn.TextSize = 13
			ToggleBtn.Font = Enum.Font.SourceSans
			ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

			local TCorner = Instance.new("UICorner", ToggleBtn)
			TCorner.CornerRadius = UDim.new(0, 5)

			local Indicator = Instance.new("Frame", ToggleBtn)
			Indicator.Size = UDim2.new(0, 16, 0, 16)
			Indicator.Position = UDim2.new(1, -22, 0.5, -8)
			Indicator.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

			local ICorner = Instance.new("UICorner", Indicator)
			ICorner.CornerRadius = UDim.new(0, 4)

			ToggleBtn.MouseButton1Click:Connect(function()
				estado = not estado
				local colorObj = estado and tema.Acento or Color3.fromRGB(80, 80, 80)
				TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = colorObj}):Play()
				if callback then callback(estado) end
			end)
		end

		function TabObj:CrearSlider(texto, min, max, defecto, callback)
			defecto = defecto or min
			local Frame = Instance.new("Frame", Page)
			Frame.Size = UDim2.new(1, -5, 0, 40)
			Frame.BackgroundColor3 = tema.Elemento

			local FCorner = Instance.new("UICorner", Frame)
			FCorner.CornerRadius = UDim.new(0, 5)

			local Label = Instance.new("TextLabel", Frame)
			Label.Size = UDim2.new(1, -10, 0, 18)
			Label.Position = UDim2.new(0, 8, 0, 2)
			Label.BackgroundTransparency = 1
			Label.Text = texto .. ": " .. tostring(defecto)
			Label.TextColor3 = tema.Texto
			Label.TextSize = 12
			Label.Font = Enum.Font.SourceSans
			Label.TextXAlignment = Enum.TextXAlignment.Left

			local SliderBar = Instance.new("Frame", Frame)
			SliderBar.Size = UDim2.new(1, -16, 0, 6)
			SliderBar.Position = UDim2.new(0, 8, 0, 24)
			SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

			local SCorner = Instance.new("UICorner", SliderBar)
			SCorner.CornerRadius = UDim.new(1, 0)

			local Fill = Instance.new("Frame", SliderBar)
			Fill.Size = UDim2.new((defecto - min) / (max - min), 0, 1, 0)
			Fill.BackgroundColor3 = tema.Acento

			local FillCorner = Instance.new("UICorner", Fill)
			FillCorner.CornerRadius = UDim.new(1, 0)

			local arrastrando = false

			local function Actualizar(input)
				local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
				local valor = math.floor(min + ((max - min) * pos))
				Fill.Size = UDim2.new(pos, 0, 1, 0)
				Label.Text = texto .. ": " .. tostring(valor)
				if callback then callback(valor) end
			end

			SliderBar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					arrastrando = true
					Actualizar(input)
				end
			end)

			UserInputService.InputChanged:Connect(function(input)
				if arrastrando and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					Actualizar(input)
				end
			end)

			UserInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					arrastrando = false
				end
			end)
		end

		return TabObj
	end

	return WindowObj
end

return MiLib
