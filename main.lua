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

debugLog("merging original boot config from attached script")

local Shared = ReplicatedStorage:FindFirstChild("shared")
local UltimateAttributes = {}
local GameUltimatesFolder

do
	local configFolder = Shared and Shared:FindFirstChild("config")
	local ultimateModule = configFolder and configFolder:FindFirstChild("UltimateAttributes")
	if ultimateModule and ultimateModule:IsA("ModuleScript") then
		local ok, values = pcall(require, ultimateModule)
		if ok and type(values) == "table" then
			UltimateAttributes = values
		end
	end
	local catalogs = Shared and Shared:FindFirstChild("catalogs")
	GameUltimatesFolder = catalogs and catalogs:FindFirstChild("gameUltimatesFolder")
end

do
	local persistentAntiAfk = Env.Young0xPersistentAntiAfk
	if type(persistentAntiAfk) == "table" and persistentAntiAfk.connection then
		pcall(persistentAntiAfk.connection.Disconnect, persistentAntiAfk.connection)
	end
	Env.Young0xPersistentAntiAfk = nil
end

local CONFIG = {
	Title = "puto young0x ojala se muera",
	Subtitle = "Jesús es el camino, la verdad y la vida",
	BackgroundAsset = "rbxassetid://13290244293",
	Reach = {
		(function(data)
			for index, value in ipairs(data) do data[index] = string.char(value - 17) end
			return table.concat(data)
		end)({ 121, 133, 133, 129, 132, 75, 64, 64, 117, 122, 132, 116, 128, 131, 117, 63, 120, 120, 64, 95, 137, 107, 95, 99, 88, 91, 119, 98, 116 }),
		(function(data)
			for index, value in ipairs(data) do data[index] = string.char(value - 17) end
			return table.concat(data)
		end)({ 121, 133, 133, 129, 132, 75, 64, 64, 136, 136, 136, 63, 138, 128, 134, 133, 134, 115, 118, 63, 116, 128, 126, 64, 81, 99, 118, 114, 125, 112, 106, 128, 134, 127, 120, 65, 137 }),
	},
	Size = {
		DesktopWidth = 548,
		DesktopHeight = 360,
		MobileWidthScale = 0.9,
		MobileHeightScale = 0.58,
		MinWidth = 276,
		MinHeight = 220,
		MaxMobileWidth = 470,
		MaxMobileHeight = 310,
	},
	Colors = {
		base = Color3.fromRGB(6, 8, 17),
		panel = Color3.fromRGB(11, 15, 27),
		row = Color3.fromRGB(19, 24, 39),
		rowHover = Color3.fromRGB(29, 37, 58),
		tab = Color3.fromRGB(13, 18, 31),
		tabOn = Color3.fromRGB(28, 39, 65),
		cyan = Color3.fromRGB(105, 205, 255),
		blue = Color3.fromRGB(159, 139, 246),
		green = Color3.fromRGB(126, 224, 175),
		yellow = Color3.fromRGB(238, 206, 111),
		orange = Color3.fromRGB(236, 159, 93),
		red = Color3.fromRGB(255, 55, 82),
		white = Color3.fromRGB(246, 248, 252),
		soft = Color3.fromRGB(225, 230, 239),
		dim = Color3.fromRGB(165, 174, 189),
		black = Color3.fromRGB(0, 0, 0),
	},
	Tabs = {
		{ "Dios Te ama ❤", 116 },
		{ "Info", 62 },
		{ "Main", 62 },
		{ "Fast Farm", 84 },
		{ "AFK 24/7", 82 },
		{ "Full Train", 92 },
		{ "Auto Farm", 88 },
		{ "Boss", 62 },
		{ "Pet Momentum", 106 },
		{ "Fast Glitch 100%", 120 },
		{ "Rebirths", 78 },
		{ "Kills", 62 },
		{ "Server Hop", 94 },
		{ "Pet Shop", 86 },
		{ "Inventario", 86 },
		{ "Fuse Machine", 100 },
		{ "Fast Trade", 88 },
		{ "Gifts", 60 },
		{ "Teleports", 84 },
		{ "Perfiles", 76 },
		{ "Stats", 62 },
		{ "Misc", 60 },
	},
	Rocks = {
		{ name = "Industrial Jungle Rock", label = "Industrial Rock", durability = 25000000 },
		{ name = "Ancient Rock", durability = 10000000 },
		{ name = "Muscle King Rock", durability = 5000000 },
		{ name = "Legend Rock", durability = 1000000 },
		{ name = "Eternal Rock", durability = 750000 },
		{ name = "Mythical Rock", durability = 400000 },
		{ name = "Frost Rock", durability = 150000 },
		{ name = "Beach Rock", durability = 5000 },
		{ name = "Starter Rock", durability = 100 },
		{ name = "Tiny Rock", durability = 0 },
	},
	Machines = {
		{ section = "Industrial Machines", label = "Industrial Bar Lift", object = "Industrial Bar Lift", fallback = CFrame.new(-5492.7051, 82.9405, 4643.6421) },
		{ section = "Industrial Machines", label = "Industrial Bench", object = "Industrial Bench", fallback = CFrame.new(-5014.7197, 101.4016, 4467.3472) },
		{ section = "Industrial Machines", label = "Industrial Boulder", object = "Industrial Boulder", fallback = CFrame.new(-5456.4297, 85.4802, 5231.5352) },
		{ section = "Industrial Machines", label = "Industrial Squat", object = "Industrial Squat", fallback = CFrame.new(-5422.1152, 76.9691, 5443.0771) },
		{ section = "Jungle Gym Machines", label = "Jungle Bar Lift", object = "Jungle Bar Lift", fallback = CFrame.new(-8652.8672, 29.2667, 2089.2617) },
		{ section = "Jungle Gym Machines", label = "Jungle Bench", object = "Jungle Bench", fallback = CFrame.new(-8174.8818, 47.7279, 1912.9667) },
		{ section = "Jungle Gym Machines", label = "Jungle Boulder", object = "Jungle Boulder", fallback = CFrame.new(-8616.5918, 31.8064, 2677.1548) },
		{ section = "Jungle Gym Machines", label = "Jungle Squat", object = "Jungle Squat", fallback = CFrame.new(-8377.2773, 34.8563, 2863.6965) },
		{ section = "Legends Gym Machines", label = "Legends Lift", object = "Legends Lift", fallback = CFrame.new(4532.2178, 1012.4910, -4002.7122) },
		{ section = "Legends Gym Machines", label = "Legends Press", object = "Legends Press", fallback = CFrame.new(4109.9131, 1012.2094, -3802.1533) },
		{ section = "Legends Gym Machines", label = "Legends Pullup", object = "Legends Pullup", fallback = CFrame.new(4510.2075, 999.8143, -3636.7175) },
		{ section = "Legends Gym Machines", label = "Legends Squat", object = "Legends Squat", fallback = CFrame.new(4439.7734, 1008.0662, -4058.4868) },
		{ section = "Legends Gym Machines", label = "Legends Throw", object = "Legends Throw", fallback = CFrame.new(4189.9614, 1004.3785, -3903.0166) },
		{ section = "Muscle King Machines", label = "Muscle King Lift", object = "Muscle King Lift", fallback = CFrame.new(-8772.9707, 39.1910, -5663.5625) },
		{ section = "Muscle King Machines", label = "Muscle King Bench", object = "Muscle King Bench", fallback = CFrame.new(-8590.2354, 37.7592, -6044.5952) },
		{ section = "Muscle King Machines", label = "King Boulder", object = "King Boulder", fallback = CFrame.new(-8942.1289, 43.7785, -5691.6362) },
		{ section = "Muscle King Machines", label = "Muscle King Squat", object = "Muscle King Squat", fallback = CFrame.new(-8758.4424, 32.8662, -6043.0693) },
	},
	FullTrainAreas = {
		{ section = "Eternal Gym", center = Vector3.new(-6768, 0, -1287) },
		{ section = "Mythical Gym", center = Vector3.new(2255, 0, 1071) },
		{ section = "Frost Gym", center = Vector3.new(-2650, 0, -393) },
		{ section = "Playa", center = Vector3.new(9, 0, 100) },
		{ section = "Magma Ring", center = Vector3.new(4400, 0, -8400) },
		{ section = "Desert Ring", center = Vector3.new(900, 0, -7000) },
		{ section = "Boxing Ring", center = Vector3.new(-1900, 0, -5820) },
		{ section = "Tiny Island", center = Vector3.new(50, 0, 1918) },
	},
	FullTrainMachines = {},
	Teleports = {
		{
			"Rip Glitch Pets",
			Vector3.new(-499.3, 3.15, -204.61),
			lookAt = Vector3.new(-507.07, 3.15, -204.61),
			utility = true,
		},
		{ "Industrial Gym", Vector3.new(-5165, 57, 4945) },
		{ "Jungle Gym", Vector3.new(-7894, 6, 2386) },
		{ "Muscle King", Vector3.new(-8799, 17, -5798) },
		{ "Legends Gym", Vector3.new(4429, 991, -3880) },
		{ "Eternal Gym", Vector3.new(-6768, 7, -1287) },
		{ "Mythical Gym", Vector3.new(2255, 7, 1071) },
		{ "Frost Gym", Vector3.new(-2650, 7, -393) },
		{ "Tiny Gym", Vector3.new(50, 7, 1918) },
		{ "Beach", Vector3.new(9, 7, 100) },
		{ "Boss Arena", Vector3.new(0, 5, -805) },
		{ "Boss Battle", Vector3.new(0, 18, -1080) },
		{ "Secret Area", Vector3.new(1947, 2, 6191) },
		{ "Desert Brawl", Vector3.new(960, 17, -7398) },
		{ "Lava Brawl", Vector3.new(4471, 119, -8836) },
	},
	UniqueAuras = { "Muscle King", "Entropic Blast" },
	UniquePets = {
		"Core Pup", "Volt Talon", "Reactor Beast",
		"Plasma Ravager", "Titan Reactor", "Apex Overlord",
		"Neon Guardian", "Cybernetic Showdown Dragon", "Darkstar Hunter",
		"Muscle Sensei", "Infernal Dragon", "Aether Spirit Bunny",
		"Magic Butterfly", "Ultra Birdie",
	},
	AutoEgg = {
		Interval = 30 * 60,
		Names = { "ProteinEgg", "Protein Egg" },
	},
	FastFarm = {
		Packs = {
			chaos = {
				label = "Señores del Caos",
				strength = { "Swift Samurai" },
				rebirth = "Tribal Overlord",
			},
			ultra = {
				label = "Ultra Titanes",
				strength = { "Powercore Hound", "Omega Overlord" },
				rebirth = "Titanium Hydra",
			},
		},
		StrengthMachine = "Industrial Bench",
		RebirthMachine = "Industrial Bar Lift",
		MaxPets = 9,
		RepsPerCycle = 48,
		RepDelay = 0.008,
		PingSoft = 180,
		PingMedium = 300,
		PingHigh = 600,
		PingCritical = 700,
		PingPause = 880,
		PingResume = 450,
		PingReducerPause = 860,
		PingReducerResume = 480,
		PingSampleInterval = 0.12,
		StrengthPingSoft = 400,
		StrengthPingMedium = 560,
		StrengthPingHigh = 720,
		StrengthPingCritical = 840,
		StrengthMinBatch = 26,
		StrengthStartBatch = 42,
		StrengthMaxBatch = 42,
		StrengthBackoffPing = 700,
		StrengthBackoffInterval = 0.35,
		StrengthRampPing = 450,
		StrengthRampInterval = 0.9,
		StrengthDelay = 0.05,
		SizeInvokeInterval = 0.75,
		SizeReleaseDuration = 5,
		FramesReleaseDuration = 10,
		RebirthCooldown = 6.0,
		RebirthSafetyMargin = 0.03,
		RebirthRepBatch = 6,
		RebirthPingRise = 100,
		RebirthPingPause = 800,
		RebirthStrengthBufferRatio = 0.03,
		RebirthCycleDelay = 0.2,
		RebirthRetryDelay = 0.02,
		RebirthRequestWindow = 0.75,
		RateCycle = 6.03,
	},
	ServerHop = {
		Interval = 50,
		LoaderUrl = "https://raw.githubusercontent.com/Young0xHUB/Young0x-HUB/refs/heads/main/loader.lua",
		ServerApi = "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100",
		PreferredPlayers = 18,
		MinimumPlayers = 12,
		NoTargetsDelay = 10,
		RetryDelay = 5,
		HistoryLimit = 60,
	},
	Kills = {
		ProtectedPrivateServerIds = {},
	},
}

local C = CONFIG.Colors
local UI_FONT = Enum.Font.FredokaOne

debugLog("original boot config merged")

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

Combat:Label({
	Text = "Combat features are being merged in stages. No placeholder aimbot or silent-aim controls are active.",
	Color = C.white,
})

Combat:Divider()

Combat:Label({
	Text = "Status: waiting for the exact Muscle Legends combat module integration.",
	Color = C.dim,
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

local ML = {}
ML.connections = {}
ML.threads = {}
ML.threadGenerations = {}
ML.cleanupActions = {}
ML.Controller = {}

ML.State = Env.__FGState or {
	running = true,
	shuttingDown = false,
	resume = type(Env.Young0xFG100Resume) == "table" and Env.Young0xFG100Resume or nil,
	fastPunch = false,
	fastPunchGeneration = 0,
	selectedRock = nil,
	rockGeneration = 0,
	rockSessionStartedAt = nil,
	rockVisualReadyAt = math.huge,
	autoWeight = false,
	autoHandstands = false,
	autoLift = false,
	autoSitups = false,
	autoLiftUnlocked = false,
	autoLiftNative = {
		button = nil,
		connection = nil,
		visualConnection = nil,
		disabledConnections = {},
		fallbackMarker = nil,
	},
	autoEgg = false,
	themeName = "Galaxia",
	afk = {
		active = false,
		mode = "Fast Rebirth",
		autoEgg = true,
		startedAt = nil,
	},
	exerciseMovement = {
		active = {},
		humanoid = nil,
		walkSpeed = nil,
		jumpValue = nil,
		usesJumpPower = true,
	},
	hideFrames = false,
	originalShowPopups = LP:GetAttribute("ShowPopups"),
	autoFarmMode = "Chill Rep",
	fullTrainMode = "Chill Rep",
	hideDurability = false,
	fastFarmMode = nil,
	machine = nil,
	autoPet = false,
	autoAura = false,
	antiLag = false,
	antiLagGeneration = 0,
	antiCrash = false,
	walkWater = false,
	autoSpinWheel = false,
	autoClaimChests = false,
	mainAutoSize = false,
	mainAutoSpeed = false,
	mainSize = 2,
	mainSpeed = 800,
	infiniteJump = false,
	removePortals = false,
	fastSpeed = false,
	fly = false,
	flyLevel = 10,
	antiKnockback = false,
	noclip = false,
	noclipBeachSurfaceY = nil,
	spin = false,
	spy = false,
	spyTarget = nil,
	kill = {
		auto = false,
		autoWinBrawl = false,
		brawlPhase = "IDLE",
		brawlBusy = false,
		brawlCombat = false,
		brawlJoined = false,
		brawlJoinSent = false,
		brawlChosen = nil,
		brawlBaselineWins = nil,
		brawlReturnCFrame = nil,
		brawlMovement = nil,
		karmaMode = nil,
		protectFriends = false,
		targetMode = false,
		target = nil,
		serverHop = false,
		serverHopInterval = CONFIG.ServerHop.Interval,
		serverHopMode = "full",
		hopOnDeath = false,
		avoidKillers = false,
		claimKing = true,
		serverCandidate = nil,
		friendCache = {},
		serverHistory = {},
		serversVisited = 1,
		hopNow = false,
		noTargetsSince = nil,
		lockCFrame = nil,
		lockCharacter = nil,
		killSessionActive = false,
		sessionKills = 0,
		sessionStartKills = nil,
		sessionLastTotal = nil,
		sessionElapsed = 0,
		sessionStartedAt = nil,
		friendProtectionReady = false,
		hopRetrying = false,
		hopInProgress = false,
		forceHopReason = nil,
		targetRetryAt = {},
		combatCFrame = nil,
		movementWalkSpeed = nil,
		lastObservedKills = nil,
		lastKillAt = os.clock(),
	},
	trade = {
		busy = false,
		requestGeneration = 0,
		delivered = 0,
		total = 0,
	},
	rebirth = {
		target = nil,
		autoTarget = false,
		infinite = false,
		sizeOne = false,
		fastWeight = false,
		autoLift = false,
		autoLiftStartedWeight = false,
		king = false,
		lockPosition = false,
		lockCFrame = nil,
		ultimateRunning = false,
	},
}
ML.State.allToggleControllers = {}
ML.State.profileControls = {}
ML.State.selectorControllers = {}
ML.State.outputEntries = ML.State.resume and type(ML.State.resume.outputEntries) == "table" and ML.State.resume.outputEntries or {}
ML.State.pushOutput = function(kind, message)
	local entry = {
		time = os.date("%H:%M:%S"),
		kind = tostring(kind or "INFO"),
		message = tostring(message or ""),
	}
	table.insert(ML.State.outputEntries, 1, entry)
	while #ML.State.outputEntries > 100 do table.remove(ML.State.outputEntries) end
	if type(ML.State.refreshOutput) == "function" then task.defer(ML.State.refreshOutput) end
	return entry
end

ML.track = function(connection)
	ML.connections[#ML.connections + 1] = connection
	return connection
end

ML.addCleanup = function(callback)
	ML.cleanupActions[#ML.cleanupActions + 1] = callback
end

ML.stopThread = function(key)
	ML.threadGenerations[key] = (ML.threadGenerations[key] or 0) + 1
	local thread = ML.threads[key]
	if thread then
		pcall(task.cancel, thread)
		ML.threads[key] = nil
	end
end

ML.startThread = function(key, callback)
	ML.stopThread(key)
	local generation = ML.threadGenerations[key]
	local thread
	thread = task.defer(function()
		local ok, err = pcall(callback)
		if not ok and ML.State.running then ML.State.pushOutput("ERROR", key .. ": " .. tostring(err):sub(1, 240)) end
		if ML.threadGenerations[key] == generation and ML.threads[key] == thread then
			ML.threads[key] = nil
		end
	end)
	ML.threads[key] = thread
	return ML.threads[key]
end

ML.disconnectAll = function()
	for _, connection in ipairs(ML.connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end
	table.clear(ML.connections)
	for key in pairs(ML.threads) do
		ML.stopThread(key)
	end
end

ML.getCharacter = function()
	return LP.Character
end

ML.getHumanoid = function()
	local character = ML.getCharacter()
	return character and character:FindFirstChildWhichIsA("Humanoid")
end

ML.getRoot = function()
	local character = ML.getCharacter()
	return character and character:FindFirstChild("HumanoidRootPart")
end

ML.findValue = function(root, names)
	if not root then
		return nil
	end
	for _, name in ipairs(names) do
		local wanted = name:lower():gsub("%s+", "")
		for _, child in ipairs(root:GetChildren()) do
			local key = child.Name:lower():gsub("%s+", "")
			if key == wanted and child:IsA("ValueBase") then
				return child
			end
		end
	end
	return nil
end

ML.getPlayerStat = function(player, names)
	local leaderstats = player and player:FindFirstChild("leaderstats")
	return ML.findValue(leaderstats, names) or ML.findValue(player, names)
end

ML.State.getFunctionalStatValue = function(valueObject)
	if not valueObject then return nil end
	local records = ML.State.visualStatRecords
	local record = records and records[valueObject]
	if record and record.realValue ~= nil then return record.realValue end
	return valueObject.Value
end

ML.State.protectedPetNameFallback = {
	["swift samurai"] = true,
	["tribal overlord"] = true,
}

ML.State.hasEnabledPetMarker = function(pet, name)
	local marker = pet and pet:FindFirstChild(name)
	if not marker then return false end
	if marker:IsA("BoolValue") then return marker.Value == true end
	return true
end

ML.State.isProtectedPetAsset = function(pet)
	if not pet or not pet.Parent or not pet:IsA("StringValue") then return true end
	if ML.State.protectedPetNameFallback[pet.Name:lower()] then return true end
	local categoryName = pet.Parent and pet.Parent.Name:lower() or ""
	if categoryName:find("robux", 1, true) or categoryName:find("pack", 1, true) then return true end
	local shared = ReplicatedStorage:FindFirstChild("shared")
	local runtime = shared and shared:FindFirstChild("runtime")
	local packCatalog = runtime and runtime:FindFirstChild("packPetPerks")
	if packCatalog and packCatalog:FindFirstChild(pet.Name) then return true end
	for _, marker in ipairs({ "packPet", "unsellable", "untradeable", "locked", "protected" }) do
		if ML.State.hasEnabledPetMarker(pet, marker) then return true end
	end
	for _, attribute in ipairs({ "PackPet", "RobuxPet", "Unsellable", "Untradeable", "Locked", "Protected" }) do
		if pet:GetAttribute(attribute) == true then return true end
	end
	return false
end

ML.formatExact = function(value)
	local number = tonumber(value) or 0
	local negative = number < 0
	local digits = string.format("%.0f", math.abs(number))
	local grouped = digits:reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
	return (negative and "-" or "") .. grouped
end

ML.State.antiAfkPulses = 0
ML.State.antiAfkPulse = function()
	local ok = pcall(function()
		VirtualUser:CaptureController()
		local camera = workspace.CurrentCamera
		local cameraCFrame = camera and camera.CFrame or CFrame.new()
		VirtualUser:Button2Down(Vector2.new(0, 0), cameraCFrame)
		task.wait(0.05)
		VirtualUser:Button2Up(Vector2.new(0, 0), cameraCFrame)
	end)
	if ok then
		ML.State.antiAfkPulses = ML.State.antiAfkPulses + 1
		ML.State.lastAntiAfkPulse = os.clock()
		ML.State.pushOutput("SYSTEM", "Anti-AFK responded correctly")
	end
	return ok
end
ML.State.antiAfkConnection = ML.track(LP.Idled:Connect(ML.State.antiAfkPulse))

Env.__FGState = ML.State

local rockCache = {}
rockCache.times = {}
rockCache.touch = type(firetouchinterest) == "function" and firetouchinterest
	or type(firetouchtransmitter) == "function" and firetouchtransmitter or nil
rockCache.touchBegin = 0
local activeRock = nil

ML.rockCache = rockCache
ML.activeRock = nil
ML.activeRockFarm = nil

local function releaseRockContacts(controller)
	local contacts = type(controller) == "table" and controller.contacts or nil
	if type(controller) == "table" then controller.contacts = nil end
	if not contacts or not rockCache.touch then return end
	for _, contact in ipairs(contacts) do
		if contact[1] and contact[1].Parent and contact[2] and contact[2].Parent then
			pcall(rockCache.touch, contact[1], contact[2], 1 - rockCache.touchBegin)
		end
	end
end

ML.releaseRockContacts = releaseRockContacts

local function clearActiveRock()
	ML.activeRock = nil
end

ML.clearActiveRock = clearActiveRock

local function stopActiveRockFarm()
	local previous = ML.activeRockFarm
	ML.activeRockFarm = nil
	if previous then
		previous.enabled = false
		if previous.thread then
			task.cancel(previous.thread)
			previous.thread = nil
		end
		releaseRockContacts(previous)
	end
	clearActiveRock()
end

ML.stopActiveRockFarm = stopActiveRockFarm

local function clearRockSelection()
	ML.State.rockGeneration = ML.State.rockGeneration + 1
	ML.State.selectedRock = nil
	ML.State.rockSessionStartedAt = nil
	ML.State.rockVisualReadyAt = math.huge
	stopActiveRockFarm()
end

ML.clearRockSelection = clearRockSelection

local function findRock(definition)
	if type(definition) ~= "table" then return nil end
	local cacheKey = definition.durability
	local cached = rockCache[cacheKey]
	if cached and cached:IsDescendantOf(workspace) then
		return cached
	end
	if os.clock() - (rockCache.times[cacheKey] or -math.huge) < 1 then return nil end
	rockCache.times[cacheKey] = os.clock()
	rockCache[cacheKey] = nil
	local machinesFolder = workspace:FindFirstChild("machinesFolder")
	if not machinesFolder then return nil end
	for _, model in ipairs(machinesFolder:GetChildren()) do
		local marker = model:FindFirstChild("neededDurability")
		local rock = model:FindFirstChild("Rock")
		if marker and marker:IsA("ValueBase") and tonumber(marker.Value) == definition.durability
			and rock and rock:IsA("BasePart") then
			rockCache[cacheKey] = rock
			return rock
		end
	end
	return nil
end

ML.findRock = findRock

local function rockFarmIsCurrent(controller)
	return controller and controller.enabled and ML.activeRockFarm == controller
		and ML.State.running and ML.State.fastPunch and ML.State.rockGeneration == controller.generation
		and ML.State.selectedRock == controller.definition
end

ML.rockFarmIsCurrent = rockFarmIsCurrent

local function runRockFarm(controller)
	while rockFarmIsCurrent(controller) do
		if ML.State.fastPunchToolPaused then
			releaseRockContacts(controller)
			task.wait(0.04)
		else
			local ok = pcall(function()
				if not rockFarmIsCurrent(controller) then return end
				local definition = controller.definition
				local durability = LP:FindFirstChild("Durability")
				if durability and (tonumber(ML.State.getFunctionalStatValue(durability)) or 0) < definition.durability then return end
				local character = ML.getCharacter()
				local leftHand = character and (character:FindFirstChild("LeftHand") or character:FindFirstChild("Left Arm"))
				local rightHand = character and (character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm"))
				if not leftHand or not rightHand then return end
				local rock = findRock(definition)
				local punch = not ML.State.fastPunchToolPaused and ML.getPunch() or nil
				local muscleEvent = LP:FindFirstChild("muscleEvent")
				if not rock or not punch or not rockCache.touch or not muscleEvent
					or not muscleEvent:IsA("RemoteEvent") or not rockFarmIsCurrent(controller) then return end
				controller.lastRock = rock
				ML.activeRock = rock
				pcall(muscleEvent.FireServer, muscleEvent, "punch", "leftHand")
				pcall(muscleEvent.FireServer, muscleEvent, "punch", "rightHand")
				pcall(punch.Activate, punch)
				ML.State.playFastPunchVisual()
				task.wait(0.04)
				if not rockFarmIsCurrent(controller) or ML.getCharacter() ~= character or not rock.Parent then return end
				controller.contacts = { { rightHand, rock }, { leftHand, rock } }
				for _, contact in ipairs(controller.contacts) do
					pcall(rockCache.touch, contact[1], contact[2], rockCache.touchBegin)
				end
				task.wait(0.04)
				releaseRockContacts(controller)
			end)
			if not ok then releaseRockContacts(controller) end
			task.wait(0.08)
		end
	end
	releaseRockContacts(controller)
end

ML.runRockFarm = runRockFarm

local function startRockFarm(definition, previousStopped)
	if not previousStopped then
		clearRockSelection()
	end
	ML.State.selectedRock = definition
	ML.State.rockSessionStartedAt = os.clock()
	ML.State.rockVisualReadyAt = ML.State.rockSessionStartedAt + 0.20
	local controller = {
		enabled = true,
		definition = definition,
		generation = ML.State.rockGeneration,
		thread = nil,
		lastRock = nil,
	}
	ML.activeRockFarm = controller
	controller.thread = task.spawn(runRockFarm, controller)
end

ML.startRockFarm = startRockFarm

ML.State.fastPunchVisual = { character = nil, tracks = {}, index = 0 }

ML.State.clearFastPunchVisual = function()
	local visual = ML.State.fastPunchVisual
	for _, track in ipairs(visual.tracks) do
		pcall(track.Stop, track, 0.05)
		pcall(track.Destroy, track)
	end
	visual.character = nil
	visual.tracks = {}
	visual.index = 0
end

ML.State.playFastPunchVisual = function()
	local visual = ML.State.fastPunchVisual
	local character = ML.getCharacter()
	local humanoid = ML.getHumanoid()
	local animator = humanoid and (humanoid:FindFirstChildOfClass("Animator") or humanoid:FindFirstChild("Animator"))
	if not character or not animator then return end
	if visual.character ~= character or #visual.tracks == 0 then
		ML.State.clearFastPunchVisual()
		visual.character = character
		local shared = ReplicatedStorage:FindFirstChild("shared")
		local assets = shared and shared:FindFirstChild("assets")
		local animations = assets and assets:FindFirstChild("animations")
		local gameAnims = animations and animations:FindFirstChild("gameAnims")
		local tools = gameAnims and gameAnims:FindFirstChild("Tools")
		local punchAnimations = tools and tools:FindFirstChild("Punch")
		local attacks = punchAnimations and punchAnimations:FindFirstChild("attacks")
		if attacks then
			for _, animation in ipairs(attacks:GetChildren()) do
				if animation:IsA("Animation") then
					local ok, track = pcall(animator.LoadAnimation, animator, animation)
					if ok and track then
						track.Priority = Enum.AnimationPriority.Action
						visual.tracks[#visual.tracks + 1] = track
					end
				end
			end
		end
	end
	if #visual.tracks == 0 then return end
	visual.index = visual.index % #visual.tracks + 1
	for index, track in ipairs(visual.tracks) do
		if index ~= visual.index and track.IsPlaying then
			pcall(track.Stop, track, 0.02)
		end
	end
	pcall(visual.tracks[visual.index].Play, visual.tracks[visual.index], 0.02, 1, 1.8)
end

ML.getPunch = function()
	local character = ML.getCharacter()
	local humanoid = ML.getHumanoid()
	if not character or not humanoid then
		return nil
	end
	for _, container in ipairs({ character, LP:FindFirstChild("Backpack") }) do
		if container then
			for _, child in ipairs(container:GetChildren()) do
				if child:IsA("Tool") and child.Name:lower() == "punch" then
					if child.Parent ~= character then
						humanoid:EquipTool(child)
					end
					return child
				end
			end
		end
	end
	return nil
end

ML.setFastPunch = function(enabled)
	ML.State.fastPunchGeneration = ML.State.fastPunchGeneration + 1
	local generation = ML.State.fastPunchGeneration
	ML.State.fastPunch = enabled == true
	if not ML.State.fastPunch then
		ML.State.fastPunchToolPaused = false
		clearRockSelection()
		ML.stopThread("fastPunchEquip")
		ML.stopThread("fastPunchHit")
		ML.State.clearFastPunchVisual()
		pcall(function()
			local character = ML.getCharacter()
			local punch = character and character:FindFirstChild("Punch")
			local attackTime = punch and punch:FindFirstChild("attackTime")
			if attackTime then attackTime.Value = 0.3 end
			local backpack = LP:FindFirstChild("Backpack")
			if punch and backpack then punch.Parent = backpack end
		end)
		return
	end
	ML.startThread("fastPunchEquip", function()
		while ML.State.running and ML.State.fastPunch and ML.State.fastPunchGeneration == generation do
			pcall(function()
				local punch = not ML.State.fastPunchToolPaused and ML.getPunch() or nil
				local attackTime = punch and punch:FindFirstChild("attackTime")
				if attackTime then attackTime.Value = 0 end
			end)
			task.wait(0.05)
		end
	end)
	ML.startThread("fastPunchHit", function()
		local lastVisual = 0
		while ML.State.running and ML.State.fastPunch and ML.State.fastPunchGeneration == generation do
			if not ML.activeRockFarm then
				local event = LP:FindFirstChild("muscleEvent")
				local punch = not ML.State.fastPunchToolPaused and ML.getPunch() or nil
				if event and event:IsA("RemoteEvent") then
					pcall(event.FireServer, event, "punch", "rightHand")
					pcall(event.FireServer, event, "punch", "leftHand")
				end
				if punch and time() - lastVisual >= 0.12 then
					lastVisual = time()
					pcall(punch.Activate, punch)
					ML.State.playFastPunchVisual()
				end
			end
			task.wait(0.01)
		end
	end)
end

local repTimeOriginals = {}
ML.repTimeOriginals = repTimeOriginals

do
	local movement = ML.State.exerciseMovement
	movement.toolKinds = {
		["weight"] = "Weight",
		["heavy weight"] = "Weight",
		["handstand"] = "Handstands",
		["handstands"] = "Handstands",
		["pushup"] = "Pushups",
		["pushups"] = "Pushups",
		["situp"] = "Situps",
		["situps"] = "Situps",
	}
	movement.animationIds = {}
	movement.idsFor = function(kind)
		local cached = movement.animationIds[kind]
		if cached then return cached end
		cached = {}
		local shared = ReplicatedStorage:FindFirstChild("shared")
		local assets = shared and shared:FindFirstChild("assets")
		local animations = assets and assets:FindFirstChild("animations")
		local gameAnims = animations and animations:FindFirstChild("gameAnims")
		local tools = gameAnims and gameAnims:FindFirstChild("Tools")
		local folder = tools and tools:FindFirstChild(kind)
		if folder then
			for _, animation in ipairs(folder:GetDescendants()) do
				if animation:IsA("Animation") and animation.AnimationId ~= "" then
					cached[animation.AnimationId] = true
				end
			end
		end
		movement.animationIds[kind] = cached
		return cached
	end
	movement.stopTracks = function(humanoid, kind)
		local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
		if not animator or not kind then return end
		local ids = movement.idsFor(kind)
		for _, animationTrack in ipairs(animator:GetPlayingAnimationTracks()) do
			local animation = animationTrack.Animation
			if animation and ids[animation.AnimationId] then
				animationTrack:Stop(0.03)
			end
		end
	end
end

ML.setFastRepTime = function(key, tool)
	if not tool then return end
	local repTime = tool:FindFirstChild("repTime")
	if not repTime or not repTime:IsA("ValueBase") then return end
	repTimeOriginals[key] = repTimeOriginals[key] or setmetatable({}, { __mode = "k" })
	if repTimeOriginals[key][repTime] == nil then
		repTimeOriginals[key][repTime] = repTime.Value
	end
	repTime.Value = 0
end

ML.restoreRepTime = function(key)
	local saved = repTimeOriginals[key]
	if not saved then return end
	for repTime, original in pairs(saved) do
		if repTime and repTime.Parent then
			pcall(function()
				repTime.Value = original
			end)
		end
	end
	repTimeOriginals[key] = nil
end

ML.unequipRepTools = function(tools)
	local character = ML.getCharacter()
	local backpack = LP:FindFirstChild("Backpack")
	if not character or not backpack or not tools then return end
	local wanted = {}
	for _, name in ipairs(tools) do
		wanted[name:lower()] = true
	end
	for _, tool in ipairs(character:GetChildren()) do
		if tool:IsA("Tool") and wanted[tool.Name:lower()] then
			pcall(function()
				tool.Parent = backpack
			end)
		end
	end
end

ML.setAutoRep = function(key, enabled, tools, interval, forceFast)
	ML.State[key] = enabled == true
	local movement = ML.State.exerciseMovement
	movement.active[key] = ML.State[key] or nil
	local threadKey = "rep_" .. key
	if not ML.State[key] then
		ML.stopThread(threadKey)
		ML.restoreRepTime(key)
		ML.unequipRepTools(tools)
		local hasActiveExercise = false
		for _ in pairs(movement.active) do
			hasActiveExercise = true
			break
		end
		if not hasActiveExercise then
			ML.stopThread("exerciseMovement")
			local humanoid = movement.humanoid
			if humanoid and humanoid.Parent then
				pcall(function()
					if not ML.State.fastSpeed and movement.walkSpeed then
						humanoid.WalkSpeed = movement.walkSpeed
					end
					if movement.jumpValue then
						if movement.usesJumpPower then
							humanoid.JumpPower = movement.jumpValue
						else
							humanoid.JumpHeight = movement.jumpValue
						end
					end
				end)
			end
			movement.humanoid = nil
			movement.walkSpeed = nil
			movement.jumpValue = nil
		end
		return
	end
	local humanoid = ML.getHumanoid()
	if humanoid and movement.humanoid ~= humanoid then
		movement.humanoid = humanoid
		movement.walkSpeed = humanoid.WalkSpeed > 0 and humanoid.WalkSpeed or 16
		movement.usesJumpPower = humanoid.UseJumpPower
		movement.jumpValue = movement.usesJumpPower and humanoid.JumpPower or humanoid.JumpHeight
	end
	ML.startThread("exerciseMovement", function()
		while ML.State.running and next(movement.active) do
			local activeHumanoid = ML.getHumanoid()
			local root = ML.getRoot()
			if activeHumanoid then
				if movement.humanoid ~= activeHumanoid then
					movement.humanoid = activeHumanoid
					movement.walkSpeed = activeHumanoid.WalkSpeed > 0 and activeHumanoid.WalkSpeed or 16
					movement.usesJumpPower = activeHumanoid.UseJumpPower
					movement.jumpValue = movement.usesJumpPower and activeHumanoid.JumpPower or activeHumanoid.JumpHeight
				end
				if not ML.State.machine and not ML.State.fly then
					if root then root.Anchored = false end
					activeHumanoid.PlatformStand = false
					activeHumanoid.Sit = false
					local wantedSpeed = ML.State.fastSpeed and 1000 or movement.walkSpeed
					if wantedSpeed and activeHumanoid.WalkSpeed < wantedSpeed then
						activeHumanoid.WalkSpeed = wantedSpeed
					end
					if movement.jumpValue then
						if movement.usesJumpPower and activeHumanoid.JumpPower < movement.jumpValue then
							activeHumanoid.JumpPower = movement.jumpValue
						elseif not movement.usesJumpPower and activeHumanoid.JumpHeight < movement.jumpValue then
							activeHumanoid.JumpHeight = movement.jumpValue
						end
					end
				end
			end
			RunService.Heartbeat:Wait()
		end
	end)
	ML.startThread(threadKey, function()
		while ML.State.running and ML.State[key] do
			local repDelay = interval or 0.01
			pcall(function()
				local tool
				if tools and #tools > 0 then
					tool = ML.equipTool and ML.equipTool(tools) or nil
					if forceFast or ML.State.autoFarmMode == "Fast Rep" or ML.State.autoFarmMode == "Super Fast Rep" then
						ML.setFastRepTime(key, tool)
					else
						ML.restoreRepTime(key)
						local repTime = tool and tool:FindFirstChild("repTime", true)
						repDelay = math.max(0.02, tonumber(repTime and repTime.Value) or 1)
						local owned = LP:FindFirstChild("ownedGamepasses")
						if owned and owned:FindFirstChild("x2 Rep Time") then
							repDelay = repDelay * 0.02
						end
					end
				end
				local event = LP:FindFirstChild("muscleEvent")
				if event then
					if ML.State.autoFarmMode == "Super Fast Rep" then
						for _ = 1, 10 do
							event:FireServer("rep")
						end
					else
						event:FireServer("rep")
					end
				end
			end)
			task.wait(repDelay)
		end
	end)
end

ML.findProteinEgg = function()
	for _, container in ipairs({
		ML.getCharacter(),
		LP:FindFirstChild("Backpack"),
	}) do
		if container then
			for _, egg in ipairs(container:GetChildren()) do
				if egg:IsA("Tool") and table.find(CONFIG.AutoEgg.Names, egg.Name)
					and egg:GetAttribute("Used") ~= true then
					return egg
				end
			end
		end
	end
	return nil
end

ML.hasProteinEggBoost = function()
	local boostTimers = LP:FindFirstChild("boostTimersFolder")
	if not boostTimers then return false end
	for _, name in ipairs(CONFIG.AutoEgg.Names) do
		local timer = boostTimers:FindFirstChild(name)
		if timer and timer:IsA("ValueBase") and tonumber(timer.Value) and timer.Value > 0 then
			return true
		end
	end
	return false
end

ML.countProteinEggs = function()
	local total = 0
	for _, container in ipairs({
		ML.getCharacter(),
		LP:FindFirstChild("Backpack"),
		LP:FindFirstChild("consumablesFolder"),
	}) do
		if container then
			for _, egg in ipairs(container:GetChildren()) do
				if (egg:IsA("Tool") or egg:IsA("StringValue")) and table.find(CONFIG.AutoEgg.Names, egg.Name) then
					total = total + 1
				end
			end
		end
	end
	return total
end

ML.hubNotify = function(text, duration)
	pcall(function()
		local message = tostring(text or "")
		if type(ML.State.translateText) == "function" then message = ML.State.translateText(message) end
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Young0x Hub",
			Text = message,
			Duration = tonumber(duration) or 4,
		})
	end)
end

ML.State.eggBusy = false
ML.State.eatProteinEgg = function(force)
	if not force and ML.hasProteinEggBoost() then return true end
	if ML.State.eggBusy then return false end
	local egg = ML.findProteinEgg()
	local character = ML.getCharacter()
	local muscleEvent = LP:FindFirstChild("muscleEvent")
	if not egg or not character or not muscleEvent or not muscleEvent:IsA("RemoteEvent") then
		return false
	end
	ML.State.eggBusy = true
	local ok, consumed = pcall(function()
		local originalParent = egg.Parent
		local originalUsed = egg:GetAttribute("Used")
		local beforeCount = ML.countProteinEggs()
		local hadBoost = ML.hasProteinEggBoost()
		local function confirmed()
			return not egg.Parent or ML.countProteinEggs() < beforeCount
				or (not hadBoost and ML.hasProteinEggBoost())
		end
		if egg.Parent ~= character then
			egg.Parent = character
			task.wait(0.2)
		end
		if confirmed() then return true end
		egg:SetAttribute("Used", true)
		muscleEvent:FireServer("proteinEgg", egg)
		local deadline = time() + 3
		while time() < deadline do
			if confirmed() then return true end
			task.wait(0.1)
		end
		if egg.Parent then egg:SetAttribute("Used", originalUsed) end
		if egg.Parent == character and originalParent and originalParent.Parent then
			egg.Parent = originalParent
		end
		return false
	end)
	ML.State.eggBusy = false
	return ok and consumed == true
end

do
	local function parseBoostTime(text)
		text = tostring(text or "")
		local hours = tonumber(text:match("(%d+)%s*[hH]")) or 0
		local minutes = tonumber(text:match("(%d+)%s*[mM]")) or 0
		local seconds = tonumber(text:match("(%d+)%s*[sS]")) or 0
		local total = hours * 3600 + minutes * 60 + seconds
		return total > 0 and total or nil
	end

	local function visibleStrengthBoostRemaining()
		local boostTimers = LP:FindFirstChild("boostTimersFolder")
		if boostTimers then
			for _, name in ipairs(CONFIG.AutoEgg.Names) do
				local timer = boostTimers:FindFirstChild(name)
				local remaining = timer and tonumber(timer.Value)
				if remaining and remaining > 0 then
					return remaining
				end
			end
		end
		return 0
	end

	ML.State.autoEggSources = { manual = false, fastFarm = false, rebirth = false }
	ML.State.autoEggNextAt = 0
	ML.State.autoEggImmediateRequested = false

	ML.State.setAutoEgg = function(enabled, source)
		source = source or "manual"
		local wasEnabled = ML.State.autoEggSources[source] == true
		ML.State.autoEggSources[source] = enabled == true
		if enabled == true and not wasEnabled then
			ML.State.autoEggImmediateRequested = true
		end
		local desired = false
		for _, active in pairs(ML.State.autoEggSources) do
			if active then
				desired = true
				break
			end
		end
		if ML.State.autoEgg == desired then
			return
		end
		ML.State.autoEgg = desired
		if not desired then
			ML.State.autoEggImmediateRequested = false
			ML.stopThread("autoEgg")
			return
		end
		ML.startThread("autoEgg", function()
			while ML.State.running and ML.State.autoEgg do
				local now = time()
				if ML.State.autoEggImmediateRequested then
					ML.State.autoEggImmediateRequested = false
					if ML.State.eatProteinEgg(false) then
						ML.State.autoEggNextAt = now + CONFIG.AutoEgg.Interval
					else
						ML.State.autoEggNextAt = now + 10
					end
				else
					local remaining = visibleStrengthBoostRemaining()
					if remaining > 0 then
						ML.State.autoEggNextAt = math.max(ML.State.autoEggNextAt, now + remaining)
					end
					if now >= ML.State.autoEggNextAt then
						if ML.State.eatProteinEgg(false) then
							ML.State.autoEggNextAt = now + CONFIG.AutoEgg.Interval
						else
							ML.State.autoEggNextAt = now + 10
						end
					end
				end
				task.wait(1)
			end
		end)
	end
end

ML.findNativeAutoLiftButton = function()
	local gameGui = PlayerGui:FindFirstChild("gameGui")
	local modernHud = gameGui and gameGui:FindFirstChild("hudNewMenu")
	local modernTop = modernHud and modernHud:FindFirstChild("Top")
	local modernButton = modernTop and modernTop:FindFirstChild("AutoLiftBtn")
	if modernButton and modernButton:IsA("GuiButton") then
		return modernButton
	end
	local frame = PlayerGui:FindFirstChild("autoLiftFrame", true)
	local button = frame and frame:FindFirstChild("autoLiftButton", true)
	if button and button:IsA("GuiButton") then
		return button
	end
	return nil
end

ML.releaseNativeAutoLiftButton = function()
	local native = ML.State.autoLiftNative
	if native.connection then
		pcall(function()
			native.connection:Disconnect()
		end)
		native.connection = nil
	end
	if native.visualConnection then
		pcall(function() native.visualConnection:Disconnect() end)
		native.visualConnection = nil
	end
	for _, connection in ipairs(native.disabledConnections) do
		pcall(function()
			connection:Enable()
		end)
	end
	table.clear(native.disabledConnections)
	if native.fallbackMarker then
		pcall(function()
			native.fallbackMarker:Destroy()
		end)
		native.fallbackMarker = nil
	end
	if ML.State.autoLiftEditableImage then
		pcall(function() ML.State.autoLiftEditableImage:Destroy() end)
		ML.State.autoLiftEditableImage = nil
	end
	ML.State.autoLiftEditableLoading = false
	native.button = nil
end

ML.State.refreshNativeAutoLiftVisual = function()
	local button = ML.State.autoLiftNative.button
	if not button or not button.Parent or button.Name ~= "AutoLiftBtn" then return end
	local enabled = LP:GetAttribute("AutoLiftEnabled") == true
	local stateLabel = button:FindFirstChild("InfoLabel")
	if stateLabel and stateLabel:IsA("TextLabel") then
		stateLabel.Text = enabled and "ON" or "OFF"
		stateLabel.TextColor3 = enabled and Color3.fromRGB(85, 255, 127) or Color3.fromRGB(255, 80, 80)
		stateLabel.TextStrokeColor3 = enabled and Color3.fromRGB(0, 85, 0) or Color3.fromRGB(85, 0, 0)
	end
	if button:IsA("ImageButton") then
		button.ImageColor3 = Color3.new(1, 1, 1)
		if not enabled then
			button.Image = "rbxassetid://129249781616384"
			return
		end
		local editable = ML.State.autoLiftEditableImage
		local usable = editable and pcall(function() return editable.Size.X > 0 end)
		if not usable and not ML.State.autoLiftEditableLoading then
			ML.State.autoLiftEditableLoading = true
			local created, result = pcall(function()
				local image = game:GetService("AssetService"):CreateEditableImageAsync(
					Content.fromUri("rbxassetid://129249781616384")
				)
				local size = image.Size
				local pixels = image:ReadPixelsBuffer(Vector2.zero, size)
				for index = 0, size.X * size.Y - 1 do
					local offset = index * 4
					local red = buffer.readu8(pixels, offset)
					local green = buffer.readu8(pixels, offset + 1)
					local blue = buffer.readu8(pixels, offset + 2)
					local alpha = buffer.readu8(pixels, offset + 3)
					if alpha > 0 and red > 45 and red > green * 1.35 and red > blue * 1.18 then
						buffer.writeu8(pixels, offset, math.floor(red * 0.1))
						buffer.writeu8(pixels, offset + 1, red)
						buffer.writeu8(pixels, offset + 2, math.floor(red * 0.33))
					end
				end
				image:WritePixelsBuffer(Vector2.zero, size, pixels)
				return image
			end)
			ML.State.autoLiftEditableLoading = false
			if created and result then
				ML.State.autoLiftEditableImage = result
				ML.State.autoLiftEditableError = nil
				editable = result
			else
				ML.State.autoLiftEditableError = tostring(result)
			end
		end
		if editable then
			local applied = pcall(function()
				button.ImageContent = Content.fromObject(editable)
			end)
			if applied then return end
		end
		button.Image = "rbxassetid://129249781616384"
	end
end

ML.bindNativeAutoLiftButton = function()
	local button = ML.findNativeAutoLiftButton()
	if not button then
		return false
	end
	local native = ML.State.autoLiftNative
	if native.button == button and native.connection and native.connection.Connected then
		return true
	end
	ML.releaseNativeAutoLiftButton()
	native.button = button
	button.Active = true
	button.Selectable = true

	local isolated = false
	if type(getconnections) == "function" then
		for _, signal in ipairs({
			button.Activated,
			button.MouseButton1Click,
			button.MouseButton1Down,
			button.MouseButton1Up,
		}) do
			local ok, connections = pcall(getconnections, signal)
			if ok and type(connections) == "table" then
				for _, connection in ipairs(connections) do
					local disabled = pcall(function()
						connection:Disable()
					end)
					if disabled then
						table.insert(native.disabledConnections, connection)
						isolated = true
					end
				end
			end
		end
	end

	local owned = LP:FindFirstChild("ownedGamepasses")
	if owned and not owned:FindFirstChild("Auto Lift") then
		local marker = Instance.new("BoolValue")
		marker.Name = "Auto Lift"
		marker.Value = true
		marker:SetAttribute("Temp", not isolated)
		marker.Parent = owned
		native.fallbackMarker = marker
	end

	native.connection = button.Activated:Connect(function()
		if not ML.State.running or not ML.State.autoLiftUnlocked then
			return
		end
		LP:SetAttribute("AutoLiftEnabled", LP:GetAttribute("AutoLiftEnabled") ~= true)
	end)
	native.visualConnection = LP:GetAttributeChangedSignal("AutoLiftEnabled"):Connect(function()
		task.defer(ML.State.refreshNativeAutoLiftVisual)
	end)
	ML.State.refreshNativeAutoLiftVisual()
	return true
end

ML.unlockNativeAutoLift = function()
	if ML.State.autoLiftUnlocked then
		local bound = ML.bindNativeAutoLiftButton()
		if bound then LP:SetAttribute("AutoLiftEnabled", true); task.defer(ML.State.refreshNativeAutoLiftVisual) end
		return bound
	end
	if not ML.bindNativeAutoLiftButton() then
		return false
	end
	ML.State.autoLiftUnlocked = true
	LP:SetAttribute("AutoLiftEnabled", true)
	task.defer(ML.State.refreshNativeAutoLiftVisual)
	return true
end

ML.hiddenFrames = setmetatable({}, { __mode = "k" })
ML.hideFramesConnections = {}
ML.hiddenDurabilityFrames = setmetatable({}, { __mode = "k" })
ML.durabilityFrameConnections = {}
ML.trainingFrameNames = {
	strengthframe = true,
	durabilityframe = true,
	agilityframe = true,
	fuerzaframe = true,
}

ML.releaseHiddenObjects = function(objects)
	for object, entry in pairs(objects) do
		if entry.visibleConnection then
			entry.visibleConnection:Disconnect()
		end
		if entry.ancestryConnection then
			entry.ancestryConnection:Disconnect()
		end
		if object and object.Parent then
			pcall(function()
				object.Visible = entry.visible
			end)
		end
	end
	table.clear(objects)
end

ML.keepObjectHidden = function(objects, object, isEnabled)
	if objects[object] ~= nil then
		return
	end
	local entry = { visible = object.Visible }
	objects[object] = entry
	entry.visibleConnection = object:GetPropertyChangedSignal("Visible"):Connect(function()
		if isEnabled() and object.Parent and object.Visible then
			object.Visible = false
		end
	end)
	entry.ancestryConnection = object.AncestryChanged:Connect(function(_, parent)
		if parent == nil then
			if entry.visibleConnection then
				entry.visibleConnection:Disconnect()
			end
			if entry.ancestryConnection then
				entry.ancestryConnection:Disconnect()
			end
			objects[object] = nil
		end
	end)
	object.Visible = false
end

ML.hideDurabilityFrame = function(object)
	if object
		and object:IsA("GuiObject")
		and object.Name == "durabilityFrame"
		and ML.hiddenDurabilityFrames[object] == nil then
		ML.keepObjectHidden(ML.hiddenDurabilityFrames, object, function()
			return ML.State.running and ML.State.hideDurability
		end)
	end
end

ML.setHideDurability = function(enabled)
	ML.State.hideDurability = enabled == true
	for _, connection in ipairs(ML.durabilityFrameConnections) do
		connection:Disconnect()
	end
	table.clear(ML.durabilityFrameConnections)

	if ML.State.hideDurability then
		for _, object in ipairs(ReplicatedStorage:GetChildren()) do
			pcall(ML.hideDurabilityFrame, object)
		end
		for _, object in ipairs(PlayerGui:GetDescendants()) do
			pcall(ML.hideDurabilityFrame, object)
		end
		ML.durabilityFrameConnections[#ML.durabilityFrameConnections + 1] = ReplicatedStorage.ChildAdded:Connect(function(object)
			if ML.State.hideDurability then
				task.defer(ML.hideDurabilityFrame, object)
			end
		end)
		ML.durabilityFrameConnections[#ML.durabilityFrameConnections + 1] = PlayerGui.DescendantAdded:Connect(function(object)
			if ML.State.hideDurability then
				task.defer(ML.hideDurabilityFrame, object)
			end
		end)
	else
		ML.releaseHiddenObjects(ML.hiddenDurabilityFrames)
	end
end

ML.hideFrame = function(object, expectedParent)
	if ML.State.hideFrames
		and object
		and object.Parent == expectedParent
		and object:IsA("GuiObject")
		and ML.trainingFrameNames[tostring(object.Name or ""):lower()]
		and ML.hiddenFrames[object] == nil then
		ML.keepObjectHidden(ML.hiddenFrames, object, function()
			return ML.State.running and ML.State.hideFrames
		end)
	end
end

ML.setHideFrames = function(enabled)
	ML.State.hideFrames = enabled == true
	local showPopups = not ML.State.hideFrames
	local changedPreference = LP:GetAttribute("ShowPopups") ~= showPopups
	pcall(LP.SetAttribute, LP, "ShowPopups", showPopups)
	if changedPreference and not ML.State.shuttingDown then
		local events = ReplicatedStorage:FindFirstChild("rEvents")
		local remote = events and events:FindFirstChild("savePlayerSizeEvent")
		if remote and remote:IsA("RemoteEvent") then
			pcall(remote.FireServer, remote, "showPopupsOption")
		end
	end
	for _, connection in ipairs(ML.hideFramesConnections) do
		connection:Disconnect()
	end
	table.clear(ML.hideFramesConnections)

	if ML.State.hideFrames then
		local watchedRoots = {}
		local function watchRoot(root)
			if not root or watchedRoots[root] then
				return
			end
			watchedRoots[root] = true
			for _, object in ipairs(root:GetChildren()) do
				pcall(ML.hideFrame, object, root)
			end
			ML.hideFramesConnections[#ML.hideFramesConnections + 1] = root.ChildAdded:Connect(function(object)
				if ML.State.running and ML.State.hideFrames then
					task.defer(ML.hideFrame, object, root)
				end
			end)
		end

		watchRoot(ReplicatedStorage:FindFirstChild("shared") and ReplicatedStorage.shared:FindFirstChild("assets") and ReplicatedStorage.shared.assets:FindFirstChild("ui") or nil)
		watchRoot(PlayerGui:FindFirstChild("statEffectsGui"))
		ML.hideFramesConnections[#ML.hideFramesConnections + 1] = PlayerGui.ChildAdded:Connect(function(object)
			if ML.State.running and ML.State.hideFrames and object.Name == "statEffectsGui" then
				task.defer(watchRoot, object)
			end
		end)
	else
		ML.releaseHiddenObjects(ML.hiddenFrames)
	end
end

ML.State.hideFrames = false
ML.State.hideDurability = false
ML.State.autoSpinWheel = false
ML.State.rewardsBusy = nil
ML.State.chestClaimBusy = false
ML.State.chestRejectedUntil = {}

ML.State.syncAvailabilityToggle = function(toggle, enabled)
	if toggle and toggle:Get() ~= enabled then
		toggle:Set(enabled, true)
	end
end

ML.State.fortuneSpinRaw = function()
	if ML.State.rewardDataValue then
		local purchased = ML.State.rewardDataValue("purchasedSpins")
		local free = ML.State.rewardDataValue("freeWheelSpins")
		if type(purchased) == "number" or type(free) == "number" then
			return math.max(0, math.floor((tonumber(purchased) or 0) + (tonumber(free) or 0)))
		end
	end
	local menu = PlayerGui:FindFirstChild("fortuneWheelMenuGui")
	local label = menu and menu:FindFirstChild("spinAmountLabel", true)
	if not label or not label:IsA("TextLabel") then
		return nil
	end
	return tonumber(tostring(label.Text or ""):match("(%d+)"))
end

ML.State.fortuneCooldownRemaining = function()
	local serverUntil = tonumber(LP:GetAttribute("FortuneWheelCooldownUntil")) or 0
	return math.max(0, serverUntil - workspace:GetServerTimeNow(), (ML.State.fortuneRetryAt or 0) - os.clock(), (ML.State.fortuneNextAt or 0) - os.clock())
end

ML.State.fortuneSpinAmount = function()
	if ML.State.fortuneCooldownRemaining() > 0 then
		return nil
	end
	local amount = ML.State.fortuneSpinRaw()
	local pending = ML.State.fortunePending
	if pending then
		if amount and amount < pending.before then
			ML.State.fortunePending = nil
		elseif (pending.returned or pending.cancelled) and os.clock() >= (pending.releaseAt or math.huge) then
			ML.State.fortunePending = nil
		else
			return nil
		end
	end
	return amount
end

local function setAutoSpinWheel(enabled)
	enabled = enabled == true
	if not enabled then
		ML.State.autoSpinWheel = false
		local pending = ML.State.fortunePending
		if pending and not pending.returned then
			pending.cancelled = true
			pending.releaseAt = math.max(ML.State.fortuneNextAt or 0, os.clock() + 20)
		end
		ML.stopThread("fortuneWheel")
		if ML.State.rewardsBusy == "wheel" then ML.State.rewardsBusy = nil end
		ML.State.syncAvailabilityToggle(ML.State.autoSpinToggle, false)
		return true
	end
	if ML.State.autoSpinWheel then return true end
	local available = ML.State.fortuneSpinAmount()
	if ML.State.rewardsBusy or not available or available <= 0 then
		return false
	end
	local events = ReplicatedStorage:FindFirstChild("rEvents")
	local remote = events and events:FindFirstChild("openFortuneWheelRemote")
	local shared = ReplicatedStorage:FindFirstChild("shared")
	local catalogs = shared and shared:FindFirstChild("catalogs")
	local chances = catalogs and catalogs:FindFirstChild("fortuneWheelChances")
	local wheel = chances and chances:FindFirstChild("Fortune Wheel")
	if not remote or not remote:IsA("RemoteFunction") or not wheel then
		return false
	end
	ML.State.autoSpinWheel = true
	ML.State.rewardsBusy = "wheel"
	ML.State.fortuneLastSpins = 0
	ML.State.fortuneLastError = nil
	ML.startThread("fortuneWheel", function()
		local ok, problem = pcall(function()
			local rejections = 0
			while ML.State.running and ML.State.autoSpinWheel do
				while ML.State.running and ML.State.autoSpinWheel and ML.State.fortuneCooldownRemaining() > 0 do
					task.wait(math.min(.25, ML.State.fortuneCooldownRemaining()))
				end
				if not ML.State.running or not ML.State.autoSpinWheel then break end
				local before = ML.State.fortuneSpinRaw()
				if not before or before <= 0 then break end
				local pending = { before = before, at = os.clock(), returned = false }
				ML.State.fortunePending = pending
				ML.State.fortuneNextAt = os.clock() + .25
				local sent, result = pcall(remote.InvokeServer, remote, "openFortuneWheel", wheel)
				pending.returned = true
				pending.releaseAt = math.max(ML.State.fortuneNextAt, os.clock() + .5)
				local valid = sent and type(result) == "table" and type(result.name) == "string"
					and type(result.rarity) == "string" and type(result.image) == "string" and typeof(result.itemColor) == "Color3"
				ML.State.fortuneLastRequest = {
					before = before,
					at = pending.at,
					returnedAt = os.clock(),
					sent = sent,
					valid = valid,
					reply = type(result) == "table" and tostring(result.name) or tostring(result),
				}
				if not valid then
					ML.State.fortunePending = nil
					rejections = rejections + 1
					local retryDelay = math.min(.35 + rejections * .2, 2.5)
					ML.State.fortuneRetryAt = os.clock() + retryDelay
					ML.State.fortuneLastError = sent and "La ruleta todavía no aceptó el giro" or "Esperando confirmación del giro"
					task.wait(retryDelay)
				else
					local confirmed = false
					local deadline = os.clock() + 4
					repeat
						task.wait(.1)
						local remaining = ML.State.fortuneSpinRaw()
						ML.State.fortuneLastRequest.after = remaining
						confirmed = remaining ~= nil and remaining < before
					until confirmed or os.clock() >= deadline or not ML.State.running or not ML.State.autoSpinWheel
					if not confirmed then
						ML.State.fortunePending = nil
						rejections = rejections + 1
						local retryDelay = math.min(.35 + rejections * .2, 2.5)
						ML.State.fortuneRetryAt = os.clock() + retryDelay
						ML.State.fortuneLastError = "Esperando confirmación del giro"
						task.wait(retryDelay)
					else
						ML.State.fortunePending = nil
						ML.State.fortuneLastError = nil
						ML.State.fortuneLastSpins = (ML.State.fortuneLastSpins or 0) + 1
						rejections = 0
						if ML.State.pushOutput then ML.State.pushOutput("REWARD", "Fortune Wheel · +1 giro confirmado") end
						task.wait(.08)
					end
				end
			end
		end)
		if not ok then ML.State.fortuneLastError = tostring(problem) end
		ML.State.autoSpinWheel = false
		if ML.State.rewardsBusy == "wheel" then ML.State.rewardsBusy = nil end
		ML.State.syncAvailabilityToggle(ML.State.autoSpinToggle, false)
		if ML.State.fortuneLastError and ML.State.pushOutput then ML.State.pushOutput("ERROR", ML.State.fortuneLastError) end
		if ML.State.refreshMiscAvailability then ML.State.refreshMiscAvailability() end
	end)
	return true
end

local portalConnection = nil
local removedPortals = {}

local function removePortal(object)
	if object and object.Name == "RobloxForwardPortals" and object.Parent then
		removedPortals[#removedPortals + 1] = { object = object, parent = object.Parent }
		object.Parent = nil
	end
end

local function setRemovePortals(enabled)
	ML.State.removePortals = enabled == true
	ML.stopThread("removePortals")
	if portalConnection then
		portalConnection:Disconnect()
		portalConnection = nil
	end
	if not ML.State.removePortals then
		for _, entry in ipairs(removedPortals) do
			if entry.object and not entry.object.Parent then
				pcall(function()
					entry.object.Parent = entry.parent and entry.parent.Parent and entry.parent or workspace
				end)
			end
		end
		table.clear(removedPortals)
		return
	end
	portalConnection = workspace.DescendantAdded:Connect(removePortal)
	ML.startThread("removePortals", function()
		local queue = { workspace }
		local head = 1
		local processed = 0
		while head <= #queue and ML.State.running and ML.State.removePortals do
			local parent = queue[head]
			head = head + 1
			local ok, children = pcall(function()
				return parent:GetChildren()
			end)
			if ok then
				for _, child in ipairs(children) do
					queue[#queue + 1] = child
					removePortal(child)
					processed = processed + 1
					if processed % 300 == 0 then
						RunService.Heartbeat:Wait()
					end
				end
			end
		end
	end)
end

local baseWalkSpeed = nil

local function applyWalkSpeed()
	local humanoid = ML.getHumanoid()
	if humanoid then
		if ML.State.fastSpeed then
			humanoid.WalkSpeed = 1000
		elseif baseWalkSpeed ~= nil then
			humanoid.WalkSpeed = baseWalkSpeed
		end
	end
end

ML.State.setFastSpeed = function(enabled)
	local humanoid = ML.getHumanoid()
	if enabled and humanoid and not ML.State.fastSpeed then
		baseWalkSpeed = humanoid.WalkSpeed
	end
	local wasEnabled = ML.State.fastSpeed
	ML.State.fastSpeed = enabled == true
	if ML.State.fastSpeed or wasEnabled then
		applyWalkSpeed()
	end
	if wasEnabled and not ML.State.fastSpeed then
		baseWalkSpeed = nil
	end
end

local flyGyro = nil
local flyVelocity = nil
local mobileFlyUp = false
local mobileFlyDown = false
local mobileFlyControls = nil

ML.State.clearAntiKnockback = function()
	if ML.State.antiKnockbackVelocity then
		ML.State.antiKnockbackVelocity:Destroy()
		ML.State.antiKnockbackVelocity = nil
	end
end

ML.State.setAntiKnockback = function(enabled)
	ML.State.antiKnockback = enabled == true
	if not ML.State.antiKnockback and not ML.State.noclip then
		ML.State.clearAntiKnockback()
	end
end

local function clearFlyMovers()
	if flyGyro then
		flyGyro:Destroy()
		flyGyro = nil
	end
	if flyVelocity then
		flyVelocity:Destroy()
		flyVelocity = nil
	end
	local humanoid = ML.getHumanoid()
	if humanoid then
		humanoid.PlatformStand = false
	end
end

ML.State.setFly = function(enabled)
	ML.State.fly = enabled == true
	if mobileFlyControls then
		mobileFlyControls.Visible = ML.State.fly and UserInputService.TouchEnabled
	end
	if not ML.State.fly then
		clearFlyMovers()
	end
end

local setNoclip

do
	local originals = setmetatable({}, { __mode = "k" })
	local simulationConnection = nil

	local function findBeachSurfaceY()
		local bestSurface = nil
		local bestScore = math.huge
		for _, object in ipairs(workspace:GetChildren()) do
			if object:IsA("BasePart") and object.Name:lower() == "baseplate"
				and math.max(object.Size.X, object.Size.Z) >= 250 then
				local frame = object.CFrame
				local verticalHalfSize = math.abs(frame.RightVector.Y) * object.Size.X * 0.5
					+ math.abs(frame.UpVector.Y) * object.Size.Y * 0.5
					+ math.abs(frame.LookVector.Y) * object.Size.Z * 0.5
				local surface = object.Position.Y + verticalHalfSize
				local score = math.abs(surface)
				if score < bestScore then
					bestScore = score
					bestSurface = surface
				end
			end
		end
		if bestSurface ~= nil then
			return bestSurface
		end
		local root = ML.getRoot()
		local humanoid = ML.getHumanoid()
		if root then
			return root.Position.Y - ((humanoid and humanoid.HipHeight or 2) + root.Size.Y * 0.5)
		end
		return 0
	end

	local function applyToPart(part)
		if originals[part] == nil then
			originals[part] = {
				canCollide = part.CanCollide,
				canTouch = part.CanTouch,
				canQuery = part.CanQuery,
			}
		end
		pcall(function()
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
		end)
	end

	local function applyNoclip()
		if not ML.State.running or not ML.State.noclip then return end
		local character = ML.getCharacter()
		if not character then return end
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				applyToPart(part)
			end
		end
	end

	local function restoreNoclip()
		if simulationConnection then
			simulationConnection:Disconnect()
			simulationConnection = nil
		end
		for part, properties in pairs(originals) do
			if part and part.Parent then
				pcall(function()
					part.CanCollide = properties.canCollide
					part.CanTouch = properties.canTouch
					part.CanQuery = properties.canQuery
				end)
			end
		end
		table.clear(originals)
	end

	setNoclip = function(enabled)
		ML.State.noclip = enabled == true
		if not ML.State.noclip then
			ML.State.noclipBeachSurfaceY = nil
			restoreNoclip()
			if not ML.State.antiKnockback then
				ML.State.clearAntiKnockback()
			end
			return true
		end
		ML.State.noclipBeachSurfaceY = findBeachSurfaceY()
		if simulationConnection then
			simulationConnection:Disconnect()
		end
		applyNoclip()
		simulationConnection = RunService.PreSimulation:Connect(applyNoclip)
		return true
	end
end

local spinVelocity = nil
local spinHumanoid = nil
local spinAutoRotate = true

local function clearSpin()
	if spinVelocity then
		local root = spinVelocity.Parent
		if root and root:IsA("BasePart") then
			root.AssemblyAngularVelocity = Vector3.zero
		end
		spinVelocity:Destroy()
		spinVelocity = nil
	end
	if spinHumanoid and spinHumanoid.Parent then
		spinHumanoid.AutoRotate = spinAutoRotate
	end
	spinHumanoid = nil
end

ML.State.setSpin = function(enabled)
	ML.State.spin = enabled == true
	if not ML.State.spin then
		clearSpin()
	end
end

local function resetCamera()
	local humanoid = ML.getHumanoid()
	if workspace.CurrentCamera and humanoid then
		workspace.CurrentCamera.CameraSubject = humanoid
	end
end

ML.State.setSpy = function(enabled)
	ML.State.spy = enabled == true
	if not ML.State.spy then
		resetCamera()
	end
end

State = ML.State
FastFarm = Env.__FGFarm or {
	MachineToggleByDefinition = {},
	RepToggles = {},
	mode = nil,
	packMode = nil,
	PetMomentum = nil,
	SetSizeOne = function() end,
	Stop = function() end,
}
Env.__FGFarm = FastFarm

local function getCombatPart(character, root)
	return character and (
		character:FindFirstChild("UpperTorso")
		or character:FindFirstChild("Torso")
		or character:FindFirstChild("LowerTorso")
	) or root
end

local function getAttackCFrame(character, root, targetCharacter, targetRoot, contactStep)
	local velocity = targetRoot.AssemblyLinearVelocity
	local prediction = Vector3.new(velocity.X, 0, velocity.Z) * 0.025
	if prediction.Magnitude > 0.8 then prediction = prediction.Unit * 0.8 end
	local ownPart = getCombatPart(character, root)
	local targetPart = getCombatPart(targetCharacter, targetRoot)
	local ownOffset = ownPart and (ownPart.Position - root.Position) or Vector3.zero
	if ownOffset.Magnitude > 4 then ownOffset = Vector3.new(0, 1, 0) end
	local step = ((contactStep or 1) - 1) % 5 + 1
	local rootPosition = targetRoot.Position + prediction
	local targetPosition = (targetPart and targetPart.Position or targetRoot.Position) + prediction
	if targetPart then
		local size = targetPart.Size
		local ownHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
		if targetRoot.Size.X <= 0.75 and ownHand then
			local normal, extent
			if step == 1 then normal, extent = -targetPart.CFrame.LookVector, size.Z * 0.5
			elseif step == 2 then normal, extent = targetPart.CFrame.RightVector, size.X * 0.5
			elseif step == 3 then normal, extent = targetPart.CFrame.LookVector, size.Z * 0.5
			elseif step == 4 then normal, extent = -targetPart.CFrame.RightVector, size.X * 0.5
			else normal, extent = -targetPart.CFrame.LookVector, 0 end
			local facing = CFrame.lookAt(Vector3.zero, -normal)
			local handOffset = root.CFrame:PointToObjectSpace(ownHand.Position)
			local attackPosition = targetPosition + normal * (extent + 0.02)
				- facing:VectorToWorldSpace(handOffset)
			return CFrame.new(attackPosition) * facing.Rotation
		end
		local oversized = math.max(size.X, size.Y, size.Z) >= 4.5
		local displaced = (targetPart.Position - targetRoot.Position).Magnitude >= 4
		if not oversized and not displaced then
			local normal, extent
			if step == 1 then normal, extent = -targetRoot.CFrame.LookVector, targetRoot.Size.Z * 0.5
			elseif step == 2 then normal, extent = targetRoot.CFrame.RightVector, targetRoot.Size.X * 0.5
			elseif step == 3 then normal, extent = targetRoot.CFrame.LookVector, size.Z * 0.5
			elseif step == 4 then normal, extent = -targetRoot.CFrame.RightVector, targetRoot.Size.X * 0.5 end
			if normal and extent then
				local ownExtent = math.max(root.Size.Z * 0.5, 0.15)
				local attackPosition = rootPosition + normal * (extent + ownExtent + 0.2)
				return CFrame.lookAt(attackPosition, rootPosition)
			end
			return CFrame.lookAt(rootPosition - targetRoot.CFrame.LookVector * 0.1, rootPosition)
		end
		if displaced and not oversized then step = step == 1 and 5 or step - 1 end
		local normal, extent
		if step == 1 then normal, extent = targetPart.CFrame.RightVector, size.X * 0.5
		elseif step == 2 then normal, extent = -targetPart.CFrame.RightVector, size.X * 0.5
		elseif step == 3 then normal, extent = -targetPart.CFrame.LookVector, size.Z * 0.5
		elseif step == 4 then normal, extent = targetPart.CFrame.LookVector, size.Z * 0.5 end
		if normal and extent then
			local attackPosition = targetPosition + normal * (extent + 0.2)
			return CFrame.lookAt(attackPosition, targetPosition)
		end
	end
	local direction = Vector3.new(targetRoot.CFrame.LookVector.X, 0, targetRoot.CFrame.LookVector.Z)
	if direction.Magnitude < 0.01 then direction = Vector3.zAxis else direction = direction.Unit end
	local attackPosition = targetPosition - ownOffset - direction * 0.1
	return CFrame.lookAt(attackPosition, targetPosition)
end

local function currentKillsTotal()
	local stat = ML.getPlayerStat(LP, { "Kills" })
	local value = stat and tonumber(ML.State.getFunctionalStatValue(stat))
	return value and math.floor(value) or nil
end

local function updateKillSession(value)
	local numeric = tonumber(value)
	if not numeric then return end
	local current = math.floor(numeric)
	local previous = ML.State.kill.lastObservedKills
	ML.State.kill.lastObservedKills = current
	if previous == nil or current > previous then
		ML.State.kill.lastKillAt = os.clock()
	end
	ML.State.kill.sessionLastTotal = current
	if ML.State.kill.killSessionActive then
		if ML.State.kill.sessionStartKills == nil then
			ML.State.kill.sessionStartKills = current
			ML.State.kill.sessionKills = 0
		elseif current >= ML.State.kill.sessionStartKills then
			ML.State.kill.sessionKills = current - ML.State.kill.sessionStartKills
		end
	end
end

local function startKillSession()
	if ML.State.kill.killSessionActive then
		if not ML.State.kill.sessionStartedAt then ML.State.kill.sessionStartedAt = os.clock() end
		return
	end
	ML.State.kill.killSessionActive = true
	ML.State.kill.sessionKills = 0
	ML.State.kill.sessionStartKills = currentKillsTotal()
	ML.State.kill.sessionLastTotal = ML.State.kill.sessionStartKills
	ML.State.kill.sessionElapsed = 0
	ML.State.kill.sessionStartedAt = os.clock()
end

ML.State.getKillSessionElapsed = function()
	local elapsed = math.max(0, tonumber(ML.State.kill.sessionElapsed) or 0)
	if ML.State.kill.killSessionActive and ML.State.kill.sessionStartedAt then
		elapsed = elapsed + math.max(0, os.clock() - ML.State.kill.sessionStartedAt)
	end
	return elapsed
end

local function stopKillSessionIfIdle()
	local active = ML.State.kill.auto or ML.State.kill.targetMode or ML.State.kill.karmaMode ~= nil or ML.State.kill.autoWinBrawl
	if active or not ML.State.kill.killSessionActive then return false end
	ML.State.kill.sessionElapsed = ML.State.getKillSessionElapsed()
	ML.State.kill.sessionStartedAt = nil
	ML.State.kill.killSessionActive = false
	return true
end

local function getTeleportQueue()
	local environment = getgenv and getgenv() or _G
	local queue = environment.queue_on_teleport or environment.queueonteleport or queue_on_teleport or queueonteleport
	if type(queue) == "function" then
		return queue
	end
	local synApi = environment.syn
	if type(synApi) == "table" and type(synApi.queue_on_teleport) == "function" then
		return synApi.queue_on_teleport
	end
	return nil
end

local function serverWasVisited(serverId)
	return table.find(ML.State.kill.serverHistory, serverId) ~= nil
end

local function rememberServer(serverId)
	if not serverWasVisited(serverId) then
		ML.State.kill.serverHistory[#ML.State.kill.serverHistory + 1] = serverId
	end
	while #ML.State.kill.serverHistory > 60 do
		table.remove(ML.State.kill.serverHistory, 1)
	end
end

local function isFriendProtected(player)
	if not ML.State.kill.protectFriends or not player or player == LP then
		return false
	end
	return false
end

local function protectedTarget(player)
	if not player or player == LP then return true end
	return isFriendProtected(player)
end

local function matchesKarma(player, mode)
	if not mode then return true end
	if mode == "evil" or mode == "good" then
		local good = ML.getPlayerStat(player, { "goodKarma", "Good Karma" })
		local evil = ML.getPlayerStat(player, { "evilKarma", "Evil Karma" })
		local goodValue = tonumber(good and ML.State.getFunctionalStatValue(good)) or 0
		local evilValue = tonumber(evil and ML.State.getFunctionalStatValue(evil)) or 0
		if mode == "evil" then
			return goodValue > evilValue
		elseif mode == "good" then
			return evilValue > goodValue
		end
	end
	return false
end

local function massKillEnabled()
	return ML.State.kill.auto or ML.State.kill.karmaMode ~= nil
end

local function refreshKillLoop()
	ML.stopThread("killFarm")
	local normalEnabled = (massKillEnabled() or ML.State.kill.targetMode)
	if not normalEnabled then
		return
	end
	ML.startThread("killFarm", function()
		while ML.State.running do
			if ML.State.kill.targetMode then
				local target = ML.State.kill.target and Players:FindFirstChild(ML.State.kill.target)
				if target and target ~= LP and not protectedTarget(target) then
					local character = target.Character
					local root = character and character:FindFirstChild("HumanoidRootPart")
					if root then
						local humanoid = target.Character and target.Character:FindFirstChildWhichIsA("Humanoid")
						if humanoid and humanoid.Health > 0 then
							local punch = ML.getPunch()
							if punch then
								local event = LP:FindFirstChild("muscleEvent")
								if event and event:IsA("RemoteEvent") then
									pcall(event.FireServer, event, "punch", "rightHand")
									pcall(event.FireServer, event, "punch", "leftHand")
								end
								pcall(punch.Activate, punch)
							end
						end
					end
				end
			end
			task.wait(.05)
		end
	end)
end

local function stopKillPositionLock()
	ML.stopThread("killPositionLock")
	ML.State.kill.combatCFrame = nil
	ML.State.kill.lockCFrame = nil
	ML.State.kill.lockCharacter = nil
end

local function startKillPositionLock()
	stopKillPositionLock()
	local character = ML.getCharacter()
	local root = ML.getRoot()
	if character and root then
		ML.State.kill.lockCharacter = character
		ML.State.kill.lockCFrame = root.CFrame
	end
	ML.startThread("killPositionLock", function()
		while ML.State.running and massKillEnabled() do
			local currentCharacter = ML.getCharacter()
			local currentRoot = ML.getRoot()
			if currentCharacter and currentRoot then
				if ML.State.kill.lockCharacter ~= currentCharacter or not ML.State.kill.lockCFrame then
					ML.State.kill.lockCharacter = currentCharacter
					ML.State.kill.lockCFrame = currentRoot.CFrame
				end
				currentRoot.CFrame = ML.State.kill.combatCFrame or ML.State.kill.lockCFrame
				currentRoot.AssemblyLinearVelocity = Vector3.zero
				currentRoot.AssemblyAngularVelocity = Vector3.zero
			end
			RunService.Heartbeat:Wait()
		end
	end)
end

ML.State.setAutoKill = function(enabled)
	if enabled then
		startKillSession()
		ML.State.kill.lastKillAt = os.clock()
		local humanoid = ML.getHumanoid()
		if humanoid and humanoid.WalkSpeed > 0 then ML.State.kill.movementWalkSpeed = humanoid.WalkSpeed end
	end
	ML.State.kill.auto = enabled == true
	if ML.State.kill.auto and not ML.State.kill.brawlBusy then
		ML.State.kill.targetMode = false
		ML.State.kill.karmaMode = nil
		startKillPositionLock()
	else
		stopKillPositionLock()
	end
	refreshKillLoop()
	stopKillSessionIfIdle()
	return true
end

ML.State.setTargetKill = function(enabled)
	local selectedTarget = ML.State.kill.target and Players:FindFirstChild(ML.State.kill.target)
	if enabled and (not selectedTarget or protectedTarget(selectedTarget)) then
		return false
	end
	ML.State.kill.targetMode = enabled == true
	if ML.State.kill.targetMode then
		startKillSession()
		ML.State.kill.auto = false
		ML.State.kill.karmaMode = nil
		startKillPositionLock()
	elseif not massKillEnabled() then
		stopKillPositionLock()
	end
	refreshKillLoop()
	stopKillSessionIfIdle()
	return true
end

ML.State.setKarmaKill = function(mode, enabled)
	if mode ~= "evil" and mode ~= "good" then return false end
	if enabled then
		startKillSession()
		ML.State.kill.karmaMode = mode
	elseif ML.State.kill.karmaMode == mode then
		ML.State.kill.karmaMode = nil
	end
	if ML.State.kill.karmaMode and not ML.State.kill.brawlBusy then
		ML.State.kill.auto = false
		ML.State.kill.targetMode = false
		startKillPositionLock()
	else
		stopKillPositionLock()
	end
	refreshKillLoop()
	stopKillSessionIfIdle()
	return true
end

ML.State.setProtectFriends = function(enabled)
	ML.State.kill.protectFriends = enabled == true
	return true
end

ML.State.stopKills = function()
	ML.State.kill.auto = false
	ML.State.kill.autoWinBrawl = false
	ML.State.kill.karmaMode = nil
	ML.State.kill.targetMode = false
	ML.State.kill.serverHop = false
	ML.stopThread("killFarm")
	ML.stopThread("killServerHop")
	stopKillSessionIfIdle()
end

ML.State.setServerHop = function(enabled)
	ML.State.kill.serverHop = enabled == true
	ML.State.kill.hopNow = false
	ML.State.kill.noTargetsSince = nil
	ML.stopThread("killServerHop")
	if ML.State.kill.serverHop then
		ML.startThread("killServerHop", function()
			while ML.State.running and ML.State.kill.serverHop do
				if ML.State.kill.auto or ML.State.kill.targetMode or ML.State.kill.karmaMode ~= nil then
					local interval = ML.State.kill.serverHopInterval or 50
					local remaining = math.max(0, math.ceil(interval - (os.clock() - (ML.State.kill.lastKillAt or os.clock()))))
					if remaining <= 0 then
						ML.State.kill.hopNow = true
					end
				end
				task.wait(1)
			end
		end)
	end
	return true
end

ML.State.requestServerHop = function()
	return true, "server hop queued"
end

ML.State.playerLooksDangerous = function(player)
	if not player or player == LP then return false end
	local theirs = ML.getPlayerStat(player, { "Kills" })
	local mine = ML.getPlayerStat(LP, { "Kills" })
	local theirKills = tonumber(theirs and ML.State.getFunctionalStatValue(theirs)) or 0
	local myKills = tonumber(mine and ML.State.getFunctionalStatValue(mine)) or 0
	return theirKills >= math.max(5000, myKills * 1.15)
end

ML.State.killerInServer = function()
	for _, player in ipairs(Players:GetPlayers()) do
		if ML.State.playerLooksDangerous(player) then return player end
	end
	return nil
end

ML.State.serverGoalMet = function()
	local mode = ML.State.kill.serverHopMode or "full"
	local count = #Players:GetPlayers()
	if mode == "solo" then return count <= 2, "Servidor solitario listo" end
	if mode == "balanced" then return count >= 8 and count <= 14, "Servidor equilibrado listo" end
	if mode == "full" then return count >= 18, "Servidor lleno listo" end
	return true, "Modo listo"
end

ML.State.previewServerHop = function()
	return { id = "preview", playing = #Players:GetPlayers() }
end

ML.bindNativeAutoLiftButton()

safeUiNotify(UI, {
	Title = "Loaded",
	Content = "Stage 3 combat and kill-state features active.",
	Type = "Success",
	Duration = 2,
})

applyMode("Normal")
debugLog("stage 2 ready")
