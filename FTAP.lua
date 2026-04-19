----------------------------------------------------------------
-- SERVICES & GLOBALS
----------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

----------------------------------------------------------------
-- LOAD Phoenix & WINDOW SETUP
----------------------------------------------------------------
local Phoenix =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/rebornspy/Phoenix/refs/heads/main/Phoenix.lua"))()

local Window = Phoenix:CreateWindow({
	Name = "FTAP Reborn",
	BootTitle = "FTAP Reborn",
	MainTitle = "FTAP Reborn",
	Theme = "Default",
})

-- UI Toggle Keybind
UserInputService.InputBegan:Connect(function(input, gp)
	if gp or Window._isBindingKey then
		return
	end
	if input.KeyCode == Enum.KeyCode.K then
		Window:ToggleUI()
	end
end)

----------------------------------------------------------------
-- TABS
----------------------------------------------------------------
local MainTab = Window:CreateTab({ Name = "Main" })
local MovementTab = Window:CreateTab({ Name = "Movement" })
local CombatTab = Window:CreateTab({ Name = "Combat" })
local VisualTab = Window:CreateTab({ Name = "Visual" })
local ThemesTab = Window:CreateTab({ Name = "Themes" })
local InformationTab = Window:CreateTab({ Name = "Information" })
local TestingTab = Window:CreateTab({ Name = "Testing" })
local ImportExportTab = Window:CreateTab({ Name = "Import/Export" })

----------------------------------------------------------------
-- MAIN TAB
----------------------------------------------------------------
local mainSection = MainTab:CreateSection({ Name = "General" })

mainSection:CreateButton({
	Name = "Print Hello",
	Callback = function()
		print("Hello!")
	end,
})

local autoPrint = false
mainSection:CreateToggle({
	Name = "Auto Print",
	Default = false,
	Callback = function(state)
		autoPrint = state
	end,
})

RunService.RenderStepped:Connect(function()
	if autoPrint then
		print("This is useless")
	end
end)

mainSection:CreateButton({
	Name = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
	end,
})

----------------------------------------------------------------
-- MOVEMENT TAB
----------------------------------------------------------------
local walkSection = MovementTab:CreateSection({ Name = "Walk Settings" })

-- WalkSpeed
walkSection:CreateSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 100,
	Default = 16,
	Step = 1,
	Callback = function(value)
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = value
		end
	end,
})

-- TP Walk
local tpwalkEnabled = false
local tpwalkSpeed = 1.5

walkSection:CreateToggle({
	Name = "TP Walk",
	Default = false,
	Callback = function(state)
		tpwalkEnabled = state
	end,
})

walkSection:CreateSlider({
	Name = "TPWalk Speed",
	Min = 0.5,
	Max = 5,
	Default = 1.5,
	Step = 0.05,
	Callback = function(value)
		tpwalkSpeed = value
	end,
})

-- Noclip
local noclipEnabled = false
walkSection:CreateToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(state)
		noclipEnabled = state
	end,
})

-- Character Movement Loop
local function setupCharacter(char)
	local humanoid = char:WaitForChild("Humanoid")
	local head = char:FindFirstChild("Head")
	local torso = char:FindFirstChild("Torso")

	RunService.RenderStepped:Connect(function()
		-- TPWalk
		if tpwalkEnabled and humanoid.MoveDirection.Magnitude > 0 then
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame += humanoid.MoveDirection * tpwalkSpeed
			end
		end

		-- Noclip
		if head then
			head.CanCollide = not noclipEnabled
		end
		if torso then
			torso.CanCollide = not noclipEnabled
		end
	end)
end
--[[
-- Mouse TP
local mouseTPEnabled = false
local MAX_DISTANCE = 1000

local function getLookRay()
  local viewport = camera.ViewportSize
  local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
  local unitRay = camera:ViewportPointToRay(center.X, center.Y)
  return unitRay.Origin, unitRay.Direction
end

local function getLookHit()
  local origin, direction = getLookRay()

  local params = RaycastParams.new()
  params.FilterType = Enum.RaycastFilterType.Exclude
  params.FilterDescendantsInstances = { player.Character }

  local result = workspace:Raycast(origin, direction * MAX_DISTANCE, params)
  if result then
    return result.Position
  end

  return origin + direction * MAX_DISTANCE
end

local function mouseTP()
  if not mouseTPEnabled then return end

  local char = player.Character
  if not char then return end

  local hrp = char:FindFirstChild("HumanoidRootPart")
  if not hrp then return end

  local hitPos = getLookHit()

  hrp.CFrame = CFrame.new(
    hitPos + Vector3.new(0, 2.5, 0),
    hitPos + hrp.CFrame.LookVector
  )
end

walkSection:CreateToggle({
  Name = "Mouse TP",
  Default = false,
  Callback = function(state)
    mouseTPEnabled = state
  end
})

UIS.InputBegan:Connect(function(input, gp)
  if gp then return end
  if input.UserInputType == Enum.UserInputType.Z then
    mouseTP()
  end
end)
]]
player.CharacterAdded:Connect(setupCharacter)
if player.Character then
	setupCharacter(player.Character)
end

-- Jump Settings
local jumpSection = MovementTab:CreateSection({ Name = "Jump Settings" })

jumpSection:CreateSlider({
	Name = "JumpPower",
	Min = 0,
	Max = 200,
	Default = 25,
	Step = 5,
	Callback = function(value)
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.UseJumpPower = true
			hum.JumpPower = value
		end
	end,
})

-- Infinite Jump
local infiniteJumpEnabled = false
jumpSection:CreateToggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(state)
		infiniteJumpEnabled = state
	end,
})

UserInputService.InputBegan:Connect(function(input, gp)
	if gp or not infiniteJumpEnabled then
		return
	end
	if input.KeyCode == Enum.KeyCode.Space then
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- Gravity
local gravitySlider = jumpSection:CreateSlider({
	Name = "Gravity",
	Min = 0,
	Max = 1000,
	Default = 100,
	Step = 1,
	Callback = function(value)
		workspace.Gravity = value
	end,
})

jumpSection:CreateButton({
	Name = "Default Gravity",
	Callback = function()
		workspace.Gravity = 100
		gravitySlider:Set(100)
	end,
})

----------------------------------------------------------------
-- COMBAT TAB
----------------------------------------------------------------
local combatSection = CombatTab:CreateSection({ Name = "Suicide Section" })

combatSection:CreateButton({
	Name = "die",
	Callback = function()
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.Health = 0
		end
	end,
})

local autoDie = false
combatSection:CreateToggle({
	Name = "Auto Die",
	Default = false,
	Callback = function(state)
		autoDie = state
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if state and hum then
			hum.Health = 0
		end
	end,
})

player.CharacterAdded:Connect(function(char)
	if autoDie then
		local hum = char:WaitForChild("Humanoid")
		task.wait(0.5)
		hum.Health = 0
	end
end)

combatSection:CreatePlayerDropdown({
	Name = "Players",
	Default = "Select...",
	Callback = function(playerObj, playerName)
		print("Selected:", playerName, playerObj)
	end,
})

-- Massless Grab
local drag = ReplicatedFirst.GrabParts.DragPart
local orient = drag.AlignOrientation
local position = drag.AlignPosition

local scrollIncrement = 10
local dist = 10
local grabEnabled = false
local grabLoopRunning = false

local grabOriginal = {
	orient_MaxTorque = orient.MaxTorque,
	orient_Responsiveness = orient.Responsiveness,
	pos_MaxForce = position.MaxForce,
	pos_MaxAxesForce = position.MaxAxesForce,
	pos_Responsiveness = position.Responsiveness,
	pos_Mode = position.Mode,
}

local function grabApply()
	orient.MaxTorque = math.huge
	orient.Responsiveness = 200
	position.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
	position.MaxForce = math.huge
	position.Responsiveness = 200
	position.Mode = Enum.PositionAlignmentMode.OneAttachment
end

local function grabRestore()
	orient.MaxTorque = grabOriginal.orient_MaxTorque
	orient.Responsiveness = grabOriginal.orient_Responsiveness
	position.MaxForce = grabOriginal.pos_MaxForce
	position.MaxAxesForce = grabOriginal.pos_MaxAxesForce
	position.Responsiveness = grabOriginal.pos_Responsiveness
	position.Mode = grabOriginal.pos_Mode
end

local function grabUpdate()
	if not grabEnabled then
		return
	end
	if not workspace:FindFirstChild("GrabParts") then
		dist = 10
		return
	end
	workspace.GrabParts.DragPart.AlignPosition.Position = char.Head.Position
		+ (workspace.CurrentCamera.CFrame.LookVector.Unit * dist)
end

UserInputService.InputChanged:Connect(function(input)
	if not grabEnabled then
		return
	end
	if input.UserInputType == Enum.UserInputType.MouseWheel then
		if input.Position.Z > 0 then
			dist += scrollIncrement
		else
			dist -= scrollIncrement
		end
		if dist < 3 then
			dist = 3
		end
	end
end)

local function grabStartLoop()
	if grabLoopRunning then
		return
	end
	grabLoopRunning = true
	task.spawn(function()
		while grabLoopRunning do
			grabUpdate()
			task.wait()
		end
	end)
end

local function grabStopLoop()
	grabLoopRunning = false
end

combatSection:CreateToggle({
	Name = "Massless Grab",
	Default = false,
	Callback = function(state)
		grabEnabled = state
		if state then
			grabApply()
			grabStartLoop()
		else
			grabStopLoop()
			grabRestore()
		end
	end,
})

combatSection:CreateInput({
	Name = "Scroll Increment",
	Placeholder = "10",
	Default = "10",
	Callback = function(text)
		local num = tonumber(text)
		if num and num > 0 then
			scrollIncrement = num
		end
	end,
})

player.CharacterAdded:Connect(function(newChar)
	char = newChar
	newChar:WaitForChild("Head")
	if grabEnabled then
		grabApply()
	end
end)

-- Kill Grab
local ignoreNames = {
	Grass = true,
	LushGrass = true,
	WasteGrass = true,
}

local grabKillEnabled = false
local grabKillConnection

local function grabKillStart()
	if grabKillConnection then
		grabKillConnection:Disconnect()
	end

	grabKillConnection = workspace.ChildAdded:Connect(function()
		if not grabKillEnabled then
			return
		end

		local grabparts = workspace:FindFirstChild("GrabParts")
		if not grabparts then
			return
		end

		local grabPart = grabparts:FindFirstChild("GrabPart")
		if not grabPart then
			return
		end

		local weld = grabPart:FindFirstChild("WeldConstraint")
		if not weld or not weld.Part1 then
			return
		end

		local grabbed = weld.Part1.Parent
		if ignoreNames[grabbed.Name] then
			return
		end

		local hum = grabbed:FindFirstChildWhichIsA("Humanoid")
		if hum then
			task.wait(1.4)
			hum.Health = 0
		end
	end)
end

local function grabKillStop()
	if grabKillConnection then
		grabKillConnection:Disconnect()
		grabKillConnection = nil
	end
end

combatSection:CreateToggle({
	Name = "Kill Grab",
	Default = false,
	Callback = function(state)
		grabKillEnabled = state
		if state then
			grabKillStart()
		else
			grabKillStop()
		end
	end,
})

combatSection:CreateNote({
	Text = "May cause desyncs",
})

-- OP Kill Grab
local OPKillGrabEnabled = false
local OPKGConnections

local toX = 0
local toY = 1e+21
local toZ = 0

local function startOPKG()
	if OPKGConnections then
		OPKGConnections:Disconnect()
	end

	OPKGConnections = workspace.ChildAdded:Connect(function()
		if not OPKillGrabEnabled then
			return
		end

		local grabparts = workspace:FindFirstChild("GrabParts")
		if not grabparts or not grabparts:IsA("Model") then
			return
		end

		local grabPart = grabparts:FindFirstChild("GrabPart")
		if not grabPart then
			return
		end

		local weld = grabPart:FindFirstChild("WeldConstraint")
		if not weld or not weld.Part1 then
			return
		end

		local grabbed = weld.Part1.Parent
		if ignoreNames[grabbed.Name] then
			return
		end
		if not grabbed:IsA("Model") then
			return
		end

		local humanoid = grabbed:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			task.wait(0.1)

			local target = CFrame.new(toX, toY, toZ)

			grabbed:PivotTo(grabbed:PivotTo(grabbed:GetPivot():Lerp(target, 0.01)))
		else
			warn("No Humanoid!")
		end
	end)
end

local function stopOPKG()
	if OPKGConnections then
		OPKGConnections:Disconnect()
		OPKGConnections = nil
	end
end

combatSection:CreateToggle({
	Name = "OP Kill Grab",
	Default = false,
	Callback = function(state)
		OPKillGrabEnabled = state
		if state then
			startOPKG()
		else
			stopOPKG()
		end
	end,
})

combatSection:CreateNote({
	Text = "This may destroy the map if your target is grabbing the ground.",
})

combatSection:CreateNote({
	Text = "Turn Massless grab off before you use this for better results.",
})

combatSection:CreateInput({
	Name = "OP Kill grab X",
	Placeholder = tostring(toX),
	Default = tostring(toX),
	Callback = function(text)
		local num = tonumber(text)
		if num then
			toX = num
		end
	end,
})

combatSection:CreateInput({
	Name = "OP Kill grab Y",
	Placeholder = tostring(toY),
	Default = tostring(toY),
	Callback = function(text)
		local num = tonumber(text)
		if num then
			toY = num
		end
	end,
})

combatSection:CreateInput({
	Name = "OP Kill grab Z",
	Placeholder = tostring(toZ),
	Default = tostring(toZ),
	Callback = function(text)
		local num = tonumber(text)
		if num then
			toZ = num
		end
	end,
})

-- Antigrab
local antiGrabEnabled = false
local antiGrabConnection
local antiGrabThread

local function delayedReturn(originalPos, delay)
	local char = player.Character
	if not char then
		return
	end

	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	task.wait(delay)
	root.AssemblyLinearVelocity = Vector3.zero
	task.wait()
	char:MoveTo(originalPos)
	root.AssemblyLinearVelocity = Vector3.zero
end

local function startAntiGrab()
	-- Listener for GrabParts appearing
	antiGrabConnection = workspace.DescendantAdded:Connect(function(desc)
		if not antiGrabEnabled then
			return
		end
		if desc.Name ~= "GrabParts" then
			return
		end

		local char = player.Character
		if not char then
			return
		end

		for _, v in ipairs(char:GetChildren()) do
			local grabPart = desc:FindFirstChild("GrabPart")
			if not grabPart then
				return
			end

			local weld = grabPart:FindFirstChild("WeldConstraint")
			if not weld or not weld.Part1 then
				return
			end

			if v == weld.Part1 then
				print("You've been grabbed")

				desc:Destroy()

				local events = game:GetService("ReplicatedStorage"):FindFirstChild("CharacterEvents")
				if events and events:FindFirstChild("Struggle") then
					events.Struggle:FireServer()
				end

				local root = char:FindFirstChild("HumanoidRootPart")
				if root then
					task.spawn(delayedReturn, root.Position, 1.5)
				end
			end
		end
	end)

	-- Thread that constantly resets IsHeld + HeldTimer
	antiGrabThread = task.spawn(function()
		while antiGrabEnabled do
			local plr = player
			if plr and plr:FindFirstChild("IsHeld") then
				plr.IsHeld.Value = false
			end
			if plr and plr:FindFirstChild("HeldTimer") then
				plr.HeldTimer.Value = 0
			end
			task.wait()
		end
	end)
end

local function stopAntiGrab()
	if antiGrabConnection then
		antiGrabConnection:Disconnect()
		antiGrabConnection = nil
	end

	antiGrabEnabled = false
end

combatSection:CreateToggle({
	Name = "Anti Grab",
	Default = false,
	Callback = function(state)
		antiGrabEnabled = state

		if state then
			startAntiGrab()
		else
			stopAntiGrab()
		end
	end,
})

-- Anti Explode
local antiExplodeEnabled = false
local function antiExplodeLoop()
	workspace.ChildAdded:Connect(function(expPart)
		if expPart:IsA("Part") and expPart.Name == "Part" and antiExplodeEnabled then
			local char = player.Character
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local rightArm = char:FindFirstChild("Right Arm")
				if hrp and rightArm and (expPart.Position - hrp.Position).Magnitude <= 20 then
					hrp.Anchored = true
					task.wait(0.01)
					while rightArm:FindFirstChild("RagdollLimbPart") and rightArm.RagdollLimbPart.CanCollide == true do
						task.wait(0.001)
					end
					hrp.Anchored = false
				end
			end
		end
	end)
end

combatSection:CreateToggle({
	Name = "Anti Explode",
	Default = false,
	Callback = function(state)
		antiExplodeEnabled = state
		if antiExplodeEnabled then
			task.spawn(antiExplodeLoop)
		end
	end,
})

----------------------------------------------------------------
-- VISUAL TAB
----------------------------------------------------------------
local shaderSection = VisualTab:CreateSection({ Name = "Shaders Section" })

-- Effects
local bloom = Instance.new("BloomEffect", camera)
bloom.Name = "RebornBloom"
bloom.Intensity = 1
bloom.Size = 25
bloom.Threshold = 2
bloom.Enabled = false

local colorCorrection = Instance.new("ColorCorrectionEffect", camera)
colorCorrection.Name = "RebornColorCorrection"
colorCorrection.Brightness = -0.05
colorCorrection.Contrast = 0.5
colorCorrection.Saturation = 0
colorCorrection.TintColor = Color3.fromRGB(255, 231, 231)
colorCorrection.Enabled = false

local depthOfField = Instance.new("DepthOfFieldEffect", camera)
depthOfField.Name = "RebornDepthOfField"
depthOfField.FarIntensity = 0.75
depthOfField.FocusDistance = 0.05
depthOfField.InFocusRadius = 50
depthOfField.NearIntensity = 0.75
depthOfField.Enabled = false

local sunrays = Instance.new("SunRaysEffect", camera)
sunrays.Name = "RebornSunrays"
sunrays.Intensity = 0.05
sunrays.Spread = 0.5
sunrays.Enabled = false

local originalTime = Lighting.ClockTime

shaderSection:CreateToggle({
	Name = "Shaders",
	Default = false,
	Callback = function(state)
		bloom.Enabled = state
		colorCorrection.Enabled = state
		depthOfField.Enabled = state
		sunrays.Enabled = state

		Lighting.ClockTime = state and 17.5 or originalTime

		if state then
			Window:Notify({
				Title = "Shaders Enabled",
				Content = "Cinematic lighting has been applied.",
				Duration = 3,
			})
		end
	end,
})

-- Cinematic Mode
local rebornGui = Window._gui
local hiddenGuis = {}
local coreGuiStates = {}

local coreGuiTypes = {
	Enum.CoreGuiType.All,
	Enum.CoreGuiType.Backpack,
	Enum.CoreGuiType.Chat,
	Enum.CoreGuiType.EmotesMenu,
	Enum.CoreGuiType.Health,
	Enum.CoreGuiType.PlayerList,
}

shaderSection:CreateToggle({
	Name = "Cinematic Mode",
	Default = false,
	Callback = function(state)
		if state then
			-- Hide PlayerGui
			for _, gui in ipairs(playerGui:GetChildren()) do
				if gui ~= rebornGui and gui:IsA("ScreenGui") then
					hiddenGuis[gui] = gui.Enabled
					gui.Enabled = false
				end
			end

			-- Hide CoreGui
			for _, cg in ipairs(coreGuiTypes) do
				local success, current = pcall(function()
					return StarterGui:GetCoreGuiEnabled(cg)
				end)
				if success then
					coreGuiStates[cg] = current
					StarterGui:SetCoreGuiEnabled(cg, false)
				end
			end
		else
			-- Restore PlayerGui
			for gui, wasEnabled in pairs(hiddenGuis) do
				if gui and gui.Parent == playerGui then
					gui.Enabled = wasEnabled
				end
			end
			hiddenGuis = {}

			-- Restore CoreGui
			for cg, wasEnabled in pairs(coreGuiStates) do
				StarterGui:SetCoreGuiEnabled(cg, wasEnabled)
			end
			coreGuiStates = {}
		end
	end,
})

-- Camera Settings
local cameraSection = VisualTab:CreateSection({ Name = "Camera Settings" })

cameraSection:CreateSlider({
	Name = "FOV",
	Default = 70,
	Step = 1,
	Min = 1,
	Max = 120,
	Callback = function(value)
		camera.FieldOfView = value
	end,
})

cameraSection:CreateToggle({
	Name = "Third Person",
	Default = false,
	Callback = function(state)
		if state then
			player.CameraMode = Enum.CameraMode.Classic
			player.CameraMaxZoomDistance = 100
		end
	end,
})

----------------------------------------------------------------
-- THEMES TAB
----------------------------------------------------------------
local themesSection = ThemesTab:CreateSection({ Name = "Themes" })

themesSection:CreateNote({
	Text = "Choose a theme below. The UI will update instantly.",
})

for themeName in pairs(Phoenix.Themes) do
	themesSection:CreateButton({
		Name = themeName,
		Callback = function()
			Window.Theme = Phoenix.Themes[themeName]
			Window:_applyTheme()
		end,
	})
end

----------------------------------------------------------------
-- INFORMATION TAB
----------------------------------------------------------------
local infoSection = InformationTab:CreateSection({ Name = "Information" })

infoSection:CreateNote({
	Text = "The keybind for toggling the UI is 'K'.",
})

infoSection:CreateNote({
	Text = "Phoenix is a free GUI Library made entirely by reborb (@rebornspy).",
})

infoSection:CreateNote({
	Text = "This build is very early in the development process, so expect bugs.",
})

----------------------------------------------------------------
-- TESTING TAB
----------------------------------------------------------------
local testingSection1 = TestingTab:CreateSection({ Name = "Section 1" })

testingSection1:CreateButton({
	Name = "Test Button",
	Callback = function()
		print("Button clicked!")
	end,
})

testingSection1:CreateToggle({
	Name = "Test Toggle",
	Default = false,
	Callback = function(value)
		print("Toggle state changed to:", value)
	end,
})

testingSection1:CreateSlider({
	Name = "Test Slider",
	Default = 50,
	Step = 1,
	Min = 0,
	Max = 100,
	Callback = function(value)
		print("Slider value changed to:", value)
	end,
})

testingSection1:CreateInput({
	Name = "Test Input",
	Placeholder = "Input...",
	Default = "",
	Callback = function(text)
		print("User typed:", text)
	end,
})

testingSection1:CreateNote({
	Text = "This is a test.",
})

testingSection1:CreateDropdown({
	Name = "Dropdown Test",
	Options = {
		"TwentyOneCharactersss",
		"Button2",
		"Button3",
		"Button4",
		"Button5",
		"Button6",
		"Button7",
		"Button8",
		"Button9",
		"Button10",
		"Button11",
		"Button12",
		"Button13",
		"Button14",
		"Button15",
		"Button16",
		"Button17",
		"Button18",
		"Button19",
		"Button20",
		"Button21",
		"Button22",
		"Button23",
		"Button24",
		"Button25",
	},
	Default = "Button1",
	Callback = function(option)
		print("Selected:", option)
	end,
})

local testingSection2 = TestingTab:CreateSection({ Name = "Section 2" })

testingSection2:CreateButton({
	Name = "Notification Test Button",
	Callback = function()
		Window:Notify({
			Title = "Test Notification",
			Content = "This is a test notification.",
			Duration = 2.5,
		})
	end,
})

local testingSection3 = TestingTab:CreateSection({ Name = "Section 3" })

testingSection3:CreateNote({
	Text = "This is a test.",
})

local testingSection4 = TestingTab:CreateSection({ Name = "Section 4" })

testingSection4:CreateNote({
	Text = "This is a test.",
})

local testingSection5 = TestingTab:CreateSection({ Name = "Section 5" })

testingSection5:CreateNote({
	Text = "This is a test.",
})

----------------------------------------------------------------
-- IMPORT/EXPORT TAB
----------------------------------------------------------------
local ExportSection = ImportExportTab:CreateSection({ Name = "Export" })

ExportSection:CreateButton({
	Name = "Export Config",
	Callback = function()
		Window:ExportConfig("Phoenix/Config_export.json")
	end,
})

local ImportSection = ImportExportTab:CreateSection({ Name = "Import" })

ImportSection:CreateButton({
	Name = "Import Config",
	Callback = function()
		Window:ImportConfig("Phoenix/Config_import.json")
	end,
})
