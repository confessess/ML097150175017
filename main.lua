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
}

debugLog("state initialized")

Main:Toggle({
	Name = "Enabled",
	Default = false,
	Callback = function(v)
		STATE.Enabled = v
		debugLog("Enabled = " .. tostring(v))
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
	end,
})

Combat:Toggle({
	Name = "Aimbot",
	Default = false,
})

Farm:Toggle({
	Name = "Auto Farm",
	Default = false,
	Callback = function(v)
		STATE.AutoFarm = v
		debugLog("AutoFarm = " .. tostring(v))
	end,
})

Teleports:Dropdown({
	Name = "Teleport To",
	Options = { "Spawn", "Lobby", "Arena", "Shop", "Boss" },
	Default = "Spawn",
	Callback = function(v)
		STATE.TeleportTarget = v
		debugLog("TeleportTarget = " .. tostring(v))
	end,
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
	Content = "Stage 1 boot successful.",
	Type = "Success",
	Duration = 2,
})

debugLog("stage 1 complete")
