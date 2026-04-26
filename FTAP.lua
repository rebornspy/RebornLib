----------------------------------------------------------------
-- SERVICES & GLOBALS
----------------------------------------------------------------
local EncodingService = game:GetService("EncodingService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local TouchInputService = game:GetService("TouchInputService")
local repStorage = game:GetService("ReplicatedStorage")
local grabEvents = repStorage:WaitForChild("GrabEvents")
local charEvents = repStorage:WaitForChild("CharacterEvents")
local struggle = charEvents:FindFirstChild("Struggle")

local player = Players.LocalPlayer
local name = player.Name
local spawnedToys = workspace[name .. "SpawnedInToys"]
local workspace = game:GetService("Workspace")
local map = workspace:FindFirstChild("Map")
local baseGround = map:FindFirstChild("BaseGround")
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
player.CharacterAdded:Connect(function(character)
    hrp = char:WaitForChild("HumanoidRootPart")
end)
local humanoid = char:WaitForChild("Humanoid")

----------------------------------------------------------------
-- LOAD Phoenix & WINDOW SETUP
----------------------------------------------------------------
local Phoenix = loadstring(game:HttpGet("https://raw.githubusercontent.com/rebornspy/Phoenix/refs/heads/main/Phoenix.lua"))()

local Window = Phoenix:CreateWindow({
	Name = "Example Window",
	LoadingText = "Phoenix Script",
	BootTitle = "Boot Window",
	MainTitle = "Main Window",
	Theme = "Default",
	ToggleUiKey = K,
})

----------------------------------------------------------------
-- TABS
----------------------------------------------------------------
local MainTab = Window:CreateTab({ Name = "Main" })
local MovementTab = Window:CreateTab({ Name = "Movement" })
local AntiTab = Window:CreateTab({ Name = "Antis" })
local LineTab = Window:CreateTab({ Name = "Line Customization"})
local CombatTab = Window:CreateTab({ Name = "Combat Tab" })
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
	ConfigKey = "auto_print_state",
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
	ConfigKey = "walkspeed_value",
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
	ConfigKey = "tpwalk_state",
	Default = false,
	Callback = function(state)
		tpwalkEnabled = state
	end,
})

walkSection:CreateSlider({
	Name = "TPWalk Speed",
	ConfigKey = "tpwalk_value",
	Min = 0,
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
	ConfigKey = "noclip_state",
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
	if not mouseTPEnabled then
		return
	end

	local char = player.Character
	if not char then
		return
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local hitPos = getLookHit()

	hrp.CFrame = CFrame.new(hitPos + Vector3.new(0, 2.5, 0), hitPos + hrp.CFrame.LookVector)
end

walkSection:CreateToggle({
	Name = "Mouse TP",
	ConfigKey = "mousetp_state",
	Default = false,
	Callback = function(state)
		mouseTPEnabled = state
	end,
})

local function spawnPallet()
	local hrp = char:WaitForChild("HumanoidRootPart")
	return repStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
		"PalletLightBrown",
		CFrame.new(hrp.Position) * CFrame.Angles(-0.7351, 0.9028, 0.6173),
		Vector3.new(0, 0, 0)
	)
end

local stickParts = {
	alignPos = nil,
	attach = nil
}

local function addSticky(stick)
	local pallet = spawnedToys:FindFirstChild("PalletLightBrown")
	if not pallet then
		if stick == true then
			Window:Notify({
				Title = "Missing Pallet",
				Content = "Spawn a Pallet and try again!",
				Duration = 3,
			})
		end
	end
	if pallet then
		if not stickParts.alignPos then
			stickParts.alignPos = Instance.new("AlignPosition")
			stickParts.alignPos.Parent = pallet.SoundPart
			stickParts.alignPos.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
			stickParts.alignPos.MaxForce = math.huge
			stickParts.alignPos.Responsiveness = 200
		end
		if not stickParts.attach then
			stickParts.attach = Instance.new("Attachment")
			stickParts.attach.Parent = pallet.SoundPart
			stickParts.attach.Position = Vector3.new(0, 3.75, 0)
		end
		if stick == true then
			stickParts.alignPos.Attachment0 = hrp:WaitForChild("RootAttachment")
			stickParts.alignPos.Attachment1 = stickParts.attach
		else
			stickParts.alignPos.Attachment0 = nil
		end
	end
end

walkSection:CreateButton({
	Name = "Spawn Pallet",
	Callback = function()
		spawnPallet()
	end,
})

walkSection:CreateToggle({
	Name = "Stick to Pallet",
	ConfigKey = "stick_state",
	Default = false,
	Callback = function(state)
		addSticky(state)
		if state == false then
			stickParts.alignPos = nil
			stickParts.attach = nil
		end
	end,
})

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then
		return
	end
	if input.KeyCode == Enum.KeyCode.Z then
		mouseTP()
	end
end)

player.CharacterAdded:Connect(setupCharacter)
if player.Character then
	setupCharacter(player.Character)
end

-- Jump Settings
local jumpSection = MovementTab:CreateSection({ Name = "Jump Settings" })

jumpSection:CreateSlider({
	Name = "JumpPower",
	ConfigKey = "jp_value",
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
	ConfigKey = "infjump_state",
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
	ConfigKey = "grav_value",
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
-- ANTI TAB
----------------------------------------------------------------
local antiSection = AntiTab:CreateSection({ Name = "Antis" })

-- Antigrab
local antiGrabEnabled = false
local function antiGrabLoop()
	while antiGrabEnabled and task.wait() do
		if player:FindFirstChild("IsHeld") and player.IsHeld.Value == true then
			local char = player.Character
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				if hrp then
					hrp.Anchored = true
					while player.IsHeld.Value == true and antiGrabEnabled do
						struggle:FireServer(player)
						task.wait(0.001)
					end
					hrp.Anchored = false
				end
			end
		end
	end
end

antiSection:CreateToggle({
	Name = "Anti Grab",
	ConfigKey = "ag_state",
	Default = false,
	Callback = function(state)
		antiGrabEnabled = state
		if antiGrabEnabled then
			task.spawn(antiGrabLoop)
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

antiSection:CreateToggle({
	Name = "Anti Explode",
	ConfigKey = "antiexp_state",
	Default = false,
	Callback = function(state)
		antiExplodeEnabled = state
		if antiExplodeEnabled then
			task.spawn(antiExplodeLoop)
		end
	end,
})

-- Anti Input
local antiInputEn = false

local function antiInputLoop()
	local burger = spawnedToys:FindFirstChild("FoodHamburger")
	while antiInputEn do
		if not burger then
			Window:Notify({
				Title = "No burger!",
				Content = "Spawn a Burger and try again!",
				Duration = 3
			})
			return
		end
		for _ = 1, 1 do
			local args = {
				burger,
				char
			}
			burger
				:WaitForChild("HoldPart")
				:WaitForChild("HoldItemRemoteFunction")
				:InvokeServer(unpack(args))
			local args2 = {
				burger,
				CFrame.new(0, 1000, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
				vector.create(0, 100.52899932861328, 0)
			}
			burger
				:WaitForChild("HoldPart")
				:WaitForChild("DropItemRemoteFunction")
				:InvokeServer(unpack(args2))
		end
	end
end

antiSection:CreateButton({
	Name = "Delete EndGrabEarly remote",
	Callback = function()
		local badRemote = grabEvents:WaitForChild("EndGrabEarly")
		badRemote:Destroy()
	end,
})

antiSection:CreateButton({
	Name = "Restore EndGrabEarly remote",
	Callback = function()
		if not grabEvents:FindFirstChild("EndGrabEarly") then
			local newRemote = Instance.new("RemoteEvent")
			newRemote.Name = "EndGrabEarly"
			newRemote.Parent = grabEvents
		end
	end,
})

antiSection:CreateToggle({
	Name = "Anti Input",
	ConfigKey = "ai_state",
	Default = false,
	Callback = function(state)
		antiInputEn = state
		if antiInputEn then
			task.spawn(antiInputLoop)
		end
	end,
})

----------------------------------------------------------------
-- LINE TAB
----------------------------------------------------------------
local lineSection = LineTab:CreateSection({ Name = "Line Settings"})

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
}

local function grabApply()
	orient.MaxTorque = math.huge
	orient.Responsiveness = 200
	position.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
	position.MaxForce = math.huge
	position.Responsiveness = 200
end

local function grabRestore()
	orient.MaxTorque = grabOriginal.orient_MaxTorque
	orient.Responsiveness = grabOriginal.orient_Responsiveness
	position.MaxForce = grabOriginal.pos_MaxForce
	position.MaxAxesForce = grabOriginal.pos_MaxAxesForce
	position.Responsiveness = grabOriginal.pos_Responsiveness
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

lineSection:CreateToggle({
	Name = "Further Extend",
	Default = false,
	ConfigKey = "massless_state",
	Callback = function(state)
		grabEnabled = state
		if state then
			position.Mode = Enum.PositionAlignmentMode.OneAttachment
			grabStartLoop()
		else
			grabStopLoop()
			position.Mode = Enum.PositionAlignmentMode.TwoAttachment
		end
	end,
})

lineSection:CreateToggle({
	Name = "Massless Grab",
	Default = false,
	ConfigKey = "massless_state",
	Callback = function(state)
		grabEnabled = state
		if state then
			grabApply()
		else
			grabRestore()
		end
	end,
})

lineSection:CreateInput({
	Name = "Scroll Increment",
	ConfigKey = "massless_value",
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

-- Lag
local lagEnabled = false
local lagIntensity = 5
local function lagLoop()
	while lagEnabled do
		for _ = 1, lagIntensity do
			for _, plrs in ipairs(Players:GetPlayers()) do
				if plrs ~= player then
					if plrs.Character and plrs.Character:FindFirstChild("Torso") then
						repStorage.GrabEvents.CreateGrabLine:FireServer(
							plrs.Character.Torso,
							plrs.Character.Torso.CFrame
						)
					end
				end
			end
		end
		task.wait(1)
	end
end

lineSection:CreateToggle({
	Name = "Lag",
	ConfigKey = "lag_state",
	Default = false,
	Callback = function(state)
		lagEnabled = state
		if lagEnabled then
			task.spawn(lagLoop)
		end
	end,
})

lineSection:CreateSlider({
	Name = "Lag Intensity",
	ConfigKey = "lagintesne_val",
	Min = 1,
	Max = 1000,
	Default = 5,
	Callback = function(val)
		lagIntensity = val
	end,
})

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
			task.wait(0.1)
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

lineSection:CreateToggle({
	Name = "Kill Grab",
	ConfigKey = "killgrab_state",
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

lineSection:CreateNote({
	Text = "May cause desyncs",
})

-- Noclip Grab
local ncGrab = false

local NCIgnoreNames = {}

for _, child in pairs(baseGround:GetChildren()) do
	if child:IsA("BasePart") then
		NCIgnoreNames[child.Name] = true
	end
end

workspace.ChildAdded:Connect(function()
	if not ncGrab then return end

	local grabparts = workspace:FindFirstChild("GrabParts")
	if not grabparts then return end
	if not grabparts:IsA("Model") then return end

	local grabPart = grabparts:FindFirstChild("GrabPart")
	if not grabPart then return end

	local weld = grabPart:FindFirstChild("WeldConstraint")
	if not weld or not weld.Part1 then return end

	local grabbed = weld.Part1.Parent

	for _, descendant in pairs(grabbed:GetDescendants()) do
		if descendant:IsA("BasePart") or descendant:IsA("Part") then
			if not NCIgnoreNames[descendant.Name] then
				descendant.CanCollide = false
			end
		end
	end
end)

lineSection:CreateToggle({
	Name = "Noclip Grab",
	ConfigKey = "ncgrab_state",
	Default = false,
	Callback = function(state)
		ncGrab = state
	end,
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

lineSection:CreateToggle({
	Name = "OP Kill Grab",
	ConfigKey = "opkg_state",
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

lineSection:CreateNote({
	Text = "This may destroy the map if your target is grabbing the ground.",
})

lineSection:CreateNote({
	Text = "Turn Massless grab off before you use this for better results.",
})

lineSection:CreateInput({
	Name = "OP Kill grab X",
	ConfigKey = "opkg_x_value",
	Placeholder = tostring(toX),
	Default = tostring(toX),
	Callback = function(text)
		local num = tonumber(text)
		if num then
			toX = num
		end
	end,
})

lineSection:CreateInput({
	Name = "OP Kill grab Y",
	ConfigKey = "opkg_y_val",
	Placeholder = tostring(toY),
	Default = tostring(toY),
	Callback = function(text)
		local num = tonumber(text)
		if num then
			toY = num
		end
	end,
})

lineSection:CreateInput({
	Name = "OP Kill grab Z",
	ConfigKey = "opkg_x_val",
	Placeholder = tostring(toZ),
	Default = tostring(toZ),
	Callback = function(text)
		local num = tonumber(text)
		if num then
			toZ = num
		end
	end,
})

local function createConstraintsFor(model)
    local main = model.Main

    local attach = Instance.new("Attachment", main)

    local alignPos = Instance.new("AlignPosition", main)
    alignPos.MaxForce = math.huge
    alignPos.MaxAxesForce = Vector3.new(math.huge, math.huge, math.huge)
    alignPos.Responsiveness = 200

    local alignOri = Instance.new("AlignOrientation", main)
    alignOri.MaxTorque = math.huge
    alignOri.Responsiveness = 200

    return {
        model = model,
        part = main,
        attach = attach,
        alignPos = alignPos,
        alignOri = alignOri
    }
end


local function weldParts(bundleA, bundleB)
    local partA = bundleA.part
    local partB = bundleB.part

    local offset = partA.CFrame:ToObjectSpace(partB.CFrame)

	bundleA.attach.CFrame = CFrame.new()
	bundleB.attach.CFrame = offset

    bundleA.alignPos.Attachment0 = bundleA.attach
    bundleA.alignPos.Attachment1 = bundleB.attach

    bundleA.alignOri.Attachment0 = bundleA.attach
    bundleA.alignOri.Attachment1 = bundleB.attach
end


local insertGrab = false
local processed = {}
local processedLookup = {}


local function applyInsertGrab(model)
    if processedLookup[model] then return end

    local bundle = createConstraintsFor(model)

    processedLookup[model] = true
    table.insert(processed, bundle)

    print("Collected:", model)

    model.AncestryChanged:Connect(function(_, parent)
        if parent == nil then
            processedLookup[model] = nil

            for i, entry in ipairs(processed) do
                if entry.model == model then
                    table.remove(processed, i)
                    break
                end
            end

            print("Removed processed object:", model)
        end
    end)
end


workspace.ChildAdded:Connect(function()
    if not insertGrab then return end

    local grabparts = workspace:FindFirstChild("GrabParts")
    if not grabparts then return end

    local grabPart = grabparts:FindFirstChild("GrabPart")
    if not grabPart then return end

    local weld = grabPart:FindFirstChild("WeldConstraint")
    if not weld or not weld.Part1 then return end

    local grabbedModel = weld.Part1.Parent

    applyInsertGrab(grabbedModel)
end)

local function unweldAll()
    for _, bundle in ipairs(processed) do
        if bundle.attach then
			bundle.attach:Destroy()
		end
        if bundle.alignPos then
			bundle.alignPos:Destroy()
		end
        if bundle.alignOri then
			bundle.alignOri:Destroy()
		end
    end

    table.clear(processed)
    table.clear(processedLookup)

    print("All welds removed and processed list cleared")
end

lineSection:CreateToggle({
	Name = "Insert Grab",
	ConfigKey = "insert_state",
	Default = false,
	Callback = function(state)
		insertGrab = state
	end,
})

lineSection:CreateButton({
    Name = "Weld All",
    Callback = function()
        if #processed < 2 then
            warn("Need at least 2 objects to weld")
            return
        end

        local anchor = processed[1]

        for i = 2, #processed do
            weldParts(processed[i], anchor)
        end

        print("Welded all objects to anchor:", anchor.model)
    end,
})

lineSection:CreateButton({
    Name = "Unweld All",
    Callback = function()
        unweldAll()
    end,
})

----------------------------------------------------------------
-- BLOBMAN TAB
----------------------------------------------------------------
local combatSection = CombatTab:CreateSection({ Name = "Combat Section" })

local PlayerSelect = combatSection:CreatePlayerDropdown({
	Name = "Players",
	Default = "Select...",
	Callback = function(playerObj, playerName)
	end,
})

local PlayerInput = combatSection:CreateInput({
	Name = "Player Name",
	Placeholder = "Player user...",
	Default = "",
	Callback = function(text)
		return text
	end,
})

local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")
local function createBlob()
	local spawnPos = hrp.Position + Vector3.new(13, 5, 0)
	return repStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
		"CreatureBlobman",
		CFrame.new(spawnPos) * CFrame.Angles(-0.7351, 0.9028, 0.6173),
		Vector3.new(0, 0, 0)
	)
end

local function noclipBlob()
	for _, part in pairs(workspace[name .. "SpawnedInToys"].CreatureBlobman:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end

local function grabTarget(target)
	local blobman = workspace[name .. "SpawnedInToys"].CreatureBlobman
	local targetChar = Players[target].Character
	local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	if blobman and targetChar then
		local args = {
			blobman:WaitForChild("LeftDetector"),
			targetHrp,
			blobman:WaitForChild("LeftDetector"):WaitForChild("LeftWeld"),
		}
		blobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureGrab"):FireServer(unpack(args))
	end
end

local function bring(target, spawn, drop)
	if spawn == true then
		createBlob()
	end
	local blobman = workspace[name .. "SpawnedInToys"].CreatureBlobman
	if not blobman then
		return
	end
	local blobSeat = blobman and blobman:FindFirstChildWhichIsA("VehicleSeat")
	if blobSeat then
		blobSeat:Sit(hum)
		hrp.CFrame = blobSeat.CFrame + Vector3.new(0, 2, 0)
	end
	noclipBlob()
	local targetPlr = Players:FindFirstChild(target)
	if not targetPlr or not targetPlr.Character then
		return
	end

	local targetHRP = targetPlr.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP then
		return
	end

	local targetPos = targetHRP.Position

	local char = player.Character
	if not char then
		return
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	local ogPos = hrp.Position

	task.wait(0.1)
	hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, -10, 0))
	task.wait(0.1)
	hrp.Anchored = true
	task.wait(0.1)
	grabTarget(targetPlr.Name)
	task.wait(0.1)
	hrp.Anchored = false
	hrp.CFrame = CFrame.new(ogPos)
	if drop == true then
		task.wait(0.5)
		local args = {
			blobman:WaitForChild("LeftDetector"):WaitForChild("LeftWeld"),
		}
		blobman:WaitForChild("BlobmanSeatAndOwnerScript"):WaitForChild("CreatureDrop"):FireServer(unpack(args))
	end
end

combatSection:CreateButton({
	Name = "Bring selected player (no drop)",
	Callback = function()
		local selectedPlayerName = PlayerSelect:Get() or PlayerInput:Get()
		if selectedPlayerName and selectedPlayerName ~= "Select..." and selectedPlayerName ~= "Player user..." then
			bring(selectedPlayerName, true, false)
			Window:Notify({
				Title = "Bring Activated",
				Content = "Attempting to bring " .. selectedPlayerName .. " to you.",
				Duration = 3,
			})
		else
			Window:Notify({
				Title = "No Player Selected",
				Content = "Please select a player from the dropdown first.",
				Duration = 3,
			})
		end
	end,
})

combatSection:CreateButton({
	Name = "Bring selected player (drop after)",
	Callback = function()
		local selectedPlayerName = PlayerSelect:Get() or PlayerInput:Get()
		if selectedPlayerName and selectedPlayerName ~= "Select..." and selectedPlayerName ~= "Player user..." then
			bring(selectedPlayerName, true, true)
			Window:Notify({
				Title = "Bring Activated",
				Content = "Attempting to bring " .. selectedPlayerName .. " to you.",
				Duration = 3,
			})
		else
			Window:Notify({
				Title = "No Player Selected",
				Content = "Please select a player from the dropdown first.",
				Duration = 3,
			})
		end
	end,
})

combatSection:CreateButton({
	Name = "Bring without spawning (requires you to sit on blob",
	Callback = function()
		local selectedPlayerName = PlayerSelect:Get() or PlayerInput:Get()
		if selectedPlayerName and selectedPlayerName ~= "Select..." and selectedPlayerName ~= "Player user..." then
			bring(selectedPlayerName, false, false)
			Window:Notify({
				Title = "Bring Activated",
				Content = "Attempting to bring " .. selectedPlayerName .. " to you.",
				Duration = 3,
			})
		else
			Window:Notify({
				Title = "No Player Selected",
				Content = "Please select a player from the dropdown first.",
				Duration = 3,
			})
		end
	end,
})

-- Glitch Blobman
local function createClone()
	local spawnPos = hrp.Position + Vector3.new(13, 5, 0)
	return repStorage.MenuToys.SpawnToyRemoteFunction:InvokeServer(
		"YouDecoy",
		CFrame.new(spawnPos) * CFrame.Angles(-0.7351, 0.9028, 0.6173),
		Vector3.new(0, 0, 0)
	)
end

local function glitchBlobman()
	createBlob()
	noclipBlob()
	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	local blobman = workspace[name .. "SpawnedInToys"].CreatureBlobman
	local blobSeat = blobman and blobman:FindFirstChildWhichIsA("VehicleSeat")
	if blobSeat then
		blobSeat:Sit(humanoid)
		hrp.CFrame = blobSeat.CFrame + Vector3.new(0, 2, 0)
	end
	createClone()
	local clone = workspace[name .. "SpawnedInToys"].YouDecoy
	if clone then
		local args = {
			workspace
				:WaitForChild(name .. "SpawnedInToys")
				:WaitForChild("CreatureBlobman")
				:WaitForChild("LeftDetector"),
			workspace:WaitForChild(name .. "SpawnedInToys"):WaitForChild("YouDecoy"):WaitForChild("HumanoidRootPart"),
			workspace
				:WaitForChild(name .. "SpawnedInToys")
				:WaitForChild("CreatureBlobman")
				:WaitForChild("LeftDetector")
				:WaitForChild("LeftWeld"),
		}
		workspace
			:WaitForChild(name .. "SpawnedInToys")
			:WaitForChild("CreatureBlobman")
			:WaitForChild("BlobmanSeatAndOwnerScript")
			:WaitForChild("CreatureGrab")
			:FireServer(unpack(args))
	end
	local leftDetector = blobman:FindFirstChild("LeftDetector")
	local leftWeld = leftDetector:FindFirstChild("LeftWeld")
	repeat
		task.wait()
	until leftWeld.Attachment0 ~= nil
	local args2 = {
		workspace:WaitForChild(name .. "SpawnedInToys"):WaitForChild("YouDecoy"),
	}
	game:GetService("ReplicatedStorage"):WaitForChild("MenuToys"):WaitForChild("DestroyToy"):FireServer(unpack(args2))
end

combatSection:CreateButton({
	Name = "Glitch Blobman",
	Callback = function()
		Window:Notify({
			Title = "Glitching Blobman",
			Content = "Attempting to glitch Blobman. This may take a few seconds.",
			Duration = 3,
		})
		glitchBlobman()
	end,
})

local function netOwnTarget(target)
	local targetPlr = Players:FindFirstChild(target)
	local targetChar = targetPlr.Character
	local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
	local targetHrpPos = targetHrp.CFrame
	local args = {
		targetHrp,
		targetHrpPos
	}
	grabEvents
		:WaitForChild("SetNetworkOwner")
		:FireServer(unpack(args))
end

local function dropTarget(target)
	local targetPlr = Players:FindFirstChild(target)
	local targetChar = targetPlr.Character
	local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
	local args = {
		targetHrp
	}
	grabEvents
		:WaitForChild("DestroyGrabLine")
		:FireServer(unpack(args))
end

local function killTarget(target)
	local targetPlr = Players:FindFirstChild(target)
	if not targetPlr then return end

	local targetChar = targetPlr.Character or targetPlr.CharacterAdded:Wait()
	if not targetChar then return end

	local targetHum = targetChar:WaitForChild("Humanoid")
	if not targetHum then return end

	local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHrp then return end

	local targetPos = targetHrp.Position + Vector3.new(0, -10, 0)

	local ogPos = hrp.Position

	hrp.CFrame = CFrame.new(targetPos)
    task.wait(0.1)
	hrp.Anchored = true
    task.wait(0.1)
	netOwnTarget(targetPlr.Name)
    task.wait(0.1)
	targetHum.Health = 0
    task.wait(0.1)
	dropTarget(targetPlr.Name)
	hrp.Anchored = false
	hrp.CFrame = CFrame.new(ogPos)
end

local loopKillEn = false
local loopKillConn = nil

local function loopKill(target)
	local targetPlr = Players:FindFirstChild(target)
	if not targetPlr then return end
    -- Disconnect old connection if it exists
    if loopKillConn then
        loopKillConn:Disconnect()
        loopKillConn = nil
    end

    if not loopKillEn then
        return
    end

    -- Connect ONCE
    loopKillConn = targetPlr.CharacterAdded:Connect(function(targetchar)
		killTarget(target)
    end)
end

combatSection:CreateToggle({
	Name = "Loopkill selected",
	ConfigKey = "loop_state",
	Default = false,
	Callback = function(state)
		local selectedPlayerName = PlayerSelect:Get()
		loopKillEn = state
		if state then
			if selectedPlayerName and selectedPlayerName ~= "Select..." then
				Window:Notify({
					Title = "Looping Player!",
					Content = "Now looping:" .. selectedPlayerName,
					Duration = 3
				})
				killTarget(selectedPlayerName)
				loopKill(selectedPlayerName)
			else
				Window:Notify({
					Title = "Select a player.",
					Content = "Please Select a player from the dropdown above and try again.",
					Duration = 3
				})
			end
		else
			if loopKillConn then
				loopKillConn:Disconnect()
				loopKillConn = nil
			end
		end
	end,
})

combatSection:CreateButton({
	Name = "Kill Selected",
	Callback = function()
		local selectedPlayerName = PlayerSelect:Get()
		if selectedPlayerName and selectedPlayerName ~= "Select..." then
			killTarget(selectedPlayerName)
		end
	end,
})

----------------------------------------------------------------
-- VISUAL TAB
----------------------------------------------------------------
local shaderSection = VisualTab:CreateSection({ Name = "Shaders Section" })

local shaderObjects = {
	bloom = nil,
	colorCorrection = nil,
	depthOfField = nil,
	sunrays = nil,
}

for _, obj in pairs(shaderObjects) do
	if obj then
		obj:Destroy()
	end
end

-- Effects
if not shaderObjects.bloom then
	shaderObjects.bloom = Instance.new("BloomEffect", camera)
	shaderObjects.bloom.Name = "RebornBloom"
	shaderObjects.bloom.Intensity = 1
	shaderObjects.bloom.Size = 25
	shaderObjects.bloom.Threshold = 2
	shaderObjects.bloom.Enabled = false
end
if not shaderObjects.colorCorrection then
	shaderObjects.colorCorrection = Instance.new("ColorCorrectionEffect", camera)
	shaderObjects.colorCorrection.Name = "RebornColorCorrection"
	shaderObjects.colorCorrection.Brightness = -0.05
	shaderObjects.colorCorrection.Contrast = 0.5
	shaderObjects.colorCorrection.Saturation = 0
	shaderObjects.colorCorrection.TintColor = Color3.fromRGB(255, 231, 231)
	shaderObjects.colorCorrection.Enabled = false
end
if not shaderObjects.depthOfField then
	shaderObjects.depthOfField = Instance.new("DepthOfFieldEffect", camera)
	shaderObjects.depthOfField.Name = "RebornDepthOfField"
	shaderObjects.depthOfField.FarIntensity = 0.75
	shaderObjects.depthOfField.FocusDistance = 0.05
	shaderObjects.depthOfField.InFocusRadius = 50
	shaderObjects.depthOfField.NearIntensity = 0.75
	shaderObjects.depthOfField.Enabled = false
end
if not shaderObjects.sunrays then
	shaderObjects.sunrays = Instance.new("SunRaysEffect", camera)
	shaderObjects.sunrays.Name = "RebornSunrays"
	shaderObjects.sunrays.Intensity = 0.05
	shaderObjects.sunrays.Spread = 0.5
	shaderObjects.sunrays.Enabled = false
end

local originalTime = Lighting.ClockTime

shaderSection:CreateToggle({
	Name = "Shaders",
	ConfigKey = "shader_state",
	Default = false,
	Callback = function(state)
		shaderObjects.bloom.Enabled = state
		shaderObjects.colorCorrection.Enabled = state
		shaderObjects.depthOfField.Enabled = state
		shaderObjects.sunrays.Enabled = state

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
	ConfigKey = "cinematic_state",
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
	ConfigKey = "fov_value",
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
	ConfigKey = "thirdp_state",
	Default = false,
	Callback = function(state)
		if state then
			player.CameraMode = Enum.CameraMode.Classic
			player.CameraMaxZoomDistance = 100
		end
	end,
})

local miscSection = VisualTab:CreateSection({ Name = "Misc" })

local charparts = {
	Head = true,
	Torso = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true
}

miscSection:CreateButton({
	Name = "Make character visible (client)",
	Callback = function()
		for _, desc in pairs(char:GetDescendants()) do
			if desc:IsA("BasePart") and charparts[desc.Name] then
				desc.Transparency = 0
				char.Hat1.Handle.Transparency = 0
			end
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
	ConfigKey = "1_toggle_ex",
	Default = false,
	Callback = function(value)
		print("Toggle state changed to:", value)
	end,
})

testingSection1:CreateSlider({
	Name = "Test Slider",
	ConfigKey = "1_slider_ex",
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
	ConfigKey = "1_input_ex",
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
	ConfigKey = "1_dropdown_ex",
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
