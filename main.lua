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

debugLog("exact ML helper layer merged")

safeUiNotify(UI, {
	Title = "Loaded",
	Content = "Stage 2 movement features active.",
	Type = "Success",
	Duration = 2,
})

applyMode("Normal")
debugLog("stage 2 ready")
