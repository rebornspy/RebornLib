--[[
    Phoenix Interface Suite
    by reborb (@rebornspy)
    
    Credits:
        SCRIPTING       |   @rebornspy
        DESIGN          |   @rebornspy
        DOCUMENTATION   |   @rebornspy
		EVERYTHING ELSE |   @rebornspy
    (yes this is a solo dev project)
]]

local Phoenix = {}
Phoenix.__index = Phoenix

--// Hot Reload
do
	local ok, g = pcall(getgenv)
	if ok and type(g) == "table" then
		if g.Phoenix_ExecGui and g.Phoenix_ExecGui.Parent then
			pcall(function()
				g.Phoenix_ExecGui:Destroy()
			end)
		end
	end
end

--// Useful Services
local EncodingService = game:GetService("EncodingService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--// Unlock Mouse once camera exists
UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
UIS.MouseIconEnabled = false

task.spawn(function()
	repeat
		task.wait()
	until workspace.CurrentCamera
	task.wait(0.15)

	UIS.MouseBehavior = Enum.MouseBehavior.Default
	UIS.MouseIconEnabled = true
end)

--// Themes
Phoenix.Themes = {
	Default = {
		Background = Color3.fromRGB(15, 15, 18),
		Panel = Color3.fromRGB(22, 22, 26),
		Section = Color3.fromRGB(28, 28, 34),
		BootBackground = Color3.fromRGB(35, 35, 40),
		Text = Color3.fromRGB(235, 235, 240),
		SubtitleText = Color3.fromRGB(180, 180, 190),
		GradientHover = Color3.fromRGB(255, 255, 255),
		ButtonHover = Color3.fromRGB(60, 60, 80),

		Accent = Color3.fromRGB(125, 10, 10),
		AccentHover = Color3.fromRGB(160, 20, 20),
		AccentGlow = Color3.fromRGB(200, 40, 40),

		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(125, 10, 10)),
			ColorSequenceKeypoint.new(0.75, Color3.fromRGB(22, 22, 26)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 26)),
		}),

		Font = Enum.Font.Ubuntu,
		CornerRadius = 10,
	},
	["Blood Moon"] = {
		Background = Color3.fromRGB(20, 10, 10),
		Panel = Color3.fromRGB(30, 20, 20),
		Section = Color3.fromRGB(40, 20, 20),
		BootBackground = Color3.fromRGB(60, 20, 20),
		Text = Color3.fromRGB(255, 230, 230),
		SubtitleText = Color3.fromRGB(210, 190, 190),
		GradientHover = Color3.fromRGB(255, 255, 255),
		ButtonHover = Color3.fromRGB(80, 30, 30),

		Accent = Color3.fromRGB(100, 10, 10),
		AccentHover = Color3.fromRGB(125, 20, 20),
		AccentGlow = Color3.fromRGB(160, 40, 40),

		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 20)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 10, 10)),
		}),

		Font = Enum.Font.Ubuntu,
		CornerRadius = 10,
	},
	["Acid Trip"] = {
		Background = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		Panel = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		Section = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		BootBackground = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		Text = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		SubtitleText = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		GradientHover = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		ButtonHover = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),

		Accent = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		AccentHover = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),
		AccentGlow = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255)),

		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))),
		}),

		Font = Enum.Font.Ubuntu,
		CornerRadius = 10,
	},
	["Cerulean Wave"] = { -- CREATORS FAVORITE
		Background = Color3.fromRGB(20, 25, 35),
		Panel = Color3.fromRGB(20, 25, 40),
		Section = Color3.fromRGB(20, 30, 50),
		BootBackground = Color3.fromRGB(30, 35, 60),
		Text = Color3.fromRGB(170, 220, 250),
		SubtitleText = Color3.fromRGB(170, 200, 230),
		GradientHover = Color3.fromRGB(255, 255, 255),
		ButtonHover = Color3.fromRGB(20, 40, 100),

		Accent = Color3.fromRGB(20, 70, 170),
		AccentHover = Color3.fromRGB(20, 100, 200),
		AccentGlow = Color3.fromRGB(30, 155, 255),

		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 40)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 40, 100)),
		}),

		Font = Enum.Font.Ubuntu,
		CornerRadius = 10,
	},
	["Deep Forest"] = {
		Background = Color3.fromRGB(20, 35, 25),
		Panel = Color3.fromRGB(25, 45, 30),
		Section = Color3.fromRGB(30, 50, 35),
		BootBackground = Color3.fromRGB(30, 60, 35),
		Text = Color3.fromRGB(200, 255, 200),
		SubtitleText = Color3.fromRGB(180, 255, 180),
		GradientHover = Color3.fromRGB(255, 255, 255),
		ButtonHover = Color3.fromRGB(30, 80, 45),

		Accent = Color3.fromRGB(20, 170, 70),
		AccentHover = Color3.fromRGB(20, 190, 90),
		AccentGlow = Color3.fromRGB(30, 210, 90),

		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 40, 10)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 100, 40)),
		}),

		Font = Enum.Font.Ubuntu,
		CornerRadius = 10,
	},
	["Monochrome"] = {
		Background = Color3.fromRGB(20, 20, 20),
		Panel = Color3.fromRGB(30, 30, 30),
		Section = Color3.fromRGB(40, 40, 40),
		BootBackground = Color3.fromRGB(50, 50, 50),
		Text = Color3.fromRGB(200, 200, 200),
		SubtitleText = Color3.fromRGB(180, 180, 180),
		GradientHover = Color3.fromRGB(255, 255, 255),
		ButtonHover = Color3.fromRGB(50, 50, 50),

		Accent = Color3.fromRGB(170, 170, 170),
		AccentHover = Color3.fromRGB(190, 190, 190),
		AccentGlow = Color3.fromRGB(210, 210, 210),

		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20)),
		}),

		Font = Enum.Font.Ubuntu,
		CornerRadius = 10,
	},
	["Red Stained Glass"] = {
		Background = Color3.fromRGB(30, 20, 20),
		Panel = Color3.fromRGB(40, 30, 30),
		Section = Color3.fromRGB(50, 35, 35),
		BootBackground = Color3.fromRGB(60, 40, 40),
		Text = Color3.fromRGB(255, 200, 200),
		SubtitleText = Color3.fromRGB(255, 180, 180),
		GradientHover = Color3.fromRGB(255, 100, 100),
		ButtonHover = Color3.fromRGB(80, 30, 30),

		Accent = Color3.fromRGB(255, 50, 50),
		AccentHover = Color3.fromRGB(255, 70, 70),
		AccentGlow = Color3.fromRGB(255, 100, 100),

		Gradient = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 20, 20)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 40, 40)),
		}),

		Font = Enum.Font.Ubuntu,
		CornerRadius = 10,
	},
}

--// Utility: Rounded Corners
local function addCorner(instance, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = instance
	return c
end

--// Utility: Draggable Topbar
local function makeDraggable(topbar, window)
	local dragging = false
	local dragStart
	local startPos

	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = window.Position
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			window.Position =
				UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

--// Utility: Simple Tweening
local function tween(obj, time, props)
	TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

--// Safe Parenting
local function getSafeParent()
	local ok, ui = pcall(gethui)
	if ok and typeof(ui) == "Instance" then
		return ui
	end

	local core = game:FindFirstChildOfClass("CoreGui")
	if core then
		return core
	end

	return nil
end

local function createScreenGui()
	local gui = Instance.new("ScreenGui")
	gui.Name = "Phoenix"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

	local parent = getSafeParent()
	if parent then
		gui.Parent = parent
	end

	-- store for hot reload
	local ok, g = pcall(getgenv)
	if ok and type(g) == "table" then
		g.Phoenix_ExecGui = gui
	end

	return gui
end

--// Keycode Normalizer
local function normalizeKey(key)
	if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
		return key
	end

	if typeof(key) == "string" then
		local upper = key:upper()
		if Enum.KeyCode[upper] then
			return Enum.KeyCode[upper]
		end
	end

	if typeof(key) == "number" then
		return Enum.KeyCode[key]
	end

	return Enum.KeyCode.K
end

--// Objects
local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

----------------------------------------------------------------
-- WINDOW CREATION
----------------------------------------------------------------

function Phoenix:CreateWindow(config)
	if not isfolder("Phoenix") then
		makefolder("Phoenix")
	end

	config = config or {}
	local self = setmetatable({}, Window)
	local window = self

	self.Name = config.Name
	self.BootTitle = config.BootTitle or self.Name
	self.MainTitle = config.MainTitle or self.Name
	self.BackButton = (config.BackButton ~= false)

	local themeName = config.Theme or "Default"
	self.Theme = Phoenix.Themes[themeName] or Phoenix.Themes.Default
	local Theme = self.Theme

	-- Loading screen
	local loadingFrame = Instance.new("Frame")
	loadingFrame.Name = "LoadingScreen"
	loadingFrame.Size = UDim2.new(0, 380, 0, 260)
	loadingFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
	loadingFrame.BorderSizePixel = 0
	loadingFrame.ZIndex = 50
	loadingFrame.Parent = self._gui
	addCorner(loadingFrame, Theme.CornerRadius)

	local loadingGradient = Instance.new("UIGradient")
	loadingGradient.Color = Theme.Gradient
	loadingGradient.Rotation = 55
	loadingGradient.Parent = loadingFrame

	-- Spinner
	local spinner = Instance.new("ImageLabel")
	spinner.Name = "Spinner"
	spinner.AnchorPoint = Vector2.new(0.5, 0.5)
	spinner.Position = UDim2.new(0.5, 0, 0.35, 0)
	spinner.Size = UDim2.new(0, 40, 0, 40)
	spinner.BackgroundTransparency = 1
	spinner.Image = "rbxassetid://3926305904"
	spinner.ImageRectOffset = Vector2.new(120, 680)
	spinner.ImageRectSize = Vector2.new(44, 44)
	spinner.ZIndex = 51
	spinner.Parent = loadingFrame

	-- Progress bar background
	local barBG = Instance.new("Frame")
	barBG.Name = "ProgressBG"
	barBG.Size = UDim2.new(0.8, 0, 0, 10)
	barBG.Position = UDim2.new(0.1, 0, 0.55, 0)
	barBG.BackgroundColor3 = Theme.Background
	barBG.BorderSizePixel = 0
	barBG.ZIndex = 51
	barBG.Parent = loadingFrame
	addCorner(barBG, 6)

	-- Progress bar fill
	local barFill = Instance.new("Frame")
	barFill.Name = "ProgressFill"
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = Theme.Accent
	barFill.BorderSizePixel = 0
	barFill.ZIndex = 52
	barFill.Parent = barBG
	addCorner(barFill, 6)

	-- Subtitle
	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.AnchorPoint = Vector2.new(0.5, 0)
	subtitle.Position = UDim2.new(0.5, 0, 0.65, 0)
	subtitle.Size = UDim2.new(0.9, 0, 0, 20)
	subtitle.BackgroundTransparency = 1
	subtitle.Font = Theme.Font
	subtitle.Text = config.LoadingText
	subtitle.TextColor3 = Theme.Text
	subtitle.TextSize = 14
	subtitle.ZIndex = 51
	subtitle.Parent = loadingFrame

	window._toggleKey = normalizeKey(config.ToggleUiKey or "K")
	window._isBindingKey = false

	function window:SetToggleKey(key)
		window._toggleKey = normalizeKey(key)
	end

	UIS.InputBegan:Connect(function(input, gp)
		if gp then
			return
		end
		if window._isBindingKey then
			return
		end

		if input.KeyCode == window._toggleKey then
			window:ToggleUI()
		end
	end)

	function Window:_loadConfig()
		local path = "Phoenix/" .. (config.ConfigSavePath or self.Name) .. ".json"
		self._configPath = path

		if not isfile(path) then
			self._config = {}
			return
		end

		local ok, data = pcall(function()
			return HttpService:JSONDecode(readfile(path))
		end)

		self._config = ok and data or {}
	end

	function Window:_saveConfig()
		writefile(self._configPath, HttpService:JSONEncode(self._config))
	end

	function Window:GetConfigValue(key, default)
		local cfg = self._config[key]
		return cfg ~= nil and cfg or default
	end

	function Window:SetConfigValue(key, value)
		self._config[key] = value
		self:_saveConfig()
	end

	function Window:ExportConfig(path)
		path = path or self._configPath
		writefile(path, HttpService:JSONEncode(self._config))

		self:Notify({
			Title = "Config Exported",
			Content = "Saved to " .. path,
			Duration = 3,
		})
	end

	function Window:ImportConfig(path)
		if not isfile(path) then
			return self:Notify({
				Title = "Import Failed",
				Content = "File does not exist.",
				Duration = 3,
			})
		end

		local raw = readfile(path)
		local ok, data = pcall(function()
			return HttpService:JSONDecode(raw)
		end)

		if not ok then
			return self:Notify({
				Title = "Import Failed",
				Content = "Invalid JSON file.",
				Duration = 3,
			})
		end

		-- Replace config
		self._config = data
		self:_saveConfig()

		-- Apply values to all components
		for _, apply in ipairs(self._configCallbacks) do
			apply(data)
		end

		self:Notify({
			Title = "Config Imported",
			Content = "Config applied successfully.",
			Duration = 3,
		})

		return true
	end

	self._tabs = {}
	self._activeTab = nil

	self._configCallbacks = {}

	self:_loadConfig()
	self._gui = createScreenGui()

	------------------------------------------------
	-- Notification Holder
	------------------------------------------------
	local notificationHolder = Instance.new("Frame")
	notificationHolder.Name = "NotificationHolder"
	notificationHolder.Parent = self._gui
	notificationHolder.AnchorPoint = Vector2.new(1, 1)
	notificationHolder.Position = UDim2.new(1, -20, 1, -20)
	notificationHolder.Size = UDim2.new(0, 300, 1, -20)
	notificationHolder.BackgroundTransparency = 1
	notificationHolder.ZIndex = 999999

	self._notificationHolder = notificationHolder

	------------------------------------------------
	-- Boot Window
	------------------------------------------------
	local bootFrame = Instance.new("Frame")
	bootFrame.Name = "BootWindow"
	bootFrame.Size = UDim2.new(0, 380, 0, 260)
	bootFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
	bootFrame.BackgroundColor3 = Theme.Panel
	bootFrame.BorderSizePixel = 0
	bootFrame.ZIndex = 10
	bootFrame.Parent = self._gui
	bootFrame.Visible = false
	addCorner(bootFrame, Theme.CornerRadius)

	-- Boot Topbar
	local bootTopbar = Instance.new("Frame")
	bootTopbar.Name = "Topbar"
	bootTopbar.Size = UDim2.new(1, 0, 0, 36)
	bootTopbar.BackgroundColor3 = Theme.Section
	bootTopbar.BorderSizePixel = 0
	bootTopbar.ZIndex = 11
	bootTopbar.Parent = bootFrame
	bootTopbar.Visible = false
	addCorner(bootTopbar, Theme.CornerRadius)

	local bootTitle = Instance.new("TextLabel")
	bootTitle.Name = "Title"
	bootTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	bootTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
	bootTitle.Size = UDim2.new(1, -40, 1, 0)
	bootTitle.BackgroundTransparency = 1
	bootTitle.Font = Theme.Font
	bootTitle.Text = self.BootTitle
	bootTitle.TextColor3 = Theme.Text
	bootTitle.TextSize = 16
	bootTitle.ZIndex = 12
	bootTitle.Parent = bootTopbar
	bootTitle.Visible = false

	local bootUnderline = Instance.new("Frame")
	bootUnderline.Size = UDim2.new(0, 80, 0, 2)
	bootUnderline.AnchorPoint = Vector2.new(0.5, 1)
	bootUnderline.Position = UDim2.new(0.5, 0, 1, -2)
	bootUnderline.BackgroundColor3 = Theme.Accent
	bootUnderline.BorderSizePixel = 0
	bootUnderline.ZIndex = 12
	bootUnderline.Parent = bootTopbar
	bootUnderline.Visible = false

	local bootContent = Instance.new("ScrollingFrame")
	bootContent.Name = "Content"
	bootContent.Size = UDim2.new(1, -24, 1, -52)
	bootContent.Position = UDim2.new(0, 12, 0, 40)
	bootContent.BackgroundColor3 = Theme.BootBackground
	bootContent.BackgroundTransparency = 1
	bootContent.BorderSizePixel = 0
	bootContent.ZIndex = 11
	bootContent.Parent = bootFrame
	bootContent.Visible = false
	bootContent.ScrollBarThickness = 1
	bootContent.ScrollBarImageColor3 = Theme.Accent
	bootContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
	bootContent.ScrollingDirection = Enum.ScrollingDirection.Y
	bootContent.CanvasSize = UDim2.fromScale(0, 1)
	addCorner(bootContent, 8)

	local bootList = Instance.new("UIListLayout")
	bootList.FillDirection = Enum.FillDirection.Vertical
	bootList.SortOrder = Enum.SortOrder.LayoutOrder
	bootList.Padding = UDim.new(0, 5)
	bootList.Parent = bootContent
	bootList.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local bootPadding = Instance.new("UIPadding")
	bootPadding.PaddingTop = UDim.new(0, 4)
	bootPadding.Parent = bootContent

	makeDraggable(bootTopbar, bootFrame)

	------------------------------------------------
	-- Main Window
	------------------------------------------------
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainWindow"
	mainFrame.Size = UDim2.new(0, 560, 0, 340)
	mainFrame.Position = UDim2.new(0.5, -280, 0.5, -170)
	mainFrame.BackgroundColor3 = Theme.Background
	mainFrame.BorderSizePixel = 0
	mainFrame.ZIndex = 20
	mainFrame.Visible = false
	mainFrame.Parent = self._gui
	addCorner(mainFrame, Theme.CornerRadius)

	local mainTopbar = Instance.new("Frame")
	mainTopbar.Name = "Topbar"
	mainTopbar.Size = UDim2.new(1, 0, 0, 36)
	mainTopbar.BackgroundColor3 = Theme.Section
	mainTopbar.BorderSizePixel = 0
	mainTopbar.ZIndex = 21
	mainTopbar.Parent = mainFrame
	addCorner(mainTopbar, Theme.CornerRadius)

	local backButton = Instance.new("ImageButton")
	backButton.Name = "BackButton"
	backButton.Size = UDim2.new(0, 28, 0, 28)
	backButton.Position = UDim2.new(0, 8, 0.5, -12)
	backButton.BackgroundTransparency = 1
	backButton.BorderSizePixel = 0
	backButton.ZIndex = 22
	backButton.AutoButtonColor = false
	backButton.Visible = self.BackButton
	backButton.Parent = mainTopbar

	------------------------------------------------
	-- CLOSE BUTTON (right side)
	------------------------------------------------
	local closeButton = Instance.new("ImageButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 28, 0, 28)
	closeButton.AnchorPoint = Vector2.new(1, 0.5)
	closeButton.Position = UDim2.new(1, -8, 1, -18)
	closeButton.BackgroundTransparency = 1
	closeButton.BorderSizePixel = 0
	closeButton.ZIndex = 22
	closeButton.AutoButtonColor = false
	closeButton.Parent = mainTopbar

	-- Sprite sheet (X Button)
	closeButton.Image = "rbxassetid://3926305904"
	closeButton.ImageRectOffset = Vector2.new(920, 720)
	closeButton.ImageRectSize = Vector2.new(44, 44)
	closeButton.ImageColor3 = Theme.Text

	closeButton.MouseEnter:Connect(function()
		local Theme = window.Theme
		tween(closeButton, 0.15, { ImageColor3 = Theme.Accent })
	end)

	closeButton.MouseLeave:Connect(function()
		local Theme = window.Theme
		tween(closeButton, 0.15, { ImageColor3 = Theme.Text })
	end)

	closeButton.MouseButton1Click:Connect(function()
		self:CloseUI()
	end)

	-- Sprite sheet (Back Button)
	backButton.Image = "rbxassetid://3926305904"
	backButton.ImageRectOffset = Vector2.new(240, 281)
	backButton.ImageRectSize = Vector2.new(44, 44)
	backButton.ImageColor3 = Theme.Text

	backButton.MouseEnter:Connect(function()
		local Theme = window.Theme
		tween(backButton, 0.15, { ImageColor3 = Theme.Accent })
	end)

	backButton.MouseLeave:Connect(function()
		local Theme = window.Theme
		tween(backButton, 0.15, { ImageColor3 = Theme.Text })
	end)

	local mainTitle = Instance.new("TextLabel")
	mainTitle.Name = "Title"
	mainTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	mainTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainTitle.Size = UDim2.new(1, -40, 1, 0)
	mainTitle.BackgroundTransparency = 1
	mainTitle.Font = Theme.Font
	mainTitle.Text = self.MainTitle
	mainTitle.TextColor3 = Theme.Text
	mainTitle.TextSize = 16
	mainTitle.ZIndex = 22
	mainTitle.Parent = mainTopbar

	local mainUnderline = Instance.new("Frame")
	mainUnderline.Size = UDim2.new(0, 80, 0, 2)
	mainUnderline.AnchorPoint = Vector2.new(0.5, 1)
	mainUnderline.Position = UDim2.new(0.5, 0, 1, -2)
	mainUnderline.BackgroundColor3 = Theme.Accent
	mainUnderline.BorderSizePixel = 0
	mainUnderline.ZIndex = 22
	mainUnderline.Parent = mainTopbar

	makeDraggable(mainTopbar, mainFrame)

	local mainBody = Instance.new("Frame")
	mainBody.Name = "Body"
	mainBody.Size = UDim2.new(1, -16, 1, -48)
	mainBody.Position = UDim2.new(0, 8, 0, 40)
	mainBody.BackgroundTransparency = 1
	mainBody.ZIndex = 21
	mainBody.Parent = mainFrame

	local sidebar = Instance.new("ScrollingFrame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 140, 1, 0)
	sidebar.BackgroundColor3 = Theme.Panel
	sidebar.BorderSizePixel = 0
	sidebar.ZIndex = 21
	sidebar.Parent = mainBody
	sidebar.ScrollBarThickness = 0
	-- sidebar.ScrollBarImageColor3 = Theme.Accent
	sidebar.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sidebar.ScrollingDirection = Enum.ScrollingDirection.Y
	sidebar.CanvasSize = UDim2.fromScale(0, 1)
	addCorner(sidebar, Theme.CornerRadius)

	local sidebarList = Instance.new("UIListLayout")
	sidebarList.FillDirection = Enum.FillDirection.Vertical
	sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarList.Padding = UDim.new(0, 4)
	sidebarList.Parent = sidebar

	local sidebarPadding = Instance.new("UIPadding")
	sidebarPadding.PaddingTop = UDim.new(0, 8)
	sidebarPadding.PaddingLeft = UDim.new(0, 6)
	sidebarPadding.PaddingRight = UDim.new(0, 6)
	sidebarPadding.Parent = sidebar

	local contentHolder = Instance.new("ScrollingFrame")
	contentHolder.Name = "ContentHolder"
	contentHolder.Size = UDim2.new(1, -152, 1, 0)
	contentHolder.Position = UDim2.new(0, 152, 0, 0)
	contentHolder.BackgroundColor3 = Theme.Panel
	contentHolder.BorderSizePixel = 0
	contentHolder.ZIndex = 21
	contentHolder.Parent = mainBody
	contentHolder.ScrollBarThickness = 1
	contentHolder.ScrollBarImageColor3 = Theme.Accent
	contentHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentHolder.ScrollingDirection = Enum.ScrollingDirection.Y
	contentHolder.CanvasSize = UDim2.fromScale(0, 1)
	addCorner(contentHolder, Theme.CornerRadius)

	self._bootFrame = bootFrame
	self._bootContent = bootContent
	self._mainFrame = mainFrame
	self._uiToggleKey = Enum.KeyCode.RightShift
	self._isBindingKey = false
	self._sidebar = sidebar
	self._contentHolder = contentHolder
	self._mainTitleLabel = mainTitle
	self._themeObjects = {}

	backButton.MouseButton1Click:Connect(function()
		self:ShowBoot()
	end)

	-- Spinner rotation
	task.spawn(function()
		while loadingFrame.Visible do
			spinner.Rotation += 6
			task.wait(0.01)
		end
	end)

	-- Progress bar animation
	task.spawn(function()
		for i = 1, 100 do
			barFill.Size = UDim2.new(i / 100, 0, 1, 0)
			task.wait(0.015)
		end
	end)

	-- End loading after progress completes
	task.delay(2.5, function()
		loadingFrame.Visible = false
		bootFrame.Visible = true
		bootTopbar.Visible = true
		bootTitle.Visible = true
		bootUnderline.Visible = true
		bootContent.Visible = true
	end)

	self:_registerThemeObject(mainTopbar, "BackgroundColor3", "Section")
	self:_registerThemeObject(mainTitle, "TextColor3", "Text")
	self:_registerThemeObject(mainTitle, "Font", "Font")
	self:_registerThemeObject(mainUnderline, "BackgroundColor3", "Accent")
	self:_registerThemeObject(mainFrame, "BackgroundColor3", "Background")
	self:_registerThemeObject(contentHolder, "BackgroundColor3", "Panel")
	self:_registerThemeObject(contentHolder, "ScrollBarImageColor3", "Accent")

	self:_registerThemeObject(sidebar, "BackgroundColor3", "Panel")

	self:_registerThemeObject(bootFrame, "BackgroundColor3", "Panel")
	self:_registerThemeObject(bootTopbar, "BackgroundColor3", "Section")
	self:_registerThemeObject(bootTitle, "TextColor3", "Text")
	self:_registerThemeObject(bootTitle, "Font", "Font")
	self:_registerThemeObject(bootUnderline, "BackgroundColor3", "Accent")
	self:_registerThemeObject(bootContent, "BackgroundColor3", "BootBackground")
	self:_registerThemeObject(bootContent, "ScrollBarImageColor3", "Accent")
	self:_registerThemeObject(loadingGradient, "Color", "Gradient")
	self:_registerThemeObject(barBG, "BackgroundColor3", "Background")
	self:_registerThemeObject(barFill, "BackgroundColor3", "Accent")
	self:_registerThemeObject(subtitle, "TextColor3", "Text")
	self:_registerThemeObject(subtitle, "Font", "Font")

	return self
end

----------------------------------------------------------------
-- WINDOW METHODS
----------------------------------------------------------------

function Window:SetTitle(text)
	self.MainTitle = text
	if self._mainTitleLabel then
		self._mainTitleLabel.Text = text
	end
end

function Window:ShowBoot()
	if not self._bootFrame or not self._mainFrame then
		return
	end

	self._mainFrame.Visible = false
	self._bootFrame.Visible = true

	self._bootFrame.BackgroundTransparency = 0
	self._mainFrame.BackgroundTransparency = 0
end

function Window:ShowMain(tab)
	if not self._bootFrame or not self._mainFrame then
		return
	end

	self._bootFrame.Visible = false
	self._mainFrame.Visible = true

	self._bootFrame.BackgroundTransparency = 0
	self._mainFrame.BackgroundTransparency = 0

	if tab then
		self:_setActiveTab(tab)
	end
end

function Window:_registerThemeObject(instance, property, themeKey)
	table.insert(self._themeObjects, {
		Instance = instance,
		Property = property,
		ThemeKey = themeKey,
	})
end

function Window:_applyTheme()
	local Theme = self.Theme

	for _, obj in ipairs(self._themeObjects) do
		local inst = obj.Instance
		local prop = obj.Property
		local key = obj.ThemeKey

		if inst and inst[prop] ~= nil and Theme[key] ~= nil then
			inst[prop] = Theme[key]
		end
	end

	-- Re-apply active tab styling
	if self._activeTab then
		self:_setActiveTab(self._activeTab)
	end
end

----------------------------------------------------------------
-- UI TOGGLE API
----------------------------------------------------------------

local camera = workspace.CurrentCamera

function Window:_startMouseEnforceLoop()
	if self._mouseLoopRunning then
		return
	end
	self._mouseLoopRunning = true

	self._mouseLoop = RunService.RenderStepped:Connect(function()
		if not (self._mainFrame.Visible or self._bootFrame.Visible) then
			return
		end
		UIS.MouseBehavior = Enum.MouseBehavior.Default
		UIS.MouseIconEnabled = true
	end)

	task.defer(function()
		if self._mainFrame.Visible or self._bootFrame.Visible then
			UIS.MouseBehavior = Enum.MouseBehavior.Default
			UIS.MouseIconEnabled = true
		end
	end)

	task.delay(0.03, function()
		if self._mainFrame.Visible or self._bootFrame.Visible then
			UIS.MouseBehavior = Enum.MouseBehavior.Default
			UIS.MouseIconEnabled = true
		end
	end)
end

function Window:_stopMouseEnforceLoop()
	if self._mouseLoop then
		self._mouseLoop:Disconnect()
		self._mouseLoop = nil
	end
	self._mouseLoopRunning = false

	local inFirstPerson = (camera.CFrame.Position - camera.Focus.Position).Magnitude < 1

	if inFirstPerson then
		UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
		UIS.MouseIconEnabled = false
	else
		UIS.MouseBehavior = Enum.MouseBehavior.Default
		UIS.MouseIconEnabled = true
	end
end

-- Close the UI (both main + boot)
function Window:CloseUI()
	if not self._mainFrame or not self._bootFrame then
		return
	end
	self._mainFrame.Visible = false
	self._bootFrame.Visible = false

	self:_stopMouseEnforceLoop()
end

-- Open the UI (reopens last active tab)
function Window:OpenUI()
	if not self._mainFrame or not self._bootFrame then
		return
	end
	self:ShowMain(self._activeTab)

	self:_startMouseEnforceLoop()
end

-- Toggle the UI (used by keybinds)
function Window:ToggleUI()
	if not self._mainFrame or not self._bootFrame then
		return
	end

	-- Prevent toggle while binding a key
	if self._isBindingKey then
		return
	end

	if (self._mainFrame.Visible or self._bootFrame.Visible) and not self._isBindingKey then
		self:CloseUI()
	else
		self:OpenUI()
	end
end

----------------------------------------------------------------
-- TAB STATE / NOTIFICATION STACK
----------------------------------------------------------------

function Window:_setActiveTab(tab)
	if self._activeTab == tab then
		return
	end
	self._activeTab = tab

	local Theme = self.Theme

	for _, t in ipairs(self._tabs) do
		if t._button and t._label then
			if t == tab then
				tween(t._button, 0.15, {
					BackgroundColor3 = Theme.GradientHover,
				})
				tween(t._label, 0.15, {
					TextColor3 = Theme.Text,
				})
				if t._accent then
					t._accent.Visible = true
				end
			else
				tween(t._button, 0.15, {
					BackgroundColor3 = Theme.Background,
				})
				tween(t._label, 0.15, {
					TextColor3 = Color3.fromRGB(180, 180, 190),
				})
				if t._accent then
					t._accent.Visible = false
				end
			end
		end
	end

	for _, t in ipairs(self._tabs) do
		if t._page then
			t._page.Visible = (t == tab)
		end
	end
end

function Window:_restackNotifications()
	local holder = self._notificationHolder
	if not holder then
		return
	end

	local children = holder:GetChildren()

	-- Sort by LayoutOrder (oldest first, newest last)
	table.sort(children, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)

	-- Position oldest at top, newest at bottom
	for i, notif in ipairs(children) do
		if notif:IsA("Frame") then
			notif:TweenPosition(
				UDim2.new(1, 0, 1, -((#children - i) * 65)),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.25,
				true
			)
		end
	end
end

----------------------------------------------------------------
-- TAB CREATION
----------------------------------------------------------------

function Window:CreateTab(config)
	config = config or {}
	local tab = setmetatable({}, Tab)

	tab.Name = config.Name or "Tab"
	tab._window = self
	tab._sections = {}

	local Theme = self.Theme

	local bootButton = Instance.new("Frame")
	bootButton.Name = "BootTabButton"
	bootButton.Size = UDim2.new(0.98, 0, 0, 32)
	bootButton.BackgroundColor3 = Theme.Section
	bootButton.BorderSizePixel = 0
	bootButton.ZIndex = 11
	bootButton.Parent = self._bootContent

	addCorner(bootButton, 8)

	local gradient = Instance.new("UIGradient")
	gradient.Color = Theme.Gradient
	gradient.Parent = bootButton

	local label = Instance.new("TextButton")
	label.Name = "Label"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.Font
	label.Text = tab.Name
	label.TextSize = 14
	label.TextColor3 = Theme.Text
	label.ZIndex = 12
	label.Parent = bootButton
	label.AutoButtonColor = false

	label.MouseEnter:Connect(function()
		tween(bootButton, 0.25, { BackgroundColor3 = Theme.GradientHover })
	end)

	label.MouseLeave:Connect(function()
		tween(bootButton, 0.25, { BackgroundColor3 = Theme.Section })
	end)

	label.MouseButton1Click:Connect(function()
		self:ShowMain(tab)
	end)

	-- Background frame
	local sideButton = Instance.new("Frame")
	sideButton.Name = "SidebarTabButton"
	sideButton.Size = UDim2.new(1, 0, 0, 30)
	sideButton.BackgroundColor3 = Theme.Background
	sideButton.BorderSizePixel = 0
	sideButton.ZIndex = 21
	sideButton.Parent = self._sidebar
	addCorner(sideButton, 8)

	-- Gradient
	local sideGradient = Instance.new("UIGradient")
	sideGradient.Color = Theme.Gradient
	sideGradient.Parent = sideButton

	-- Clickable label
	local sideLabel = Instance.new("TextButton")
	sideLabel.Name = "Label"
	sideLabel.Size = UDim2.new(1, 0, 1, 0)
	sideLabel.BackgroundTransparency = 1
	sideLabel.Font = Theme.Font
	sideLabel.Text = tab.Name
	sideLabel.TextSize = 14
	sideLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
	sideLabel.ZIndex = 22
	sideLabel.Parent = sideButton
	sideLabel.AutoButtonColor = false

	local accentBar = Instance.new("Frame")
	accentBar.Name = "Accent"
	accentBar.Size = UDim2.new(0, 3, 1, 0)
	accentBar.Position = UDim2.new(0, -3, 0, 0)
	accentBar.BackgroundColor3 = Theme.Accent
	accentBar.BorderSizePixel = 0
	accentBar.ZIndex = 23
	accentBar.Visible = false
	accentBar.Parent = sideButton

	local window = self

	sideLabel.MouseEnter:Connect(function()
		local Theme = window.Theme
		if window._activeTab ~= tab then
			tween(sideButton, 0.15, { BackgroundColor3 = Theme.GradientHover })
		end
	end)

	sideLabel.MouseLeave:Connect(function()
		local Theme = window.Theme
		if window._activeTab ~= tab then
			tween(sideButton, 0.15, { BackgroundColor3 = Theme.Background })
		end
	end)

	sideLabel.MouseButton1Click:Connect(function()
		self:ShowMain(tab)
	end)

	local page = Instance.new("Frame")
	page.Name = "Page"
	page.Size = UDim2.new(1, -16, 1, -16)
	page.Position = UDim2.new(0, 8, 0, 8)
	page.BackgroundTransparency = 1
	page.ZIndex = 21
	page.Visible = false
	page.Parent = self._contentHolder

	local pageList = Instance.new("UIListLayout")
	pageList.FillDirection = Enum.FillDirection.Vertical
	pageList.SortOrder = Enum.SortOrder.LayoutOrder
	pageList.Padding = UDim.new(0, 8)
	pageList.Parent = page

	local pagePadding = Instance.new("UIPadding")
	pagePadding.PaddingTop = UDim.new(0, 4)
	pagePadding.Parent = page

	tab._button = sideButton
	tab._label = sideLabel
	tab._gradient = sideGradient
	tab._accent = accentBar
	tab._page = page
	table.insert(self._tabs, tab)

	if not self._activeTab then
		self:_setActiveTab(tab)
	end

	window:_registerThemeObject(gradient, "Color", "Gradient")
	window:_registerThemeObject(bootButton, "BackgroundColor3", "Background")

	window:_registerThemeObject(sideButton, "BackgroundColor3", "Background")
	window:_registerThemeObject(sideLabel, "TextColor3", "SubtitleText")
	window:_registerThemeObject(sideLabel, "Font", "Font")
	window:_registerThemeObject(accentBar, "BackgroundColor3", "Accent")
	window:_registerThemeObject(sideGradient, "Color", "Gradient")

	return tab
end

--------------------------------------------------------
-- SECTION CREATION
--------------------------------------------------------

function Tab:CreateSection(config)
	config = config or {}
	local section = setmetatable({}, Section)

	section.Name = config.Name or "Section"
	section._tab = self
	section._window = self._window

	local Theme = self._window.Theme

	local frame = Instance.new("Frame")
	frame.Name = "Section"
	frame.Size = UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.BackgroundColor3 = Theme.Section
	frame.BorderSizePixel = 0
	frame.ZIndex = 21
	frame.Parent = self._page
	addCorner(frame, Theme.CornerRadius)

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = frame

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 18)
	title.BackgroundTransparency = 1
	title.Font = Theme.Font
	title.Text = section.Name
	title.TextColor3 = Theme.Text
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 22
	title.Parent = frame

	section._frame = frame

	local window = self._window

	window:_registerThemeObject(frame, "BackgroundColor3", "Section")
	window:_registerThemeObject(title, "TextColor3", "Text")
	window:_registerThemeObject(title, "Font", "Font")

	return section
end

--------------------------------------------------------
-- COMPONENTS
--------------------------------------------------------

-- BUTTON
function Section:CreateButton(config)
	config = config or {}
	local name = config.Name or "Button"
	local callback = config.Callback or function() end

	local window = self._window
	local Theme = window.Theme

	local button = Instance.new("TextButton")
	button.Name = "Button"
	button.Size = UDim2.new(1, 0, 0, 28)
	button.BackgroundColor3 = Theme.Background
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Font = Theme.Font
	button.Text = name
	button.TextSize = 14
	button.TextColor3 = Theme.Text
	button.ZIndex = 22
	button.Parent = self._frame
	addCorner(button, 8)

	-- Hover animation
	button.MouseEnter:Connect(function()
		local Theme = window.Theme
		tween(button, 0.15, { BackgroundColor3 = Theme.Panel })
	end)

	button.MouseLeave:Connect(function()
		local Theme = window.Theme
		tween(button, 0.15, { BackgroundColor3 = Theme.Background })
	end)

	-- Press animation
	button.MouseButton1Click:Connect(function()
		local Theme = window.Theme
		tween(button, 0.08, { BackgroundColor3 = Theme.Accent })

		task.delay(0.08, function()
			local Theme = window.Theme
			tween(button, 0.15, { BackgroundColor3 = Theme.Panel })
		end)

		callback()
	end)

	-- Theme registry
	window:_registerThemeObject(button, "BackgroundColor3", "Background")
	window:_registerThemeObject(button, "TextColor3", "Text")
	window:_registerThemeObject(button, "Font", "Font")

	return button
end

-- TOGGLE
function Section:CreateToggle(config)
	config = config or {}
	local name = config.Name or "Toggle"
	local key = config.ConfigKey
	local default = config.Default or false
	local callback = config.Callback or function() end

	local window = self._window
	local Theme = window.Theme

	if not key then
		warn("[Phoenix] Missing ConfigKey for Toggle: " .. tostring(name))
	end

	local saved = key and window:GetConfigValue(key, default) or default

	local frame = Instance.new("Frame")
	frame.Name = "Toggle"
	frame.Size = UDim2.new(1, 0, 0, 28)
	frame.BackgroundTransparency = 1
	frame.ZIndex = 22
	frame.Parent = self._frame

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -60, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.Font
	label.Text = name
	label.TextColor3 = Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 22
	label.Parent = frame

	local switch = Instance.new("Frame")
	switch.Name = "Switch"
	switch.Size = UDim2.new(0, 40, 0, 18)
	switch.Position = UDim2.new(1, -40, 0.5, -9)
	switch.BackgroundColor3 = Theme.Background
	switch.BorderSizePixel = 0
	switch.ZIndex = 22
	switch.Parent = frame
	addCorner(switch, 9)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = UDim2.new(saved and 1 or 0, saved and -17 or 1, 0.5, -8)
	knob.BackgroundColor3 = Theme.Text
	knob.BorderSizePixel = 0
	knob.ZIndex = 23
	knob.Parent = switch
	addCorner(knob, 8)

	local hitbox = Instance.new("TextButton")
	hitbox.Name = "Hitbox"
	hitbox.Size = UDim2.new(1, 0, 1, 0)
	hitbox.BackgroundTransparency = 1
	hitbox.Text = ""
	hitbox.ZIndex = 24
	hitbox.Parent = switch

	local state = saved

	local function setState(v)
		state = v
		local Theme = window.Theme

		tween(knob, 0.15, {
			Position = UDim2.new(v and 1 or 0, v and -17 or 1, 0.5, -8),
			BackgroundColor3 = Theme.Text,
		})

		tween(switch, 0.15, {
			BackgroundColor3 = v and Theme.Accent or Theme.Background,
		})

		if key then
			window:SetConfigValue(key, v)
		end

		callback(v)
	end

	hitbox.MouseButton1Click:Connect(function()
		setState(not state)
	end)

	-- Hover
	hitbox.MouseEnter:Connect(function()
		local Theme = window.Theme
		if not state then
			tween(switch, 0.15, { BackgroundColor3 = Theme.Panel })
		end
	end)

	hitbox.MouseLeave:Connect(function()
		local Theme = window.Theme
		tween(switch, 0.15, { BackgroundColor3 = state and Theme.Accent or Theme.Background })
	end)

	-- Theme registry
	window:_registerThemeObject(label, "TextColor3", "Text")
	window:_registerThemeObject(label, "Font", "Font")
	window:_registerThemeObject(switch, "BackgroundColor3", "Background")
	window:_registerThemeObject(knob, "BackgroundColor3", "Text")

	-- Apply saved state
	setState(saved)

	if key then
		table.insert(window._configCallbacks, function(cfg)
			local v = cfg[key]
			if v ~= nil then
				setState(v)
			end
		end)
	end

	return {
		Set = setState,
		Get = function()
			return state
		end,
	}
end

-- SLIDER
function Section:CreateSlider(config)
	config = config or {}
	local name = config.Name or "Slider"
	local key = config.ConfigKey
	local min = config.Min or 0
	local max = config.Max or 100
	local step = config.Step or 1
	local default = config.Default or min
	local callback = config.Callback or function() end

	local window = self._window

	if not key then
		warn("[Phoenix] Missing ConfigKey for Slider: " .. tostring(name))
	end

	local saved = key and window:GetConfigValue(key, default) or default

	-- Container
	local frame = Instance.new("Frame")
	frame.Name = "Slider"
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundTransparency = 1
	frame.ZIndex = 22
	frame.Parent = self._frame

	-- Label
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, 0, 0, 18)
	label.BackgroundTransparency = 1
	label.Font = window.Theme.Font
	label.Text = name
	label.TextColor3 = window.Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 22
	label.Parent = frame

	-- Bar
	local bar = Instance.new("Frame")
	bar.Name = "Bar"
	bar.Size = UDim2.new(1, -60, 0, 6)
	bar.Position = UDim2.new(0, 0, 1, -10)
	bar.BackgroundColor3 = window.Theme.Background
	bar.BorderSizePixel = 0
	bar.ZIndex = 22
	bar.Parent = frame
	addCorner(bar, 3)

	-- Fill
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = window.Theme.Accent
	fill.BorderSizePixel = 0
	fill.ZIndex = 23
	fill.Parent = bar
	addCorner(fill, 3)

	-- Knob
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(0, 0, 0.5, 0)
	knob.BackgroundColor3 = window.Theme.Text
	knob.BorderSizePixel = 0
	knob.ZIndex = 24
	knob.Parent = bar
	addCorner(knob, 7)

	-- Hitbox
	local hitbox = Instance.new("Frame")
	hitbox.Name = "Hitbox"
	hitbox.Size = UDim2.new(1, 0, 1, 0)
	hitbox.BackgroundTransparency = 1
	hitbox.ZIndex = 25
	hitbox.Parent = bar

	-- Input box
	local box = Instance.new("TextBox")
	box.Name = "Box"
	box.Size = UDim2.new(0, 50, 0, 18)
	box.Position = UDim2.new(1, -50, 0, 0)
	box.BackgroundColor3 = window.Theme.Background
	box.BorderSizePixel = 0
	box.Font = window.Theme.Font
	box.Text = tostring(saved)
	box.TextColor3 = window.Theme.Text
	box.TextSize = 14
	box.ClearTextOnFocus = false
	box.ZIndex = 23
	box.Parent = frame
	addCorner(box, 4)

	-- Snap
	local function snap(v)
		return math.clamp(math.floor((v - min) / step + 0.5) * step + min, min, max)
	end

	-- Internal value
	local value = snap(saved)

	-- Visual update
	local function updateVisual(v)
		local alpha = (v - min) / (max - min)
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		box.Text = tostring(v)
	end

	-- Set value
	local function setValue(v)
		v = snap(v)
		value = v
		updateVisual(v)

		if key then
			window:SetConfigValue(key, v)
		end

		callback(v)
	end

	-- Dragging
	local dragging = false

	local function drag(input)
		local barPos = bar.AbsolutePosition.X
		local barSize = bar.AbsoluteSize.X

		local mouseX = input.Position.X
		local knobX = math.clamp(mouseX, barPos, barPos + barSize)

		local rel = (knobX - barPos) / barSize
		local raw = min + (max - min) * rel

		setValue(raw)
	end

	knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	hitbox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			drag(input)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			drag(input)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- Input box
	box.Focused:Connect(function()
		tween(box, 0.1, { BackgroundColor3 = window.Theme.Panel })
	end)

	box.FocusLost:Connect(function(enter)
		tween(box, 0.1, { BackgroundColor3 = window.Theme.Background })

		if enter then
			local num = tonumber(box.Text)
			if num then
				setValue(num)
			else
				box.Text = tostring(value)
			end
		end
	end)

	-- Theme registry
	window:_registerThemeObject(label, "TextColor3", "Text")
	window:_registerThemeObject(label, "Font", "Font")
	window:_registerThemeObject(bar, "BackgroundColor3", "Background")
	window:_registerThemeObject(fill, "BackgroundColor3", "Accent")
	window:_registerThemeObject(knob, "BackgroundColor3", "Text")
	window:_registerThemeObject(box, "BackgroundColor3", "Background")
	window:_registerThemeObject(box, "TextColor3", "Text")
	window:_registerThemeObject(box, "Font", "Font")

	-- Apply saved value
	setValue(saved)

	if key then
		table.insert(window._configCallbacks, function(cfg)
			local v = cfg[key]
			if v ~= nil then
				setValue(v)
			end
		end)
	end

	return {
		Set = setValue,
		Get = function()
			return value
		end,
	}
end

-- TEXT INPUT
function Section:CreateInput(config)
	config = config or {}
	local name = config.Name or "Input"
	local key = config.ConfigKey
	local placeholder = config.Placeholder or ""
	local default = config.Default or ""
	local callback = config.Callback or function() end

	local window = self._window
	local Theme = window.Theme

	if not key then
		warn("[Phoenix] Missing ConfigKey for Input: " .. tostring(name))
	end

	local saved = key and window:GetConfigValue(key, default) or default

	local frame = Instance.new("Frame")
	frame.Name = "Input"
	frame.Size = UDim2.new(1, 0, 0, 28)
	frame.BackgroundTransparency = 1
	frame.ZIndex = 22
	frame.Parent = self._frame

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -120, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.Font
	label.Text = name
	label.TextColor3 = Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 22
	label.Parent = frame

	local box = Instance.new("TextBox")
	box.Name = "Box"
	box.Size = UDim2.new(0, 110, 0, 22)
	box.Position = UDim2.new(1, -110, 0.5, -11)
	box.BackgroundColor3 = Theme.Background
	box.BorderSizePixel = 0
	box.Font = Theme.Font
	box.Text = saved
	box.PlaceholderText = placeholder
	box.PlaceholderColor3 = Theme.SubtitleText
	box.TextColor3 = Theme.Text
	box.TextSize = 14
	box.ClearTextOnFocus = false
	box.ZIndex = 23
	box.Parent = frame
	addCorner(box, 6)

	local function setText(v)
		box.Text = v
	end
	
	-- Hover
	box.MouseEnter:Connect(function()
		local Theme = window.Theme
		if not box:IsFocused() then
			tween(box, 0.15, { BackgroundColor3 = Theme.Panel })
		end
	end)

	box.MouseLeave:Connect(function()
		local Theme = window.Theme
		if not box:IsFocused() then
			tween(box, 0.15, { BackgroundColor3 = Theme.Background })
		end
	end)

	-- Focus
	box.Focused:Connect(function()
		local Theme = window.Theme
		tween(box, 0.15, { BackgroundColor3 = Theme.Accent })
	end)

	box.FocusLost:Connect(function(enterPressed)
		local Theme = window.Theme
		tween(box, 0.15, { BackgroundColor3 = Theme.Background })

		-- Save + callback
		if key then
			window:SetConfigValue(key, box.Text)
		end

		callback(box.Text)
	end)

	-- Theme registry
	window:_registerThemeObject(label, "TextColor3", "Text")
	window:_registerThemeObject(label, "Font", "Font")
	window:_registerThemeObject(box, "BackgroundColor3", "Background")
	window:_registerThemeObject(box, "TextColor3", "Text")
	window:_registerThemeObject(box, "Font", "Font")
	window:_registerThemeObject(box, "PlaceholderColor3", "SubtitleText")

	return {
		Set = setText,
		Get = function()
			return box.Text
		end,
	}
end

-- NOTE
function Section:CreateNote(config)
	config = config or {}
	local text = config.Text or "Note"

	local window = self._window
	local Theme = window.Theme

	local label = Instance.new("TextLabel")
	label.Name = "Note"
	label.Size = UDim2.new(1, 0, 0, 18)
	label.BackgroundTransparency = 1
	label.Font = Theme.Font
	label.Text = text
	label.TextColor3 = Theme.SubtitleText
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 22
	label.Parent = self._frame

	window:_registerThemeObject(label, "TextColor3", "SubtitleText")
	window:_registerThemeObject(label, "Font", "Font")

	return label
end

-- DROPDOWN
function Section:CreateDropdown(config)
	config = config or {}
	local name = config.Name or "Dropdown"
	local key = config.ConfigKey
	local options = config.Options or {}
	local default = config.Default or nil
	local callback = config.Callback or function() end

	local window = self._window
	local Theme = window.Theme

	if not key then
		warn("[Phoenix] Missing ConfigKey for Dropdown: " .. tostring(name))
	end

	local saved = key and window:GetConfigValue(key, default) or default

	-- Container
	local frame = Instance.new("Frame")
	frame.Name = "Dropdown"
	frame.Size = UDim2.new(1, 0, 0, 32)
	frame.BackgroundTransparency = 1
	frame.ZIndex = 22
	frame.Parent = self._frame

	-- Label
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -120, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.Font
	label.Text = name
	label.TextColor3 = Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 22
	label.Parent = frame

	-- Main button
	local button = Instance.new("TextButton")
	button.Name = "Button"
	button.Size = UDim2.new(0, 110, 0, 22)
	button.Position = UDim2.new(1, -110, 0.5, -11)
	button.BackgroundColor3 = Theme.Background
	button.BorderSizePixel = 0
	button.Font = Theme.Font
	button.Text = saved or default or "Select"
	button.TextColor3 = Theme.Text
	button.TextSize = 14
	button.AutoButtonColor = false
	button.ZIndex = 23
	button.TextTruncate = Enum.TextTruncate.AtEnd
	button.Parent = frame
	addCorner(button, 6)

	-- Dropdown list
	local listFrame = Instance.new("ScrollingFrame")
	listFrame.Name = "List"
	listFrame.Size = UDim2.new(0, 400, 0, 300)
	listFrame.Position = UDim2.fromScale(0.5, 0.5)
	listFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	listFrame.BackgroundColor3 = Theme.AccentHover
	listFrame.BorderSizePixel = 0
	listFrame.ZIndex = 24
	listFrame.Visible = false
	listFrame.Parent = window._gui
	listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	listFrame.ScrollBarThickness = 4
	listFrame.ScrollBarImageColor3 = Theme.Accent
	addCorner(listFrame, 6)

	local listStroke = Instance.new("UIStroke")
	listStroke.Name = "Stroke"
	listStroke.Color = Theme.AccentGlow
	listStroke.Thickness = 0.5
	listStroke.Transparency = 0.5
	listStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	listStroke.Parent = listFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = listFrame

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)
	padding.PaddingLeft = UDim.new(0, 10)
	padding.PaddingRight = UDim.new(0, 10)
	padding.Parent = listFrame

	local open = false

	local function setValue(v)
		button.Text = tostring(v)

		if key then
			window:SetConfigValue(key, v)
		end

		callback(v)
	end

	-- Build options
	local function buildOptions()
		for _, child in ipairs(listFrame:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		for _, opt in ipairs(options) do
			local optBtn = Instance.new("TextButton")
			optBtn.Name = "Option"
			optBtn.AutomaticSize = Enum.AutomaticSize.X
			optBtn.Size = UDim2.new(1, -8, 0, 20)
			optBtn.BackgroundColor3 = Theme.Accent
			optBtn.BorderSizePixel = 0
			optBtn.Font = Theme.Font
			optBtn.Text = tostring(opt)
			optBtn.TextColor3 = Theme.Text
			optBtn.TextSize = 14
			optBtn.AutoButtonColor = false
			optBtn.ZIndex = 25
			optBtn.Parent = listFrame
			addCorner(optBtn, 4)

			window:_registerThemeObject(optBtn, "BackgroundColor3", "Accent")
			window:_registerThemeObject(optBtn, "TextColor3", "Text")
			window:_registerThemeObject(optBtn, "Font", "Font")

			optBtn.MouseEnter:Connect(function()
				tween(optBtn, 0.1, { BackgroundColor3 = Theme.AccentGlow })
			end)

			optBtn.MouseLeave:Connect(function()
				tween(optBtn, 0.1, { BackgroundColor3 = Theme.Accent })
			end)

			optBtn.MouseButton1Click:Connect(function()
				setValue(opt)
				open = false
				listFrame.Visible = false
				listFrame.Size = UDim2.new(0, 400, 0, 0)
			end)
		end
	end

	buildOptions()

	-- Toggle dropdown
	button.MouseButton1Click:Connect(function()
		open = not open

		if open then
			listFrame.Visible = true
			tween(listFrame, 0.15, { Size = UDim2.new(0, 400, 0, 300) })
		else
			tween(listFrame, 0.15, { Size = UDim2.new(0, 400, 0, 0) })
			task.delay(0.15, function()
				if not open then
					listFrame.Visible = false
				end
			end)
		end
	end)

	-- Theme registry
	window:_registerThemeObject(label, "TextColor3", "Text")
	window:_registerThemeObject(label, "Font", "Font")
	window:_registerThemeObject(button, "BackgroundColor3", "Background")
	window:_registerThemeObject(button, "TextColor3", "Text")
	window:_registerThemeObject(button, "Font", "Font")

	window:_registerThemeObject(listFrame, "BackgroundColor3", "Section")
	window:_registerThemeObject(listFrame, "ScrollBarImageColor3", "AccentHover")
	window:_registerThemeObject(listStroke, "Color", "AccentGlow")

	if key then
		table.insert(window._configCallbacks, function(cfg)
			local v = cfg[key]
			if v ~= nil then
				setValue(v)
			end
		end)
	end

	return {
		Set = function(v)
			setValue(v)
			callback(v)
		end,
		Refresh = function(newOptions)
			options = newOptions
			buildOptions()
		end,
		Get = function()
			return button.Text
		end,
	}
end

-- PLAYER DROPDOWN
function Section:CreatePlayerDropdown(config)
    local key = config.ConfigKey
    local name = config.Name or "Players"

    if not key then
        warn("[Phoenix] Missing ConfigKey for PlayerDropdown: " .. tostring(name))
    end

    local function toDisplay(plr)
        return plr.DisplayName .. " (" .. plr.Name .. ")"
    end

    local function toUsername(displayString)
        return displayString:match("%((.-)%)")
    end

    local function getPlayerNames()
        local list = { "Select" }
        for _, plr in ipairs(Players:GetPlayers()) do
            table.insert(list, toDisplay(plr))
        end
        return list
    end

    local dropdown = self:CreateDropdown({
        Name = name,
        Options = getPlayerNames(),
        Default = config.Default or "Select",
        ConfigKey = key,
        Callback = function(selected)
            if config.Callback then
                local username = toUsername(selected)
                local plr = Players:FindFirstChild(username)
                config.Callback(plr, selected)
            end
        end,
    })

    dropdown.Refresh(getPlayerNames())

    Players.PlayerAdded:Connect(function()
        dropdown.Refresh(getPlayerNames())
    end)

    Players.PlayerRemoving:Connect(function()
        dropdown.Refresh(getPlayerNames())
    end)

    return {
        Set = function(displayString)
            dropdown.Set(displayString)
        end,

        Get = function()
            local displayString = dropdown.Get()
            if displayString == "Select" then
                return nil, "Select"
            end

            local username = toUsername(displayString)
            local plr = Players:FindFirstChild(username)
            return plr, displayString
        end,

        Refresh = dropdown.Refresh
    }
end

-- KEYBIND
function Section:CreateKeybind(config)
	config = config or {}
	local name = config.Name or "Keybind"
	local key = config.ConfigKey
	local default = config.Default or "K"
	local callback = config.Callback or function() end

	local window = self._window
	local Theme = window.Theme

	if not key then
		warn("[Phoenix] Missing ConfigKey for Keybind: " .. tostring(name))
	end

	-- Normalize function (string → Enum.KeyCode)
	local function normalizeKey(v)
		if typeof(v) == "EnumItem" and v.EnumType == Enum.KeyCode then
			return v
		end
		if typeof(v) == "string" then
			local upper = v:upper()
			if Enum.KeyCode[upper] then
				return Enum.KeyCode[upper]
			end
		end
		return Enum.KeyCode.K
	end

	local saved = key and window:GetConfigValue(key, default) or default
	local currentKey = normalizeKey(saved)

	-- Container
	local frame = Instance.new("Frame")
	frame.Name = "Keybind"
	frame.Size = UDim2.new(1, 0, 0, 28)
	frame.BackgroundTransparency = 1
	frame.ZIndex = 22
	frame.Parent = self._frame

	-- Label
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -120, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Theme.Font
	label.Text = name
	label.TextColor3 = Theme.Text
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 22
	label.Parent = frame

	-- Button
	local button = Instance.new("TextButton")
	button.Name = "Button"
	button.Size = UDim2.new(0, 110, 0, 22)
	button.Position = UDim2.new(1, -110, 0.5, -11)
	button.BackgroundColor3 = Theme.Background
	button.BorderSizePixel = 0
	button.Font = Theme.Font
	button.Text = tostring(currentKey.Name)
	button.TextColor3 = Theme.Text
	button.TextSize = 14
	button.AutoButtonColor = false
	button.ZIndex = 23
	button.Parent = frame
	addCorner(button, 6)

	-- Binding state
	local binding = false

	local function setKey(newKey)
		currentKey = normalizeKey(newKey)
		button.Text = currentKey.Name

		if key then
			window:SetConfigValue(key, currentKey.Name)
		end

		callback(currentKey)
	end

	-- Binding logic
	button.MouseButton1Click:Connect(function()
		if binding then
			return
		end
		binding = true
		window._isBindingKey = true

		button.Text = "Press a key..."

		local conn
		conn = UIS.InputBegan:Connect(function(input)
			if input.KeyCode ~= Enum.KeyCode.Unknown then
				conn:Disconnect()
				binding = false
				window._isBindingKey = false
				setKey(input.KeyCode)
			end
		end)
	end)

	-- Hover
	button.MouseEnter:Connect(function()
		if not binding then
			tween(button, 0.15, { BackgroundColor3 = Theme.Panel })
		end
	end)

	button.MouseLeave:Connect(function()
		if not binding then
			tween(button, 0.15, { BackgroundColor3 = Theme.Background })
		end
	end)

	-- Theme registry
	window:_registerThemeObject(label, "TextColor3", "Text")
	window:_registerThemeObject(label, "Font", "Font")
	window:_registerThemeObject(button, "BackgroundColor3", "Background")
	window:_registerThemeObject(button, "TextColor3", "Text")
	window:_registerThemeObject(button, "Font", "Font")

	-- Apply saved key
	setKey(currentKey)

	if key then
		table.insert(window._configCallbacks, function(cfg)
			local v = cfg[key]
			if v ~= nil then
				setKey(v)
			end
		end)
	end

	return {
		Set = setKey,
		Get = function()
			return currentKey
		end,
	}
end

--------------------------------------------------------
-- NOTIFICATIONS
--------------------------------------------------------

function Window:Notify(config)
	local title = config.Title or "Notification"
	local content = config.Content or ""
	local duration = config.Duration or 3
	local Theme = self.Theme

	local holder = self._notificationHolder
	if not holder then
		warn("NotificationHolder missing")
		return
	end

	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(1, 0, 0, 60)
	notif.BackgroundColor3 = Theme.Panel
	notif.BackgroundTransparency = 0.15
	notif.BorderSizePixel = 0
	notif.Parent = holder
	notif.ClipsDescendants = true
	notif.Position = UDim2.new(1, 300, 1, 0)
	notif.AnchorPoint = Vector2.new(1, 1)
	notif.Position = UDim2.new(1, 300, 1, 0)
	notif.LayoutOrder = os.clock()

	local uiCorner = Instance.new("UICorner", notif)
	uiCorner.CornerRadius = UDim.new(0, 6)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Parent = notif
	titleLabel.Size = UDim2.new(1, -20, 0, 20)
	titleLabel.Position = UDim2.new(0, 10, 0, 5)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Theme.Font
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Text = title

	local contentLabel = Instance.new("TextLabel")
	contentLabel.Parent = notif
	contentLabel.Size = UDim2.new(1, -20, 0, 20)
	contentLabel.Position = UDim2.new(0, 10, 0, 30)
	contentLabel.BackgroundTransparency = 1
	contentLabel.Font = Theme.Font
	contentLabel.TextSize = 13
	contentLabel.TextColor3 = Theme.SubtitleText
	contentLabel.TextXAlignment = Enum.TextXAlignment.Left
	contentLabel.Text = content

	-- Slide in
	notif:TweenPosition(
		UDim2.new(1, 0, 1, -((#holder:GetChildren() - 1) * 65)),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.25,
		true
	)

	task.delay(duration, function()
		notif:TweenPosition(
			UDim2.new(1, 300, notif.Position.Y.Scale, notif.Position.Y.Offset),
			Enum.EasingDirection.In,
			Enum.EasingStyle.Quad,
			0.25,
			true,
			function()
				notif:Destroy()
				self:_restackNotifications()
			end
		)
	end)
end

----------------------------------------------------------------
-- EXPORT
----------------------------------------------------------------

if getgenv then
	getgenv().Phoenix = Phoenix
end

return Phoenix
