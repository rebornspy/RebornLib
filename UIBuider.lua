-- Load RebornLib
local RebornLib = require(game.ReplicatedStorage.RebornLibStudio)

-- Useful Globals/Services
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local userInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local playerGui = player:WaitForChild("PlayerGui")
local starterGui = game:GetService("StarterGui")
local UIS = game:GetService("UserInputService")

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

-- Create the main window
local Window = RebornLib:CreateWindow({
	Name = "cool ui",
	BootTitle = "UI thingy",
	MainTitle = "Other UI",
	Theme = "Default",
})

UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if Window._isBindingKey then return end

	if input.KeyCode == Enum.KeyCode.K then
		Window:ToggleUI()
	end
end)

-- Create tabs
local MainTab = Window:CreateTab({ Name = "Main" })
local MovementTab = Window:CreateTab({ Name = "Movement" })
local CombatTab = Window:CreateTab({ Name = "Combat" })
local VisualTab = Window:CreateTab({ Name = "Visual" })
local ThemesTab = Window:CreateTab({ Name = "Themes" })
local InformationTab = Window:CreateTab({ Name = "Information" })
local TestingTab = Window:CreateTab({ Name = "Testing" })

---------------------------------------------------------
-- MAIN TAB
---------------------------------------------------------

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

game:GetService("RunService").RenderStepped:Connect(function()
	if autoPrint then
		print("This is useless")
	end
end)

---------------------------------------------------------
-- MOVEMENT TAB
---------------------------------------------------------

local walkSection = MovementTab:CreateSection({ Name = "Walk Settings" })

walkSection:CreateSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 100,
	Default = 16,
	Step = 1,
	Callback = function(value)
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = value
		end
	end,
})

local tpwalkEnabled = false
local tpwalkSpeed = 1.5

walkSection:CreateToggle({
	Name = "TP Walk",
	Default = false,
	Callback = function(state)
		tpwalkEnabled = state
	end,
})

local tpwalkSpeedSlider = walkSection:CreateSlider({
	Name = "TPWalk Speed",
	Min = 0.5,
	Max = 5,
	Default = 1.5,
	Step = 0.05,
	Callback = function(value)
		tpwalkSpeed = value
	end,
})

local noclipEnabled = false

walkSection:CreateToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(state)
		noclipEnabled = state
	end,
})

local head = char:FindFirstChild("Head")
local torso = char:FindFirstChild("Torso")

local function setupCharacter(char)
	local humanoid = char:WaitForChild("Humanoid")

	runService.RenderStepped:Connect(function()
		-- TPWalk
		if tpwalkEnabled and humanoid and humanoid.MoveDirection.Magnitude > 0 then
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame += humanoid.MoveDirection * tpwalkSpeed
			end
		end

		-- Noclip
		if noclipEnabled then
			if head then head.CanCollide = false end
			if torso then torso.CanCollide = false end
		else
			if head then head.CanCollide = true end
			if torso then torso.CanCollide = true end
		end
	end)
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then
	setupCharacter(player.Character)
end

local jumpSection = MovementTab:CreateSection({ Name = "Jump Settings" })

jumpSection:CreateSlider({
	Name = "JumpPower",
	Min = -10,
	Max = 200,
	Default = 50,
	Step = 5,
	Callback = function(value)
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")
		hum.UseJumpPower = true
		if hum then
			hum.JumpPower = value
		end
	end,
})

local infiniteJumpEnabled = false

jumpSection:CreateToggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(state)
		infiniteJumpEnabled = state
	end,
})

userInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if not infiniteJumpEnabled then return end

	if input.KeyCode == Enum.KeyCode.Space then
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")

		if hum then
			hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

local gravitySlider = jumpSection:CreateSlider({
	Name = "Gravity",
	Min = 0,
	Max = 100,
	Default = 196.2,
	Step = 1,
	Callback = function(value)
		workspace.Gravity = value
	end,
})

jumpSection:CreateButton({
	Name = "Default Gravity",
	Callback = function()
		workspace.Gravity = 196.2
		gravitySlider:Set(196.2)
	end,
})

---------------------------------------------------------
-- COMBAT TAB
---------------------------------------------------------

local combatSection = CombatTab:CreateSection({ Name = "Suicide Section" })

combatSection:CreateButton({
	Name = "die",
	Callback = function()
		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")

		if hum then
			hum.Health = 0
		end
	end,
})

autoDie = false

combatSection:CreateToggle({
	Name = "Auto Die",
	Default = false,
	Callback = function(state)
		autoDie = state

		local player = game.Players.LocalPlayer
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:FindFirstChildOfClass("Humanoid")

		if state and hum then
			hum.Health = 0
		end
	end,
})

player.CharacterAdded:Connect(function(char)
	if autoDie then
		local human = char:WaitForChild("Humanoid")
		task.wait(0.5)
		human.Health = 0
	end
end)

local function getPlayerNames()
	local list = {}
	for _, plr in ipairs(game.Players:GetPlayers()) do
		table.insert(list, plr.Name)
	end
	return list
end

local playerDropdown = combatSection:CreateDropdown({
	Name = "Players",
	Options = getPlayerNames(),
	Default = "Select",
	Callback = function(selected)
		print("Selected player:", selected)
	end
})

game.Players.PlayerAdded:Connect(function()
	playerDropdown.Refresh(getPlayerNames())
end)

game.Players.PlayerRemoving:Connect(function()
	playerDropdown.Refresh(getPlayerNames())
end)

---------------------------------------------------------
-- VISUAL TAB
---------------------------------------------------------

local shaderSection = VisualTab:CreateSection({ Name = "Shaders Section" })

local bloom = Instance.new("BloomEffect")
bloom.Name = "RebornBloom"
bloom.Intensity = 1
bloom.Size = 25
bloom.Threshold = 2
bloom.Enabled = false
bloom.Parent = camera

local colorCorrection = Instance.new("ColorCorrectionEffect")
colorCorrection.Name = "RebornColorCorrection"
colorCorrection.Brightness = -0.05
colorCorrection.Contrast = 0.5
colorCorrection.Saturation = 0
colorCorrection.TintColor = Color3.fromRGB(255, 231, 231)
colorCorrection.Enabled = false
colorCorrection.Parent = camera

local depthOfField = Instance.new("DepthOfFieldEffect")
depthOfField.Name = "RebornDepthOfField"
depthOfField.FarIntensity = 0.75
depthOfField.FocusDistance = 0.05
depthOfField.InFocusRadius = 50
depthOfField.NearIntensity = 0.75
depthOfField.Enabled = false
depthOfField.Parent = camera

local sunrays = Instance.new("SunRaysEffect")
sunrays.Name = "RebornSunrays"
sunrays.Intensity = 0.05
sunrays.Spread = 0.5
sunrays.Enabled = false
sunrays.Parent = camera

local originalTime = Lighting.ClockTime

shaderSection:CreateToggle({
	Name = "Shaders",
	Default = false,
	Callback = function(state)
		bloom.Enabled = state
		colorCorrection.Enabled = state
		depthOfField.Enabled = state
		sunrays.Enabled = state

		if state then
			Lighting.ClockTime = 17.5
		else
			Lighting.ClockTime = originalTime
		end

		if state then
			Window:Notify({
				Title = "Shaders Enabled",
				Content = "Cinematic lighting has been applied.",
				Duration = 3
			})
		end
	end,
})

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
			for _, gui in ipairs(playerGui:GetChildren()) do
				if gui ~= rebornGui and gui:IsA("ScreenGui") then
					hiddenGuis[gui] = gui.Enabled
					gui.Enabled = false
				end
			end

			for _, cg in ipairs(coreGuiTypes) do
				local success, current = pcall(function()
					return starterGui:GetCoreGuiEnabled(cg)
				end)
				if success then
					coreGuiStates[cg] = current
					starterGui:SetCoreGuiEnabled(cg, false)
				end
			end
		else
			for gui, wasEnabled in pairs(hiddenGuis) do
				if gui and gui.Parent == playerGui then
					gui.Enabled = wasEnabled
				end
			end
			hiddenGuis = {}

			for cg, wasEnabled in pairs(coreGuiStates) do
				starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
			end
			coreGuiStates = {}
		end
	end,
})

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

---------------------------------------------------------
-- THEMES TAB
---------------------------------------------------------

local themesSection = ThemesTab:CreateSection({ Name = "Themes" })

themesSection:CreateNote({
	Text = "Choose a theme below. The UI will update instantly."
})

for themeName, _ in pairs(RebornLib.Themes) do
	themesSection:CreateButton({
		Name = themeName,
		Callback = function()
			Window.Theme = RebornLib.Themes[themeName]
			Window:_applyTheme()
		end
	})
end

---------------------------------------------------------
-- INFORMATION TAB
---------------------------------------------------------

local infoSection = InformationTab:CreateSection({ Name = "Information" })

infoSection:CreateNote({
	Text = "The keybind for toggling the UI is 'K'."
})

infoSection:CreateNote({
	Text = "RebornLib is a free GUI Library made entirely by reborb (@rebornspy)."
})

infoSection:CreateNote({
	Text = "This build is very early in the development process, so expect bugs."
})

---------------------------------------------------------
-- TESTING TAB
---------------------------------------------------------

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
	Callback = function(enabled)
		print("Toggle state changed to:", enabled)
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
	Text = "This is a test."
})

local dropdown = testingSection1:CreateDropdown({
	Name = "Dropdown Test",
	Options = {"TwentyOneCharactersss", "Button2", "Button3", "Button4", "Button5", "Button6", "Button7", "Button8", "Button9", "Button10", "Button11", "Button12", "Button13", "Button14", "Button15", "Button16", "Button17", "Button18", "Button19", "Button20", "Button21", "Button22", "Button23", "Button24", "Button25"},
	Default = "Button1",
	Callback = function(option)
		print("Selected:", option)
	end
})

local testingSection2 = TestingTab:CreateSection({ Name = "Section 2" })

testingSection2:CreateButton({
	Name = "Notification Test Button",
	Callback = function()
		Window:Notify({
			Title = "Test Notification",
			Content = "This is a test notification.",
			Duration = 2.5
		})
	end,
})

local testingSection3 = TestingTab:CreateSection({ Name = "Section 3" })

testingSection3:CreateNote({
	Text = "This is a test."
})

local testingSection4 = TestingTab:CreateSection({ Name = "Section 4" })

testingSection4:CreateNote({
	Text = "This is a test."
})

local testingSection5 = TestingTab:CreateSection({ Name = "Section 5" })

testingSection5:CreateNote({
	Text = "This is a test."
})
