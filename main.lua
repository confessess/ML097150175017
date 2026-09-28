-- Stage 1: AirFlow UI bootstrap debug shell
-- This file intentionally does NOT modify the original script.
-- We are building the replacement in stages.

local function debugLog(message)
	message = tostring(message)
	print("[musclelegends stage1] " .. message)
	if getgenv and getgenv() then
		local env = getgenv()
		env.__ML_DEBUG = env.__ML_DEBUG or {}
		table.insert(env.__ML_DEBUG, message)
	end
end

local function createFallbackTab()
	local tab = {}
	local function makeControl(defaultValue)
		local value = defaultValue
		return {
			Set = function(_, newValue)
				value = newValue
			end,
			Get = function()
				return value
			end,
		}
	end

	function tab:Toggle(options)
		return makeControl(options and options.Default == true or false)
	end
	function tab:Slider(options)
		return makeControl(options and options.Default or 0)
	end
	function tab:Dropdown(options)
		return makeControl(options and options.Default or nil)
	end
	function tab:Input(options)
		return makeControl(options and tostring(options.Default or "") or "")
	end
	function tab:Keybind(options)
		return makeControl(options and options.Default or Enum.KeyCode.RightControl)
	end
	function tab:Button() return {} end
	function tab:Section() return {} end
	function tab:Divider() return {} end
	function tab:Label() return {} end
	function tab:Paragraph() return {} end
	function tab:Progress() return {} end
	return tab
end

local function createFallbackWindow()
	local window = {}
	function window:Tab(options)
		return createFallbackTab(options)
	end
	function window:Toggle() end
	function window:Notify() end
	function window:Dialog() end
	return window
end

local AirFlow = nil
local function safeLoadAirFlow()
	debugLog("loading AirFlow")
	local loader = loadstring
	if type(loader) ~= "function" then
		debugLog("loadstring is nil")
		return nil
	end

	local ok, result = pcall(function()
		return loader(game:HttpGet("https://raw.githubusercontent.com/confessess/AIRFLOW0978109571095710975/main/source.lua"))()
	end)

	if not ok then
		debugLog("AirFlow load failed: " .. tostring(result))
		return nil
	end

	if type(result) ~= "table" then
		debugLog("AirFlow result is not a table: " .. type(result))
		return nil
	end

	debugLog("AirFlow loaded successfully")
	return result
end

AirFlow = safeLoadAirFlow()
if type(AirFlow) ~= "table" then
	debugLog("using fallback UI")
	AirFlow = {
		CreateWindow = createFallbackWindow,
		Window = createFallbackWindow,
		Notify = function() end,
		Confirm = function() end,
		Dialog = function() end,
	}
end

local function safeUiWindow(spec)
	if type(AirFlow) ~= "table" then
		debugLog("AirFlow table missing; fallback window")
		return createFallbackWindow()
	end

	local createWindow = AirFlow.CreateWindow or AirFlow.Window or AirFlow.Create
	if type(createWindow) ~= "function" then
		debugLog("CreateWindow missing; fallback window")
		return createFallbackWindow()
	end

	local ok, window = pcall(createWindow, spec)
	if ok and type(window) == "table" then
		debugLog("window created")
		return window
	end

	debugLog("window creation failed: " .. tostring(window))
	return createFallbackWindow()
end

local function safeUiTab(window, spec)
	if type(window) ~= "table" then
		debugLog("tab target is nil; fallback tab")
		return createFallbackTab()
	end

	local tabMethod = window.Tab or window.CreateTab or window.AddTab
	if type(tabMethod) ~= "function" then
		debugLog("Tab method missing; fallback tab")
		return createFallbackTab()
	end

	local ok, tab = pcall(tabMethod, window, spec)
	if ok and type(tab) == "table" then
		debugLog("tab created: " .. tostring(spec and spec.Name or "unnamed"))
		return tab
	end

	debugLog("tab creation failed: " .. tostring(tab))
	return createFallbackTab()
end

local function safeUiNotify(window, spec)
	if type(window) ~= "table" then
		return
	end
	if type(window.Notify) ~= "function" then
		return
	end
	pcall(window.Notify, window, spec)
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local StatsService = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")

local LP = Players.LocalPlayer
local PlayerGui = LP and LP:FindFirstChild("PlayerGui") or nil
local Env = getgenv and getgenv() or _G

if not LP then
	debugLog("LocalPlayer missing")
	return
end

if not PlayerGui then
	debugLog("PlayerGui missing; waiting for it")
	PlayerGui = LP:WaitForChild("PlayerGui")
end

-- AirFlow UI shell
local UI = safeUiWindow({
	Name = "Airflow",
	Title = "Muscle Legends",
	Subtitle = "Stage 1",
	ToggleUIKeybind = Enum.KeyCode.RightControl,
	Size = UDim2.fromOffset(760, 520),
})

local Main = safeUiTab(UI, { Name = "Main", Icon = "house", Desc = "Core settings" })
local Combat = safeUiTab(UI, { Name = "Combat", Icon = "sword", Desc = "Combat" })
local Farm = safeUiTab(UI, { Name = "Farm", Icon = "tractor", Desc = "Automation" })
local Teleports = safeUiTab(UI, { Name = "Teleports", Icon = "map-pin", Desc = "Travel" })
local Misc = safeUiTab(UI, { Name = "Misc", Icon = "sparkles", Desc = "Utility" })

local STATE = {
	Enabled = false,
	AutoFarm = false,
	WalkSpeed = 100,
	JumpPower = 50,
	TeleportTarget = "Spawn",
	SelectedMode = "Normal",
	InfiniteJump = false,
	NoClip = false,
}

debugLog("state initialized")

local function getCharacter()
	if LP and LP.Character then
		return LP.Character
	end
	return nil
end

local function getHumanoid()
	local character = getCharacter()
	if not character then
		return nil
	end
	return character:FindFirstChildOfClass("Humanoid")
end

local function applyMovement()
	local humanoid = getHumanoid()
	if not humanoid then
		return
	end

	if STATE.Enabled then
		humanoid.WalkSpeed = STATE.WalkSpeed
		humanoid.JumpPower = STATE.JumpPower
	else
		humanoid.WalkSpeed = 16
		humanoid.JumpPower = 50
	end
end

local function applyMode(mode)
	local presets = {
		Normal = { WalkSpeed = 100, JumpPower = 50 },
		Fast = { WalkSpeed = 180, JumpPower = 65 },
		AFK = { WalkSpeed = 80, JumpPower = 65 },
		Chill = { WalkSpeed = 55, JumpPower = 45 },
	}

	local preset = presets[mode] or presets.Normal
	STATE.SelectedMode = mode
	STATE.WalkSpeed = preset.WalkSpeed
	STATE.JumpPower = preset.JumpPower
	applyMovement()
	debugLog("preset applied: " .. tostring(mode))
end

local noClipParts = {}
local function setNoClip(enabled)
	STATE.NoClip = enabled == true
	if not STATE.NoClip then
		for part in pairs(noClipParts) do
			if part and part.Parent then
				part.CanCollide = true
			end
		end
		table.clear(noClipParts)
		debugLog("NoClip disabled")
		return
	end

	local character = getCharacter()
	if not character then
		debugLog("NoClip requested but no character exists")
		return
	end

	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
			noClipParts[part] = true
		end
	end

	debugLog("NoClip enabled")
end

local infiniteJumpConnection = nil
local function setInfiniteJump(enabled)
	STATE.InfiniteJump = enabled == true
	if infiniteJumpConnection then
		infiniteJumpConnection:Disconnect()
		infiniteJumpConnection = nil
	end

	if not STATE.InfiniteJump then
		debugLog("InfiniteJump disabled")
		return
	end

	infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
		if not STATE.Enabled or not STATE.InfiniteJump then
			return
		end
		local humanoid = getHumanoid()
		if humanoid and humanoid.Health > 0 then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)

	debugLog("InfiniteJump enabled")
end

local movementRenderConnection = nil
local function ensureMovementLoop()
	if movementRenderConnection then
		return
	end

	movementRenderConnection = RunService.RenderStepped:Connect(function()
		if not STATE.Enabled then
			return
		end
		applyMovement()
	end)
end

Main:Toggle({
	Name = "Enabled",
	Default = false,
	Callback = function(v)
		STATE.Enabled = v == true
		debugLog("Enabled = " .. tostring(STATE.Enabled))
		applyMovement()
		if STATE.Enabled then
			ensureMovementLoop()
		else
			local humanoid = getHumanoid()
			if humanoid then
				humanoid.WalkSpeed = 16
				humanoid.JumpPower = 50
			end
		end
	end,
})

Main:Slider({
	Name = "Walk Speed",
	Min = 16,
	Max = 250,
	Default = 100,
	Step = 1,
	Callback = function(v)
		STATE.WalkSpeed = v
		debugLog("WalkSpeed = " .. tostring(v))
		applyMovement()
	end,
})

Main:Slider({
	Name = "Jump Power",
	Min = 30,
	Max = 200,
	Default = 50,
	Step = 1,
	Callback = function(v)
		STATE.JumpPower = v
		debugLog("JumpPower = " .. tostring(v))
		applyMovement()
	end,
})

Main:Dropdown({
	Name = "Mode",
	Options = { "Normal", "Fast", "AFK", "Chill" },
	Default = "Normal",
	Callback = function(v)
		if v then
			applyMode(v)
		end
	end,
})

Combat:Toggle({
	Name = "Aimbot",
	Default = false,
})

Combat:Toggle({
	Name = "Silent Aim",
	Default = false,
})

Combat:Slider({
	Name = "FOV",
	Min = 20,
	Max = 200,
	Default = 80,
	Step = 1,
})

Farm:Toggle({
	Name = "Auto Farm",
	Default = false,
	Callback = function(v)
		STATE.AutoFarm = v
		debugLog("AutoFarm = " .. tostring(v))
	end,
})

Farm:Slider({
	Name = "Farm Delay",
	Min = 0.1,
	Max = 5,
	Default = 1,
	Step = 0.1,
	Suffix = "s",
})

Farm:Dropdown({
	Name = "Farm Target",
	Options = { "Coins", "XP", "Kills", "Pets" },
	Default = "Coins",
})

Teleports:Dropdown({
	Name = "Teleport To",
	Options = { "Spawn", "Lobby", "Arena", "Shop", "Boss", "Premium Area" },
	Default = "Spawn",
	Callback = function(v)
		STATE.TeleportTarget = v
		debugLog("TeleportTarget = " .. tostring(v))
	end,
})

Misc:Toggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(v)
		setInfiniteJump(v)
	end,
})

Misc:Toggle({
	Name = "No Clip",
	Default = false,
	Callback = function(v)
		setNoClip(v)
	end,
})

Misc:Input({
	Name = "Custom command",
	Placeholder = "type here",
})

Misc:Keybind({
	Name = "Toggle UI",
	Default = Enum.KeyCode.RightControl,
	Callback = function()
		if type(UI) == "table" and type(UI.Toggle) == "function" then
			pcall(UI.Toggle, UI)
		end
	end,
})

safeUiNotify(UI, {
	Title = "Loaded",
	Content = "Stage 2 movement features active.",
	Type = "Success",
	Duration = 2,
})

applyMode("Normal")
debugLog("stage 2 ready")
