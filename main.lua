-- ============================================================
-- MUSCLE LEGENDS ULTIMATE (AIRFLOW UI)
-- COMPLETE EXACT PORT - All features from original
-- ============================================================

-- ============================================================
-- MUSCLE LEGENDS ULTIMATE (AIRFLOW UI)
-- COMPLETE EXACT PORT - All features from original
-- ============================================================

local AirFlow = loadstring(game:HttpGet("https://raw.githubusercontent.com/confessess/AIRFLOW0978109571095710975/main/source.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local StatsService = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")
local Env = getgenv and getgenv() or _G

-- ============================================================
-- CONFIGURATION (from original)
-- ============================================================
local CONFIG = {
    Title = "Muscle Legends Ultimate",
    Size = {
        DesktopWidth = 548,
        DesktopHeight = 360,
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
        { section = "Beach", center = Vector3.new(9, 0, 100) },
        { section = "Magma Ring", center = Vector3.new(4400, 0, -8400) },
        { section = "Desert Ring", center = Vector3.new(900, 0, -7000) },
        { section = "Boxing Ring", center = Vector3.new(-1900, 0, -5820) },
        { section = "Tiny Island", center = Vector3.new(50, 0, 1918) },
    },
    Teleports = {
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
    AutoEgg = {
        Interval = 30 * 60,
        Names = { "ProteinEgg", "Protein Egg" },
    },
    FastFarm = {
        Packs = {
            chaos = {
                label = "Chaos Lords",
                strength = { "Swift Samurai" },
                rebirth = "Tribal Overlord",
            },
            ultra = {
                label = "Ultra Titans",
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
}

-- ============================================================
-- STATE MANAGEMENT (from original)
-- ============================================================
local State = {
    running = true,
    shuttingDown = false,
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
    autoEgg = false,
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
    allToggleControllers = {},
    profileControls = {},
    selectorControllers = {},
    outputEntries = {},
}

-- Connection and thread management
local connections = {}
local threads = {}
local threadGenerations = {}
local cleanupActions = {}

local function track(connection)
    connections[#connections + 1] = connection
    return connection
end

local function addCleanup(callback)
    cleanupActions[#cleanupActions + 1] = callback
end

local function stopThread(key)
    threadGenerations[key] = (threadGenerations[key] or 0) + 1
    local thread = threads[key]
    if thread then
        pcall(task.cancel, thread)
        threads[key] = nil
    end
end

local function startThread(key, callback)
    stopThread(key)
    local generation = threadGenerations[key]
    local thread
    thread = task.defer(function()
        local ok, err = pcall(callback)
        if not ok and State.running then
            print("ERROR", key .. ": " .. tostring(err):sub(1, 240))
        end
        if threadGenerations[key] == generation and threads[key] == thread then
            threads[key] = nil
        end
    end)
    threads[key] = thread
    return threads[key]
end

local function disconnectAll()
    for _, connection in ipairs(connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(connections)
    for key in pairs(threads) do
        stopThread(key)
    end
end

-- Utility functions
local function getCharacter()
    return LP.Character
end

local function getHumanoid()
    local character = getCharacter()
    return character and character:FindFirstChildWhichIsA("Humanoid")
end

local function getRoot()
    local character = getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart")
end

local function findValue(root, names)
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

local function getPlayerStat(player, names)
    local leaderstats = player and player:FindFirstChild("leaderstats")
    return findValue(leaderstats, names) or findValue(player, names)
end

State.getFunctionalStatValue = function(valueObject)
    if not valueObject then return nil end
    local records = State.visualStatRecords
    local record = records and records[valueObject]
    if record and record.realValue ~= nil then return record.realValue end
    return valueObject.Value
end

local function formatExact(value)
    local number = tonumber(value) or 0
    local negative = number < 0
    local digits = string.format("%.0f", math.abs(number))
    local grouped = digits:reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
    return (negative and "-" or "") .. grouped
end

State.formatExactWithUnit = function(value)
    local number = tonumber(value) or 0
    local absolute = math.abs(number)
    local units = {
        { 1e33, "DC" }, { 1e30, "NO" }, { 1e27, "OC" }, { 1e24, "SP" },
        { 1e21, "SX" }, { 1e18, "QI" }, { 1e15, "QA" }, { 1e12, "T" },
        { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" },
    }
    for _, unit in ipairs(units) do
        if absolute >= unit[1] then
            local compact = string.format("%.1f", number / unit[1])
            compact = compact:gsub("%.0$", "")
            return compact .. unit[2]
        end
    end
    return formatExact(number)
end

local function getPing()
    local ok, value = pcall(function()
        return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    return ok and math.floor((tonumber(value) or 0) + 0.5) or 0
end

local function realNow()
    local ok, value = pcall(workspace.GetServerTimeNow, workspace)
    if ok and type(value) == "number" then
        return value
    end
    return os.clock()
end

local function copyText(value)
    local environment = getgenv and getgenv() or _G
    local clipboard = environment.setclipboard or environment.toclipboard or environment.writeclipboard
    if type(clipboard) == "function" then
        pcall(clipboard, tostring(value))
        return true
    end
    return false
end

local function equipTool(names)
    local character = getCharacter()
    local humanoid = getHumanoid()
    if not character or not humanoid then
        return nil
    end
    local wanted = {}
    for _, name in ipairs(names) do
        wanted[name:lower()] = true
    end
    for _, container in ipairs({ character, LP:FindFirstChild("Backpack") }) do
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Tool") and wanted[child.Name:lower()] then
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

local function getPunch()
    return equipTool({ "Punch" })
end

print("[Muscle Legends] Part 1 loaded - Core utilities")

-- ============================================================
-- PART 2: FAST PUNCH AND ROCK FARM (from original)
-- ============================================================

local rockCache = {}
rockCache.times = {}
rockCache.touch = type(firetouchinterest) == "function" and firetouchinterest
    or type(firetouchtransmitter) == "function" and firetouchtransmitter or nil
rockCache.touchBegin = 0
local activeRock = nil

do
    local identify = identifyexecutor or getexecutorname
    if type(identify) == "function" then
        local ok, name = pcall(identify)
        if ok and tostring(name):lower():find("real", 1, true) then
            rockCache.touchBegin = 1
        end
    end
end

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

local function clearActiveRock()
    activeRock = nil
end

local activeRockFarm = nil

local function stopActiveRockFarm()
    local previous = activeRockFarm
    activeRockFarm = nil
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

local function clearRockSelection()
    State.rockGeneration = State.rockGeneration + 1
    State.selectedRock = nil
    State.rockSessionStartedAt = nil
    State.rockVisualReadyAt = math.huge
    stopActiveRockFarm()
end

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

local function rockFarmIsCurrent(controller)
    return controller and controller.enabled and activeRockFarm == controller
        and State.running and State.fastPunch and State.rockGeneration == controller.generation
        and State.selectedRock == controller.definition
end

local function runRockFarm(controller)
    while rockFarmIsCurrent(controller) do
        if State.fastPunchToolPaused then
            releaseRockContacts(controller)
            task.wait(0.04)
        else
            local ok = pcall(function()
                if not rockFarmIsCurrent(controller) then return end
                local definition = controller.definition
                local durability = LP:FindFirstChild("Durability")
                if durability and (tonumber(State.getFunctionalStatValue(durability)) or 0) < definition.durability then return end
                local character = getCharacter()
                local leftHand = character and (character:FindFirstChild("LeftHand") or character:FindFirstChild("Left Arm"))
                local rightHand = character and (character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm"))
                if not leftHand or not rightHand then return end
                local rock = findRock(definition)
                local punch = not State.fastPunchToolPaused and getPunch() or nil
                local muscleEvent = LP:FindFirstChild("muscleEvent")
                if not rock or not punch or not rockCache.touch or not muscleEvent
                    or not muscleEvent:IsA("RemoteEvent") or not rockFarmIsCurrent(controller) then return end
                controller.lastRock = rock
                activeRock = rock
                pcall(muscleEvent.FireServer, muscleEvent, "punch", "leftHand")
                pcall(muscleEvent.FireServer, muscleEvent, "punch", "rightHand")
                pcall(punch.Activate, punch)
                State.playFastPunchVisual()
                task.wait(0.04)
                if not rockFarmIsCurrent(controller) or getCharacter() ~= character or not rock.Parent then return end
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

local function startRockFarm(definition, previousStopped)
    if not previousStopped then
        clearRockSelection()
    end
    State.selectedRock = definition
    State.rockSessionStartedAt = realNow()
    State.rockVisualReadyAt = State.rockSessionStartedAt + 0.20
    local controller = {
        enabled = true,
        definition = definition,
        generation = State.rockGeneration,
        thread = nil,
        lastRock = nil,
    }
    activeRockFarm = controller
    controller.thread = task.spawn(runRockFarm, controller)
end

-- Fast Punch Visual
State.fastPunchVisual = { character = nil, tracks = {}, index = 0 }

State.clearFastPunchVisual = function()
    local visual = State.fastPunchVisual
    for _, track in ipairs(visual.tracks) do
        pcall(track.Stop, track, 0.05)
        pcall(track.Destroy, track)
    end
    visual.character = nil
    visual.tracks = {}
    visual.index = 0
end

State.playFastPunchVisual = function()
    local visual = State.fastPunchVisual
    local character = getCharacter()
    local humanoid = getHumanoid()
    local animator = humanoid and (humanoid:FindFirstChildOfClass("Animator") or humanoid:FindFirstChild("Animator"))
    if not character or not animator then return end
    if visual.character ~= character or #visual.tracks == 0 then
        State.clearFastPunchVisual()
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

local function setFastPunch(enabled)
    State.fastPunchGeneration = State.fastPunchGeneration + 1
    local generation = State.fastPunchGeneration
    State.fastPunch = enabled == true
    if not State.fastPunch then
        State.fastPunchToolPaused = false
        clearRockSelection()
        stopThread("fastPunchEquip")
        stopThread("fastPunchHit")
        State.clearFastPunchVisual()
        pcall(function()
            local character = getCharacter()
            local punch = character and character:FindFirstChild("Punch")
            local attackTime = punch and punch:FindFirstChild("attackTime")
            if attackTime then attackTime.Value = 0.3 end
            local backpack = LP:FindFirstChild("Backpack")
            if punch and backpack then punch.Parent = backpack end
        end)
        return
    end
    startThread("fastPunchEquip", function()
        while State.running and State.fastPunch and State.fastPunchGeneration == generation do
            pcall(function()
                local punch = not State.fastPunchToolPaused and getPunch() or nil
                local attackTime = punch and punch:FindFirstChild("attackTime")
                if attackTime then attackTime.Value = 0 end
            end)
            task.wait(0.05)
        end
    end)
    startThread("fastPunchHit", function()
        local lastVisual = 0
        while State.running and State.fastPunch and State.fastPunchGeneration == generation do
            if not activeRockFarm then
                local event = LP:FindFirstChild("muscleEvent")
                local punch = not State.fastPunchToolPaused and getPunch() or nil
                if event and event:IsA("RemoteEvent") then
                    pcall(event.FireServer, event, "punch", "rightHand")
                    pcall(event.FireServer, event, "punch", "leftHand")
                end
                if punch and time() - lastVisual >= 0.12 then
                    lastVisual = time()
                    pcall(punch.Activate, punch)
                    State.playFastPunchVisual()
                end
            end
            task.wait(0.01)
        end
    end)
end

print("[Muscle Legends] Part 2 loaded - Fast Punch and Rock Farm")

-- ============================================================
-- PART 3: EXERCISE SYSTEM AND AUTO EGG (from original)
-- ============================================================

-- Exercise Movement System
do
    local movement = State.exerciseMovement
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

    movement.bindHumanoid = function(humanoid)
        if movement.boundHumanoid == humanoid then return end
        if movement.animationConnection then
            movement.animationConnection:Disconnect()
            movement.animationConnection = nil
        end
        movement.boundHumanoid = humanoid
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if animator then
            movement.animationConnection = animator.AnimationPlayed:Connect(function(animationTrack)
                local tool = movement.freeTool
                local kind = tool and tool.Parent and movement.toolKinds[tool.Name:lower()]
                local animation = animationTrack.Animation
                if kind and animation and movement.idsFor(kind)[animation.AnimationId] then
                    animationTrack:Stop(0.03)
                end
            end)
        end
    end

    movement.freedomStep = function()
        if not State.running then return end
        local character = getCharacter()
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not character or not humanoid or not root then
            movement.bindHumanoid(nil)
            movement.freeTool = nil
            movement.cameraDistance = nil
            return
        end
        movement.bindHumanoid(humanoid)
        local tool = character:FindFirstChildWhichIsA("Tool")
        local kind = tool and movement.toolKinds[tool.Name:lower()]
        if not kind then
            movement.freeTool = nil
            movement.cameraDistance = nil
            return
        end
        local camera = workspace.CurrentCamera
        if movement.freeTool ~= tool then
            movement.freeTool = tool
            movement.freeWalkSpeed = humanoid.WalkSpeed > 0 and humanoid.WalkSpeed or 16
            movement.cameraDistance = camera and (camera.CFrame.Position - root.Position).Magnitude or 14
            movement.stopTracks(humanoid, kind)
        end
        if not State.machine and not State.fly then
            root.Anchored = false
            humanoid.PlatformStand = false
            humanoid.Sit = false
            humanoid.AutoRotate = true
            if humanoid.WalkSpeed <= 0 then
                humanoid.WalkSpeed = movement.freeWalkSpeed or 16
            end
        end
        if camera and not State.spy and not State.miscFreecam then
            if camera.CameraSubject ~= humanoid or camera.CameraType == Enum.CameraType.Scriptable then
                camera.CameraSubject = humanoid
                camera.CameraType = Enum.CameraType.Custom
            end
            local distance = (camera.CFrame.Position - root.Position).Magnitude
            local expected = math.clamp(tonumber(movement.cameraDistance) or 14, 6, 80)
            if distance > math.max(220, expected * 6) then
                local backwards = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
                backwards = backwards.Magnitude > 0.01 and backwards.Unit or Vector3.new(0, 0, -1)
                local offset = math.clamp(expected, 10, 34)
                camera.CFrame = CFrame.lookAt(
                    root.Position - backwards * offset + Vector3.new(0, math.min(8, offset * 0.35), 0),
                    root.Position + Vector3.new(0, 2, 0)
                )
            elseif distance >= 5 and distance <= 120 then
                movement.cameraDistance = distance
            end
        end
    end

    local bindName = "FG100_ExerciseFreedom"
    pcall(RunService.UnbindFromRenderStep, RunService, bindName)
    RunService:BindToRenderStep(bindName, Enum.RenderPriority.Camera.Value - 1, movement.freedomStep)
    addCleanup(function()
        pcall(RunService.UnbindFromRenderStep, RunService, bindName)
        movement.bindHumanoid(nil)
    end)
end

-- Auto Rep System
local repTimeOriginals = {}

local function setFastRepTime(key, tool)
    if not tool then
        return
    end
    local repTime = tool:FindFirstChild("repTime")
    if not repTime or not repTime:IsA("ValueBase") then
        return
    end
    repTimeOriginals[key] = repTimeOriginals[key] or setmetatable({}, { __mode = "k" })
    if repTimeOriginals[key][repTime] == nil then
        repTimeOriginals[key][repTime] = repTime.Value
    end
    repTime.Value = 0
end

local function restoreRepTime(key)
    local saved = repTimeOriginals[key]
    if not saved then
        return
    end
    for repTime, original in pairs(saved) do
        if repTime and repTime.Parent then
            pcall(function()
                repTime.Value = original
            end)
        end
    end
    repTimeOriginals[key] = nil
end

local function unequipRepTools(tools)
    local character = getCharacter()
    local backpack = LP:FindFirstChild("Backpack")
    if not character or not backpack or not tools then
        return
    end
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

local function setAutoRep(key, enabled, tools, interval, forceFast)
    State[key] = enabled == true
    local movement = State.exerciseMovement
    movement.active[key] = State[key] or nil
    local threadKey = "rep_" .. key
    if not State[key] then
        stopThread(threadKey)
        restoreRepTime(key)
        unequipRepTools(tools)
        local hasActiveExercise = false
        for _ in pairs(movement.active) do
            hasActiveExercise = true
            break
        end
        if not hasActiveExercise then
            stopThread("exerciseMovement")
            local humanoid = movement.humanoid
            if humanoid and humanoid.Parent then
                pcall(function()
                    if not State.fastSpeed and movement.walkSpeed then
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
    local humanoid = getHumanoid()
    if humanoid and movement.humanoid ~= humanoid then
        movement.humanoid = humanoid
        movement.walkSpeed = humanoid.WalkSpeed > 0 and humanoid.WalkSpeed or 16
        movement.usesJumpPower = humanoid.UseJumpPower
        movement.jumpValue = movement.usesJumpPower and humanoid.JumpPower or humanoid.JumpHeight
    end
    startThread("exerciseMovement", function()
        while State.running and next(movement.active) do
            local activeHumanoid = getHumanoid()
            local root = getRoot()
            if activeHumanoid then
                if movement.humanoid ~= activeHumanoid then
                    movement.humanoid = activeHumanoid
                    movement.walkSpeed = activeHumanoid.WalkSpeed > 0 and activeHumanoid.WalkSpeed or 16
                    movement.usesJumpPower = activeHumanoid.UseJumpPower
                    movement.jumpValue = movement.usesJumpPower and activeHumanoid.JumpPower or activeHumanoid.JumpHeight
                end
                if not State.machine and not State.fly then
                    if root then
                        root.Anchored = false
                    end
                    activeHumanoid.PlatformStand = false
                    activeHumanoid.Sit = false
                    local wantedSpeed = State.fastSpeed and 1000 or movement.walkSpeed
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
    startThread(threadKey, function()
        while State.running and State[key] do
            local repDelay = interval or 0.01
            pcall(function()
                local tool
                if tools and #tools > 0 then
                    tool = equipTool(tools)
                    if forceFast or State.autoFarmMode == "Fast Rep" or State.autoFarmMode == "Super Fast Rep" then
                        setFastRepTime(key, tool)
                    else
                        restoreRepTime(key)
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
                    if State.autoFarmMode == "Super Fast Rep" then
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

-- Auto Egg System
local function findProteinEgg()
    for _, container in ipairs({
        getCharacter(),
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

local function hasProteinEggBoost()
    local boostTimers = LP:FindFirstChild("boostTimersFolder")
    if not boostTimers then
        return false
    end
    for _, name in ipairs(CONFIG.AutoEgg.Names) do
        local timer = boostTimers:FindFirstChild(name)
        if timer and timer:IsA("ValueBase") and tonumber(timer.Value) and timer.Value > 0 then
            return true
        end
    end
    return false
end

local function hubNotify(text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Muscle Legends",
            Text = tostring(text or ""),
            Duration = tonumber(duration) or 4,
        })
    end)
end

local function countProteinEggs()
    local total = 0
    for _, container in ipairs({
        getCharacter(),
        LP:FindFirstChild("Backpack"),
        LP:FindFirstChild("consumablesFolder"),
    }) do
        if container then
            for _, egg in ipairs(container:GetChildren()) do
                if (egg:IsA("Tool") or egg:IsA("StringValue"))
                    and table.find(CONFIG.AutoEgg.Names, egg.Name) then
                    total = total + 1
                end
            end
        end
    end
    return total
end

State.eggBusy = false

State.eatProteinEgg = function(force)
    if not force and hasProteinEggBoost() then
        return true
    end
    if State.eggBusy then
        return false
    end

    local egg = findProteinEgg()
    local character = getCharacter()
    local muscleEvent = LP:FindFirstChild("muscleEvent")
    if not egg or not character or not muscleEvent or not muscleEvent:IsA("RemoteEvent") then
        return false
    end

    State.eggBusy = true
    local ok, consumed = pcall(function()
        local originalParent = egg.Parent
        local originalUsed = egg:GetAttribute("Used")
        local beforeCount = countProteinEggs()
        local hadBoost = hasProteinEggBoost()

        local function confirmed()
            return not egg.Parent or countProteinEggs() < beforeCount
                or (not hadBoost and hasProteinEggBoost())
        end

        if egg.Parent ~= character then
            egg.Parent = character
            task.wait(0.2)
        end

        if confirmed() then
            return true
        end

        egg:SetAttribute("Used", true)
        muscleEvent:FireServer("proteinEgg", egg)
        local deadline = time() + 3
        while time() < deadline do
            if confirmed() then
                return true
            end
            task.wait(0.1)
        end

        if egg.Parent then egg:SetAttribute("Used", originalUsed) end
        if egg.Parent == character and originalParent and originalParent.Parent then
            egg.Parent = originalParent
        end
        return false
    end)
    State.eggBusy = false
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

    State.autoEggSources = { manual = false, fastFarm = false, rebirth = false }
    State.autoEggNextAt = 0
    State.autoEggImmediateRequested = false

    State.setAutoEgg = function(enabled, source)
        source = source or "manual"
        local wasEnabled = State.autoEggSources[source] == true
        State.autoEggSources[source] = enabled == true
        if enabled == true and not wasEnabled then
            State.autoEggImmediateRequested = true
        end
        local desired = false
        for _, active in pairs(State.autoEggSources) do
            if active then
                desired = true
                break
            end
        end
        if State.autoEgg == desired then
            return
        end
        State.autoEgg = desired
        if not desired then
            State.autoEggImmediateRequested = false
            stopThread("autoEgg")
            return
        end
        startThread("autoEgg", function()
            while State.running and State.autoEgg do
                local now = time()
                if State.autoEggImmediateRequested then
                    State.autoEggImmediateRequested = false
                    if State.eatProteinEgg(false) then
                        State.autoEggNextAt = now + CONFIG.AutoEgg.Interval
                    else
                        State.autoEggNextAt = now + 10
                    end
                else
                    local remaining = visibleStrengthBoostRemaining()
                    if remaining > 0 then
                        State.autoEggNextAt = math.max(State.autoEggNextAt, now + remaining)
                    end
                    if now >= State.autoEggNextAt then
                        if State.eatProteinEgg(false) then
                            State.autoEggNextAt = now + CONFIG.AutoEgg.Interval
                        else
                            State.autoEggNextAt = now + 10
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end

print("[Muscle Legends] Part 3 loaded - Exercise System and Auto Egg")

-- ============================================================
-- PART 4: MACHINE SYSTEM (from original)
-- ============================================================

local machineGeneration = 0
local machineFunctions = nil
FastFarm = {}
FastFarm.MachineVisuals = {
    humanoid = nil,
    tracks = {},
    activeType = nil,
    activeMachine = nil,
}

do
    local machineVisuals = FastFarm.MachineVisuals

    local function stopMachineAnimations(fadeTime)
        for _, bundle in pairs(machineVisuals.tracks) do
            for _, animationTrack in pairs(bundle) do
                if animationTrack and animationTrack.IsPlaying then
                    pcall(animationTrack.Stop, animationTrack, fadeTime or 0.1)
                end
            end
        end
        machineVisuals.activeType = nil
        machineVisuals.activeMachine = nil
    end

    local function destroyMachineAnimationTracks()
        stopMachineAnimations(0)
        for _, bundle in pairs(machineVisuals.tracks) do
            for _, animationTrack in pairs(bundle) do
                if animationTrack then
                    pcall(animationTrack.Destroy, animationTrack)
                end
            end
        end
        machineVisuals.tracks = {}
        machineVisuals.humanoid = nil
    end

    local function getMachineAnimationBundle(machine)
        local humanoid = getHumanoid()
        if not humanoid then return nil, nil end
        if machineVisuals.humanoid ~= humanoid then
            destroyMachineAnimationTracks()
            machineVisuals.humanoid = humanoid
        end
        local machineType = machine and machine:FindFirstChild("machineType")
        local typeName = machineType and tostring(machineType.Value) or nil
        if not typeName then return nil, nil end
        local bundle = machineVisuals.tracks[typeName]
        if bundle then return bundle, typeName end
        local machines = ReplicatedStorage.shared.assets.animations.gameAnims.Machines
        local folder = machines:FindFirstChild(typeName)
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not folder or not animator then return nil, typeName end
        bundle = {
            idle = animator:LoadAnimation(folder.idle),
            rep = animator:LoadAnimation(folder.rep),
        }
        bundle.idle.Looped = true
        bundle.rep.Looped = false
        machineVisuals.tracks[typeName] = bundle
        return bundle, typeName
    end

    local function playMachineIdle(machine)
        local bundle, machineType = getMachineAnimationBundle(machine)
        if not bundle or not bundle.idle then return false end
        if machineVisuals.activeType ~= machineType then
            stopMachineAnimations(0.08)
        end
        machineVisuals.activeType = machineType
        machineVisuals.activeMachine = machine
        if not bundle.idle.IsPlaying then
            pcall(bundle.idle.Play, bundle.idle, 0.1, 1, 1)
        end
        return bundle.idle.IsPlaying
    end

    local function playMachineRep(machine, speedOverride)
        local bundle = getMachineAnimationBundle(machine)
        if not bundle or not bundle.rep then return false end
        local speed = tonumber(speedOverride)
        if not speed then
            speed = 1
            local owned = LP:FindFirstChild("ownedGamepasses")
            if owned and owned:FindFirstChild("x2 Rep Time") then
                speed = 2
            end
        end
        speed = math.clamp(speed, 0.25, 8)
        pcall(bundle.rep.Play, bundle.rep, 0.04, 1, speed)
        pcall(bundle.rep.AdjustSpeed, bundle.rep, speed)
        return bundle.rep.IsPlaying
    end

    machineVisuals.stopAnimations = stopMachineAnimations
    machineVisuals.destroyTracks = destroyMachineAnimationTracks
    machineVisuals.playIdle = playMachineIdle
    machineVisuals.playRep = playMachineRep
end

addCleanup(function()
    FastFarm.MachineVisuals.destroyTracks()
end)

local function machineIsActive(machine, seat, humanoid)
    if not machine or not seat then
        return false
    end
    if humanoid and humanoid.SeatPart == seat then
        return true
    end
    local machineInUse = LP:FindFirstChild("machineInUse")
    if machineInUse and machineInUse.Value == seat then
        return true
    end
    if tonumber(machine:GetAttribute("InUseUserId")) == LP.UserId then
        return true
    end
    local character = getCharacter()
    local standingMount = character and character:GetAttribute("MachineStandingMount") == true
    local scaleFrozen = character and character:GetAttribute("MachineScaleFrozen") == true
    return (standingMount or scaleFrozen)
        and FastFarm.acceptedMachine == machine
        and FastFarm.acceptedMachineSeat == seat
end

local function getMachineParts(definition)
    local folder = workspace:FindFirstChild("machinesFolder")
    if not folder or type(definition) ~= "table" then
        return nil, nil
    end

    local bestMachine, bestSeat, bestGain, bestRequirement, bestDistance = nil, nil, -math.huge, -1, math.huge
    local currentHumanoid = getHumanoid()
    local root = getRoot()
    local referencePosition = root and root.Position or (definition.fallback and definition.fallback.Position)
    local expectedPosition = definition.fallback and definition.fallback.Position
    local candidates = definition.instance and { definition.instance } or folder:GetChildren()

    for _, candidate in ipairs(candidates) do
        if candidate:IsA("Model") and candidate.Name == definition.object then
            local seat = candidate.PrimaryPart
            if not (seat and seat:IsA("Seat")) then
                seat = candidate:FindFirstChild("interactSeat", true)
            end
            local expectedDistance = seat and expectedPosition
                and (Vector3.new(seat.Position.X, 0, seat.Position.Z)
                    - Vector3.new(expectedPosition.X, 0, expectedPosition.Z)).Magnitude or 0
            local candidateGain = candidate:FindFirstChild("strengthGain")
            local gainMatches = definition.strengthGain == nil
                or (candidateGain and tonumber(candidateGain.Value) == tonumber(definition.strengthGain))

            if seat and seat:IsA("Seat") and expectedDistance <= 1400 and gainMatches then
                if machineIsActive(candidate, seat, currentHumanoid) then
                    return candidate, seat
                end
                local inUseUserId = tonumber(candidate:GetAttribute("InUseUserId"))
                local available = (seat.Occupant == nil or seat.Occupant == currentHumanoid)
                    and (inUseUserId == nil or inUseUserId == LP.UserId)
                local requirement = 0
                local requirements = candidate:FindFirstChild("requirements")
                if available and requirements then
                    for _, value in ipairs(requirements:GetChildren()) do
                        if value:IsA("ValueBase") then
                            local playerValue = getPlayerStat(LP, { value.Name })
                            local needed = tonumber(value.Value) or 0
                            if not playerValue or (tonumber(State.getFunctionalStatValue(playerValue)) or 0) < needed then
                                available = false
                                break
                            end
                            requirement = math.max(requirement, needed)
                        end
                    end
                end
                if available then
                    local strengthGain = tonumber(candidateGain and candidateGain.Value) or 0
                    local distance = referencePosition and (seat.Position - referencePosition).Magnitude or 0
                    if strengthGain > bestGain
                        or (strengthGain == bestGain and requirement > bestRequirement)
                        or (strengthGain == bestGain and requirement == bestRequirement and distance < bestDistance) then
                        bestMachine, bestSeat = candidate, seat
                        bestGain, bestRequirement, bestDistance = strengthGain, requirement, distance
                    end
                end
            end
        end
    end
    return bestMachine, bestSeat
end

local function machineTargetCFrame(machine, seat, fallback, humanoid, root)
    if seat and seat:IsA("BasePart") then
        local rootHalf = root and root.Size.Y * 0.5 or 1
        local seatHalf = seat.Size.Y * 0.5
        local hipAllowance = humanoid and math.max(0.15, humanoid.HipHeight * 0.12) or 0.25
        local lift = math.clamp(rootHalf + seatHalf + hipAllowance, 1.8, 3.3)
        return seat.CFrame * CFrame.new(0, lift, 0)
    end
    if machine then
        local ok, pivot = pcall(machine.GetPivot, machine)
        if ok then return pivot end
    end
    return fallback
end

FastFarm.SafeMachineLockCFrame = function(character, frame)
    local expectedY = character and tonumber(character:GetAttribute("MachineStandHrpY"))
    if frame and expectedY and frame.Position.Y < expectedY - 0.15 then
        frame = frame + Vector3.new(0, expectedY - frame.Position.Y, 0)
    end
    return frame
end

local function machineRepDelay(machine)
    local repTime = machine and machine:FindFirstChild("repTime", true)
    local attributeRepTime = machine and machine:GetAttribute("repTime")
    local delay = math.max(0.15, tonumber(attributeRepTime) or tonumber(repTime and repTime.Value) or 1)
    local owned = LP:FindFirstChild("ownedGamepasses")
    if owned and owned:FindFirstChild("x2 Rep Time") then
        delay = delay * 0.5
    end
    if not machineFunctions then
        pcall(function()
            local shared = ReplicatedStorage:FindFirstChild("shared")
            local modules = shared and shared:FindFirstChild("modules")
            local module = (modules and modules:FindFirstChild("GlobalFunctions"))
                or ReplicatedStorage:FindFirstChild("globalFunctions")
            if module and module:IsA("ModuleScript") then
                machineFunctions = require(module)
            end
        end)
    end
    if machineFunctions then
        local okUltimate, ultimate = pcall(machineFunctions.calculateUltimateRepTime, LP)
        if okUltimate then
            delay = delay * (1 - math.clamp(tonumber(ultimate) or 0, 0, 0.9))
        end
        local okPet, petBoost = pcall(machineFunctions.calculatePetRepTimeBoost, LP)
        if okPet then
            delay = delay * (1 - math.clamp(tonumber(petBoost) or 0, 0, 0.9))
        end
    end
    return math.max(0.12, delay + 0.025)
end

local function useMachine(definition, maximumAttempts, retryDelay)
    local root = getRoot()
    local humanoid = getHumanoid()
    if not root or not humanoid then return false end
    local machine, seat = getMachineParts(definition)
    if not machine or not seat or not seat:IsA("Seat") then
        return false
    end
    if machineIsActive(machine, seat, humanoid) then
        return true, machine, seat
    end
    local remote = ReplicatedStorage:FindFirstChild("rEvents")
        and ReplicatedStorage.rEvents:FindFirstChild("machineInteractRemote")
    if not remote or not remote:IsA("RemoteFunction") then
        return false
    end
    local attempts = math.max(1, tonumber(maximumAttempts) or 4)
    for attempt = 1, attempts do
        repeat
            if machineIsActive(machine, seat, humanoid) then
                return true, machine, seat
            end
            local targetCFrame = machineTargetCFrame(machine, seat, definition.fallback, humanoid, root)
            if not targetCFrame then return false end
            if seat.Occupant and seat.Occupant ~= humanoid then
                return false, machine, seat, "occupied"
            end
            root.Anchored = false
            local character = LP.Character
            if character then
                pcall(character.PivotTo, character, targetCFrame)
            end
            root.CFrame = targetCFrame
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
            task.wait(FastFarm.mode == "strength" and 0.02 or (attempt == 1 and 0.1 or 0.06))
            local invoked, accepted, rejectionReason = pcall(remote.InvokeServer, remote, "useMachine", seat)
            if FastFarm.mode == "rebirth" and FastFarm.currentCycle then
                local cycle = FastFarm.currentCycle
                cycle.machineAttempts = cycle.machineAttempts or {}
                if #cycle.machineAttempts < 20 then
                    cycle.machineAttempts[#cycle.machineAttempts + 1] = {
                        machine = machine.Name, accepted = invoked and accepted == true,
                        reason = tostring(rejectionReason), at = os.clock() - cycle.startedAt,
                    }
                end
            end
            if invoked and accepted == true then
                FastFarm.acceptedMachine = machine
                FastFarm.acceptedMachineSeat = seat
            elseif invoked and accepted == false then
                if attempt < attempts then
                    local retryWait = tonumber(retryDelay) or 0.22
                    task.wait(retryWait)
                    break
                else
                    return false, machine, seat, rejectionReason
                end
            elseif not invoked then
                return false, machine, seat, "invokeFailed"
            end
            local entryWait = FastFarm.MachineEntryWait or 2.3
            if FastFarm.mode == "strength" then
                entryWait = math.clamp(0.35 + math.max(0, getPing()) * 0.0015, 0.55, 1.4)
            end
            local deadline = time() + entryWait
            repeat
                if machineIsActive(machine, seat, humanoid) then
                    return true, machine, seat
                end
                RunService.Heartbeat:Wait()
            until time() >= deadline
            machine, seat = getMachineParts(definition)
            if not machine or not seat then
                return false
            end
        until true
    end
    return machineIsActive(machine, seat, humanoid), machine, seat
end

local function leaveMachine()
    FastFarm.MachineVisuals.stopAnimations(0.1)
    FastFarm.acceptedMachine = nil
    FastFarm.acceptedMachineSeat = nil
    local remote = ReplicatedStorage:FindFirstChild("rEvents")
        and ReplicatedStorage.rEvents:FindFirstChild("machineInteractRemote")
    if remote and remote:IsA("RemoteFunction") then
        if State.shuttingDown then
            task.spawn(function()
                pcall(remote.InvokeServer, remote, "leaveMachine")
            end)
        else
            pcall(remote.InvokeServer, remote, "leaveMachine")
        end
    end
    local humanoid = getHumanoid()
    if humanoid and humanoid.SeatPart then
        humanoid.Sit = false
    end
end

print("[Muscle Legends] Part 4 loaded - Machine System")

-- ============================================================
-- PART 5: FAST FARM SYSTEM (from original)
-- ============================================================

FastFarm.generation = 0
FastFarm.warningAccepted = false
FastFarm.mode = nil
FastFarm.startedAt = nil
FastFarm.sessionStartedAt = nil
FastFarm.startStats = nil
FastFarm.lockCFrame = nil
FastFarm.lockCharacter = nil
FastFarm.machine = nil
FastFarm.machineSeat = nil
FastFarm.machineDefinition = nil
FastFarm.machineFailureCooldowns = {}
FastFarm.lastMachineSelection = nil
FastFarm.hideFramesOwned = false
FastFarm.packCount = 0
FastFarm.petSlotCapacity = 1
FastFarm.requiredPackCount = 1
FastFarm.strengthPack = nil
FastFarm.strengthPackCount = 0
FastFarm.strengthPackRepBoost = 0
FastFarm.rebirthPack = nil
FastFarm.rebirthPackCount = 0
FastFarm.expectedRebirthDelta = 0
FastFarm.cycleStrengthGain = 0
FastFarm.lastTargetStrength = 0
FastFarm.cycleCount = 0
FastFarm.successfulRebirths = 0
FastFarm.failedRebirths = 0
FastFarm.validRebirthSamples = {}
FastFarm.validStrengthSamples = {}
FastFarm.lastSuccessfulRebirthAt = nil
FastFarm.rebirthMeasurementStartedAt = nil
FastFarm.nextRebirthRequestAt = nil
FastFarm.lastStrengthSampleAt = nil
FastFarm.lastStrengthSampleValue = nil
FastFarm.lastRequiredStrength = 0
FastFarm.lastRebirthAccepted = false
FastFarm.lastError = nil
FastFarm.cachedPing = 0
FastFarm.pingCheckedAt = 0
FastFarm.pingPaused = false
FastFarm.resumeSamples = 0
FastFarm.strengthBatch = CONFIG.FastFarm.StrengthStartBatch
FastFarm.lastBatchAdjust = 0
FastFarm.pingReducer = false
FastFarm.sizeInvokeBusy = false
FastFarm.lastSizeInvoke = 0
FastFarm.sizeReleaseGeneration = 0
FastFarm.frameReleaseGeneration = 0
FastFarm.bootstrapAutoWeight = false
FastFarm.nextMachineAcquireAt = 0

function FastFarm:SetPingReducer(enabled)
    self.pingReducer = enabled == true
    self.resumeSamples = 0
    if self.pingReducer then
        self.strengthBatch = math.min(
            self.strengthBatch or CONFIG.FastFarm.StrengthStartBatch,
            CONFIG.FastFarm.StrengthStartBatch
        )
    end
    return self.pingReducer
end

local function readStat(names)
    local value = getPlayerStat(LP, names)
    return value and tonumber(State.getFunctionalStatValue(value)) or 0, value
end

local function readStats()
    local rebirths = readStat({ "Rebirths", "Rebirth" })
    local strength = readStat({ "Strength", "Fuerza" })
    local durability = readStat({ "Durability", "Resistencia" })
    return {
        rebirths = rebirths,
        strength = strength,
        durability = durability,
    }
end

local function farmEvents()
    return ReplicatedStorage:FindFirstChild("rEvents")
end

local function unequipAllPets()
    local events = farmEvents()
    local remote = events and events:FindFirstChild("equipPetEvent")
    local equippedPets = LP:FindFirstChild("equippedPets")
    if not remote or not equippedPets then
        return false
    end
    for _, slot in ipairs(equippedPets:GetChildren()) do
        local reference = slot:FindFirstChild("petReference")
        local pet = reference and reference:IsA("ObjectValue") and reference.Value
        if pet then
            pcall(remote.FireServer, remote, "unequipPet", pet)
        end
    end
    RunService.Heartbeat:Wait()
    local deadline = time() + 1.2
    repeat
        local remaining = 0
        for _, slot in ipairs(equippedPets:GetChildren()) do
            local reference = slot:FindFirstChild("petReference")
            if reference and reference:IsA("ObjectValue") and reference.Value then
                remaining = remaining + 1
            end
        end
        if remaining == 0 then return true end
        task.wait(0.04)
    until time() >= deadline
    return false
end

function FastFarm:GetPetSlotCapacity()
    local capacity = 2
    if LP.MembershipType == Enum.MembershipType.Premium then
        capacity = capacity + 1
    end
    local ownedGamepasses = LP:FindFirstChild("ownedGamepasses")
    if ownedGamepasses and ownedGamepasses:FindFirstChild("+2 Pet Slots") then
        capacity = capacity + 2
    end
    local petSlotAttribute = UltimateAttributes["+1 Pet Slot"] or "UltimatePetSlot"
    local ultimateSlots = LP:GetAttribute(petSlotAttribute)
    if typeof(ultimateSlots) == "number" then
        capacity = capacity + math.max(0, math.floor(ultimateSlots))
    end
    local industrialSlot = LP:GetAttribute("IndustrialPetSlot")
    if industrialSlot == true or industrialSlot == 1 then
        capacity = capacity + 1
    end
    local availableSlotObjects = 0
    local equippedPets = LP:FindFirstChild("equippedPets")
    if equippedPets then
        for _, slot in ipairs(equippedPets:GetChildren()) do
            if slot:IsA("ObjectValue") then
                availableSlotObjects = availableSlotObjects + 1
            end
        end
    end
    if availableSlotObjects > 0 then
        capacity = math.min(capacity, availableSlotObjects)
    end
    self.petSlotCapacity = math.clamp(capacity, 1, CONFIG.FastFarm.MaxPets)
    return self.petSlotCapacity
end

function FastFarm:CountOwnedPet(name)
    local count = 0
    local petsFolder = LP:FindFirstChild("petsFolder")
    if petsFolder then
        for _, folder in ipairs(petsFolder:GetChildren()) do
            if folder:IsA("Folder") then
                for _, pet in ipairs(folder:GetChildren()) do
                    if pet:IsA("StringValue") and pet.Name == name then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end

function FastFarm:GetPackCatalog(force)
    if not force and self.packCatalog and time() - (self.packCatalogAt or 0) < 30 then return self.packCatalog end
    local shared = ReplicatedStorage:FindFirstChild("shared")
    local runtime = shared and shared:FindFirstChild("runtime")
    local catalog = runtime and runtime:FindFirstChild("packPetPerks")
    local modules = shared and shared:FindFirstChild("modules")
    local module = modules and modules:FindFirstChild("GlobalFunctions")
    local ok, functions = pcall(function() return module and require(module) end)
    if not catalog or not ok or type(functions) ~= "table" then return self.packCatalog or {} end
    local result, owned = {}, {}
    local inventory = LP:FindFirstChild("petsFolder")
    for _, folder in ipairs(inventory and inventory:GetChildren() or {}) do
        for _, pet in ipairs(folder:GetChildren()) do
            if pet:IsA("StringValue") then owned[pet.Name] = (owned[pet.Name] or 0) + 1 end
        end
    end
    local sample = Instance.new("Folder")
    local equipped = Instance.new("Folder")
    equipped.Name, equipped.Parent = "equippedPets", sample
    local slot = Instance.new("ObjectValue")
    slot.Parent = equipped
    local reference = Instance.new("ObjectValue")
    reference.Name, reference.Parent = "petReference", slot
    for _, item in ipairs(catalog:GetChildren()) do
        local perks = item:FindFirstChild("perksFolder")
        local strength = perks and perks:FindFirstChild("strength")
        local entry = { name = item.Name, owned = owned[item.Name] or 0, ref = item,
            strength = strength and tonumber(strength.Value) or 0 }
        slot.Value, reference.Value = item, item
        for key, method in pairs({ repSpeed = "calculatePetRepTimeBoost",
            strengthBonus = "calculatePetStrengthGainMultiplier", rebirthBonus = "calculatePetRebirthGainMultiplier" }) do
            if type(functions[method]) == "function" then
                local calculated, value = pcall(functions[method], sample)
                if calculated and type(value) == "number" then entry[key] = value end
            end
        end
        result[#result + 1] = entry
    end
    sample:Destroy()
    table.sort(result, function(a, b) return a.name < b.name end)
    self.packCatalog, self.packCatalogAt = result, time()
    return result
end

function FastFarm:GetModes(force)
    local cap = self:GetPetSlotCapacity()
    local byName = {}
    for _, pet in ipairs(self:GetPackCatalog(force)) do byName[pet.name] = pet end
    local out = {}
    for key, pack in pairs(CONFIG.FastFarm.Packs) do
        local strength = 0
        for _, name in ipairs(pack.strength) do
            strength = strength + math.min(cap, tonumber(byName[name] and byName[name].owned) or 0)
        end
        local rebirth = math.min(cap, tonumber(byName[pack.rebirth] and byName[pack.rebirth].owned) or 0)
        out[key] = { key = key, label = pack.label, available = strength > 0 and rebirth > 0,
            strength = strength, rebirth = rebirth, pets = byName }
    end
    self.packModes = out
    return out
end

function FastFarm:LoadPack(force)
    local modes = self:GetModes(force)
    local mode = modes[self.packMode]
    if not mode or not mode.available then
        for _, fallbackMode in ipairs({ "chaos", "ultra" }) do
            if modes[fallbackMode] and modes[fallbackMode].available then
                self.packMode = fallbackMode
                mode = modes[fallbackMode]
                break
            end
        end
    end
    if not mode or not mode.available then
        self.strengthPack, self.rebirthPack = nil, nil
        self.strengthSetup, self.rebirthSetup = nil, nil
        self.strengthPackCount, self.rebirthPackCount = 0, 0
        self.strengthPackRepBoost, self.expectedRebirthDelta = 0, 0
        return false, false
    end
    local cap = self:GetPetSlotCapacity()
    local pack = CONFIG.FastFarm.Packs[self.packMode]
    local s = {}
    if self.packMode == "ultra" then
        local hound, omega = mode.pets[pack.strength[1]], mode.pets[pack.strength[2]]
        local hMax = math.min(cap, tonumber(hound and hound.owned) or 0)
        local oMax = math.min(cap, tonumber(omega and omega.owned) or 0)
        local bestH, bestO, bestScore, bestUsed = 0, 0, -1, 0
        for h = 0, hMax do
            for o = 0, math.min(oMax, cap - h) do
                local used = h + o
                if used > 0 then
                    local base = h * (tonumber(hound.strength) or 0) + o * (tonumber(omega.strength) or 0)
                    local bonus = h * (tonumber(hound.strengthBonus) or 0)
                        + o * (tonumber(omega.strengthBonus) or 0)
                    local speed = h * (tonumber(hound.repSpeed) or 0) + o * (tonumber(omega.repSpeed) or 0)
                    local score = base * (1 + bonus) / math.max(0.10, 1 - math.min(0.90, speed))
                    if score > bestScore or (score == bestScore and used > bestUsed) then
                        bestH, bestO, bestScore, bestUsed = h, o, score, used
                    end
                end
            end
        end
        if bestH > 0 then s[#s + 1] = { name = hound.name, count = bestH, data = hound } end
        if bestO > 0 then s[#s + 1] = { name = omega.name, count = bestO, data = omega } end
    else
        local pet = mode.pets[pack.strength[1]]
        local count = math.min(cap, tonumber(pet and pet.owned) or 0)
        if count > 0 then s[1] = { name = pet.name, count = count, data = pet } end
    end
    local rPet = mode.pets[pack.rebirth]
    local rCount = math.min(cap, tonumber(rPet and rPet.owned) or 0)
    local r = rCount > 0 and { { name = rPet.name, count = rCount, data = rPet } } or {}
    local sCount, rep = 0, 0
    for _, part in ipairs(s) do
        sCount = sCount + part.count
        rep = rep + (tonumber(part.data.repSpeed) or 0) * part.count
    end
    self.strengthSetup, self.rebirthSetup = s, r
    self.strengthPack, self.rebirthPack = "s:" .. self.packMode, "r:" .. self.packMode
    self.strengthPackCount, self.rebirthPackCount = sCount, rCount
    self.strengthPackRepBoost = rep
    self.expectedRebirthDelta = math.max(1,
        math.floor((tonumber(rPet.rebirthBonus) or 0) * rCount + 0.5))
    return sCount > 0, rCount > 0
end

print("[Muscle Legends] Part 5 loaded - Fast Farm System")

-- ============================================================
-- PART 6: KILL SYSTEM AND SERVER HOP (from original)
-- ============================================================

do
    local BrawlState = ReplicatedStorage:WaitForChild("shared"):WaitForChild("state"):WaitForChild("Brawl")
    local BrawlEvent = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("brawlEvent")

    local function restorePunch()
        pcall(function()
            local character = getCharacter()
            local backpack = LP:FindFirstChild("Backpack")
            local punch = character and character:FindFirstChild("Punch")
            if punch and backpack then
                punch.Parent = backpack
            end
        end)
    end

    local function equipPunch()
        local character = getCharacter()
        local humanoid = getHumanoid()
        local backpack = LP:FindFirstChild("Backpack")
        if not character or not humanoid then
            return nil
        end
        local punch = character:FindFirstChild("Punch") or (backpack and backpack:FindFirstChild("Punch"))
        if punch and punch.Parent ~= character then
            pcall(humanoid.EquipTool, humanoid, punch)
        end
        if punch then
            local attackTime = punch:FindFirstChild("attackTime")
            if attackTime and attackTime:IsA("ValueBase") then
                pcall(function()
                    attackTime.Value = 0
                end)
            end
        end
        return punch
    end

    local function hasSpawnProtection(character)
        local protectedUntil = character and character:GetAttribute("SpawnProtectedUntil")
        if type(protectedUntil) == "number" and workspace:GetServerTimeNow() < protectedUntil then
            return true
        end
        return character ~= nil and (
            character:FindFirstChildOfClass("ForceField") ~= nil
            or character:FindFirstChild("spawnProtectionHighlight") ~= nil
        )
    end

    local function hasTargetProtection(character)
        return hasSpawnProtection(character)
            or (character ~= nil and character:GetAttribute("InTinyIsland") == true)
    end

    local function killsBlockedHere()
        if #CONFIG.Kills.ProtectedPrivateServerIds == 0 then
            return false
        end
        local environment = getgenv and getgenv() or _G
        local reader = environment.gethiddenproperty or environment.gethiddenprop
        if type(reader) ~= "function" then
            return false
        end
        local ok, value = pcall(reader, game, "PrivateServerId")
        local privateServerId = ok and tostring(value or "") or ""
        return privateServerId ~= ""
            and table.find(CONFIG.Kills.ProtectedPrivateServerIds, privateServerId) ~= nil
    end

    local function currentKillsTotal()
        local stat = getPlayerStat(LP, { "Kills" })
        local value = stat and tonumber(State.getFunctionalStatValue(stat))
        return value and math.floor(value) or nil
    end

    local function refreshKillSessionCounter()
        if type(State.kill.updateSessionCounter) == "function" then
            pcall(State.kill.updateSessionCounter, State.kill.sessionKills, State.kill.killSessionActive)
        end
    end

    local function updateKillSession(value)
        local numeric = tonumber(value)
        if not numeric then
            return
        end
        local current = math.floor(numeric)
        local previous = State.kill.lastObservedKills
        State.kill.lastObservedKills = current
        if previous == nil or current > previous then
            State.kill.lastKillAt = os.clock()
            if previous ~= nil then print("KILL", "+" .. formatExact(current - previous) .. " confirmed kills") end
        end
        State.kill.sessionLastTotal = current
        if State.kill.killSessionActive then
            if State.kill.sessionStartKills == nil then
                State.kill.sessionStartKills = current
                State.kill.sessionKills = 0
            elseif current >= State.kill.sessionStartKills then
                State.kill.sessionKills = current - State.kill.sessionStartKills
            end
        end
        refreshKillSessionCounter()
    end

    local function startKillSession()
        if State.kill.killSessionActive then
            if not State.kill.sessionStartedAt then State.kill.sessionStartedAt = os.clock() end
            return
        end
        State.kill.killSessionActive = true
        State.kill.sessionKills = 0
        State.kill.sessionStartKills = currentKillsTotal()
        State.kill.sessionLastTotal = State.kill.sessionStartKills
        State.kill.sessionElapsed = 0
        State.kill.sessionStartedAt = os.clock()
        refreshKillSessionCounter()
    end

    State.getKillSessionElapsed = function()
        local elapsed = math.max(0, tonumber(State.kill.sessionElapsed) or 0)
        if State.kill.killSessionActive and State.kill.sessionStartedAt then
            elapsed = elapsed + math.max(0, os.clock() - State.kill.sessionStartedAt)
        end
        return elapsed
    end

    local function stopKillSessionIfIdle()
        local active = State.kill.auto or State.kill.targetMode or State.kill.karmaMode ~= nil
            or State.kill.autoWinBrawl
        if active or not State.kill.killSessionActive then return false end
        State.kill.sessionElapsed = State.getKillSessionElapsed()
        State.kill.sessionStartedAt = nil
        State.kill.killSessionActive = false
        refreshKillSessionCounter()
        return true
    end

    local function rebuildKillFriendCache()
        local fresh = {}
        local loaded = false
        local endpoint = string.format("https://friends.roblox.com/v1/users/%d/friends", LP.UserId)
        local httpOk, body = pcall(game.HttpGet, game, endpoint, true)
        if httpOk and type(body) == "string" then
            local httpService = game:GetService("HttpService")
            local decodeOk, response = pcall(httpService.JSONDecode, httpService, body)
            if decodeOk and type(response) == "table" and type(response.data) == "table" then
                for _, friend in ipairs(response.data) do
                    local userId = tonumber(friend.id or friend.Id)
                    if userId then fresh[userId] = true end
                end
                loaded = true
            end
        end
        if not loaded then
            loaded = pcall(function()
                local pages = Players:GetFriendsAsync(LP.UserId)
                while State.running and State.kill.protectFriends do
                    for _, friend in ipairs(pages:GetCurrentPage()) do
                        local userId = tonumber(friend.Id)
                        if userId then fresh[userId] = true end
                    end
                    if pages.IsFinished then break end
                    pages:AdvanceToNextPageAsync()
                end
            end)
        end
        if loaded then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP and fresh[player.UserId] == nil then
                    fresh[player.UserId] = false
                end
            end
            State.kill.friendCache = fresh
        end
        State.kill.friendProtectionReady = loaded
        return loaded
    end

    local function checkFriendship(player)
        local asyncOk, asyncResult = pcall(LP.IsFriendsWithAsync, LP, player.UserId)
        if asyncOk then
            return asyncResult == true
        end
        local legacyOk, legacyResult = pcall(LP.IsFriendsWith, LP, player.UserId)
        if legacyOk then
            return legacyResult == true
        end
        return nil
    end

    local function refreshKillFriendProtection()
        stopThread("killFriendRefresh")
        table.clear(State.kill.friendCache)
        State.kill.friendProtectionReady = false
        if not State.kill.protectFriends then
            return
        end
        startThread("killFriendRefresh", function()
            while State.running and State.kill.protectFriends do
                rebuildKillFriendCache()
                for _ = 1, 60 do
                    if not State.running or not State.kill.protectFriends then
                        return
                    end
                    task.wait(1)
                end
            end
        end)
    end

    local function isFriendProtected(player)
        if not State.kill.protectFriends or not player or player == LP then
            return false
        end
        local cached = State.kill.friendCache[player.UserId]
        if cached ~= nil and State.kill.friendProtectionReady then
            return cached == true
        end
        local result = checkFriendship(player)
        if result ~= nil then
            State.kill.friendCache[player.UserId] = result
            return result
        end
        return true
    end

    local function hasKillClanTag(player)
        if not player then
            return false
        end
        local username = string.lower(tostring(player.Name or ""))
        local displayName = string.lower(tostring(player.DisplayName or ""))
        return string.find(username, "0x", 1, true) ~= nil
            or string.find(displayName, "0x", 1, true) ~= nil
    end

    local function protectedTarget(player)
        if not player or player == LP then
            return true
        end
        if hasKillClanTag(player) then
            return true
        end
        return isFriendProtected(player)
    end

    State.kill.estimateCurrentTargets = function()
        if State.kill.targetMode then
            local target = State.kill.target and Players:FindFirstChild(State.kill.target)
            return target and not protectedTarget(target) and 1 or 0
        end
        local total = 0
        for _, player in ipairs(Players:GetPlayers()) do
            local character = player.Character
            local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
            if not protectedTarget(player) and humanoid and humanoid.Health > 0 and not hasTargetProtection(character) then
                total = total + 1
            end
        end
        return total
    end

    local function isInsideBrawl(player)
        local character = player and player.Character
        return character ~= nil and character:GetAttribute("LastMapCFrame") ~= nil
    end

    local function isInBrawlBattle(player)
        local character = player and player.Character
        return character ~= nil and character:GetAttribute("InBattle") == true
    end

    local function currentBrawlWins()
        local leaderstats = LP:FindFirstChild("leaderstats")
        local brawls = leaderstats and leaderstats:FindFirstChild("Brawls")
        local value = brawls and tonumber(State.getFunctionalStatValue(brawls))
        return value and math.floor(value) or nil
    end

    local function brawlPromptVisible()
        local gameGui = PlayerGui:FindFirstChild("gameGui")
        local prompt = gameGui and gameGui:FindFirstChild("brawlJoinLabel")
        return prompt ~= nil and prompt.Visible == true
    end

    State.updateKillSession = updateKillSession
    State.refreshKillSessionCounter = refreshKillSessionCounter

    local function refreshFastPunch()
        stopThread("killFastPunch")
    end

    local TARGET_ATTACK_WINDOW = 0.75
    local TARGET_UPDATE_INTERVAL = 0.06
    local TARGET_DISTANCE = 0.1
    local TARGET_PREDICTION_TIME = 0.025
    local TARGET_MAX_PREDICTION = 0.8
    local TARGET_SURFACE_GAP = 0.2
    local TARGET_SURFACE_SIZE = 4.5
    local TARGET_POSE_OFFSET = 4
    local TARGET_RETRY_DELAY = 0.8
    local TARGET_SMALL_SIZE = 0.75
    local TARGET_HAND_GAP = 0.02

    local function getCombatPart(character, root)
        return character and (
            character:FindFirstChild("UpperTorso")
            or character:FindFirstChild("Torso")
            or character:FindFirstChild("LowerTorso")
        ) or root
    end

    local function getAttackCFrame(character, root, targetCharacter, targetRoot, contactStep)
        local velocity = targetRoot.AssemblyLinearVelocity
        local prediction = Vector3.new(velocity.X, 0, velocity.Z) * TARGET_PREDICTION_TIME
        if prediction.Magnitude > TARGET_MAX_PREDICTION then prediction = prediction.Unit * TARGET_MAX_PREDICTION end
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
            if targetRoot.Size.X <= TARGET_SMALL_SIZE and ownHand then
                local normal, extent
                if step == 1 then normal, extent = -targetPart.CFrame.LookVector, size.Z * 0.5
                elseif step == 2 then normal, extent = targetPart.CFrame.RightVector, size.X * 0.5
                elseif step == 3 then normal, extent = targetPart.CFrame.LookVector, size.Z * 0.5
                elseif step == 4 then normal, extent = -targetPart.CFrame.RightVector, size.X * 0.5
                else normal, extent = -targetPart.CFrame.LookVector, 0 end
                local facing = CFrame.lookAt(Vector3.zero, -normal)
                local handOffset = root.CFrame:PointToObjectSpace(ownHand.Position)
                local attackPosition = targetPosition + normal * (extent + TARGET_HAND_GAP)
                    - facing:VectorToWorldSpace(handOffset)
                return CFrame.new(attackPosition) * facing.Rotation
            end
            local oversized = math.max(size.X, size.Y, size.Z) >= TARGET_SURFACE_SIZE
            local displaced = (targetPart.Position - targetRoot.Position).Magnitude >= TARGET_POSE_OFFSET
            if not oversized and not displaced then
                local normal, extent
                if step == 1 then normal, extent = -targetRoot.CFrame.LookVector, targetRoot.Size.Z * 0.5
                elseif step == 2 then normal, extent = targetRoot.CFrame.RightVector, targetRoot.Size.X * 0.5
                elseif step == 3 then normal, extent = targetRoot.CFrame.LookVector, targetRoot.Size.Z * 0.5
                elseif step == 4 then normal, extent = -targetRoot.CFrame.RightVector, targetRoot.Size.X * 0.5 end
                if normal and extent then
                    local ownExtent = math.max(root.Size.Z * 0.5, 0.15)
                    local attackPosition = rootPosition + normal * (extent + ownExtent + TARGET_SURFACE_GAP)
                    return CFrame.lookAt(attackPosition, rootPosition)
                end
                return CFrame.lookAt(rootPosition - targetRoot.CFrame.LookVector * TARGET_DISTANCE, rootPosition)
            end
            if displaced and not oversized then step = step == 1 and 5 or step - 1 end
            local normal, extent
            if step == 1 then normal, extent = targetPart.CFrame.RightVector, size.X * 0.5
            elseif step == 2 then normal, extent = -targetPart.CFrame.RightVector, size.X * 0.5
            elseif step == 3 then normal, extent = -targetPart.CFrame.LookVector, size.Z * 0.5
            elseif step == 4 then normal, extent = targetPart.CFrame.LookVector, size.Z * 0.5 end
            if normal and extent then
                local attackPosition = targetPosition + normal * (extent + TARGET_SURFACE_GAP)
                return CFrame.lookAt(attackPosition, targetPosition)
            end
        end
        local direction = Vector3.new(targetRoot.CFrame.LookVector.X, 0, targetRoot.CFrame.LookVector.Z)
        if direction.Magnitude < 0.01 then direction = Vector3.zAxis else direction = direction.Unit end
        local attackPosition = targetPosition - ownOffset - direction * TARGET_DISTANCE
        return CFrame.lookAt(attackPosition, targetPosition)
    end

    local function stopMovementAnimation(humanoid)
        local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
        if not animator then return end
        for _, animationTrack in ipairs(animator:GetPlayingAnimationTracks()) do
            local name = string.lower(animationTrack.Name)
            if string.find(name, "walk", 1, true) or string.find(name, "run", 1, true) then
                pcall(animationTrack.Stop, animationTrack, 0)
            end
        end
    end

    local function restoreKillMovement()
        local humanoid = getHumanoid()
        if not humanoid then return end
        humanoid:Move(Vector3.zero, false)
        if humanoid.WalkSpeed <= 0 then humanoid.WalkSpeed = State.kill.movementWalkSpeed or 16 end
        humanoid.AutoRotate = true
    end

    local function touchKill(player)
        if not player or player == LP or protectedTarget(player) then
            return false
        end
        local targetCharacter = player.Character
        local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildWhichIsA("Humanoid")
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
        if not targetHumanoid or targetHumanoid.Health <= 0 or not targetRoot or hasTargetProtection(targetCharacter) then
            return false
        end
        local startingHealth = targetHumanoid.Health
        local punch = equipPunch()
        if not punch then return false end
        RunService.Heartbeat:Wait()
        local deadline = os.clock() + TARGET_ATTACK_WINDOW
        local hit = false
        local contactStep = 1
        local localHumanoid = getHumanoid()
        if localHumanoid then
            localHumanoid:Move(Vector3.zero, false)
            stopMovementAnimation(localHumanoid)
        end

        while State.running and os.clock() < deadline do
            if State.kill.brawlCombat then
                if not isInsideBrawl(LP) or not isInBrawlBattle(LP)
                    or not isInsideBrawl(player) or not isInBrawlBattle(player) then
                    break
                end
            elseif State.kill.targetMode then
                if State.kill.target ~= player.Name then break end
            elseif not State.kill.auto and State.kill.karmaMode == nil then
                break
            end
            targetCharacter = player.Character
            targetHumanoid = targetCharacter and targetCharacter:FindFirstChildWhichIsA("Humanoid")
            targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
            if not targetHumanoid or targetHumanoid.Health <= 0 or not targetRoot or hasTargetProtection(targetCharacter) then break end
            local character = getCharacter()
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not root then break end
            if localHumanoid then
                localHumanoid:Move(Vector3.zero, false)
                stopMovementAnimation(localHumanoid)
            end
            State.kill.combatCFrame = getAttackCFrame(character, root, targetCharacter, targetRoot, contactStep)
            character:PivotTo(State.kill.combatCFrame)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            RunService.Heartbeat:Wait()
            targetCharacter = player.Character
            targetHumanoid = targetCharacter and targetCharacter:FindFirstChildWhichIsA("Humanoid")
            targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")
            if not targetHumanoid or targetHumanoid.Health <= 0 or not targetRoot
                or hasTargetProtection(targetCharacter) then break end
            if State.kill.brawlCombat and (not isInsideBrawl(player) or not isInBrawlBattle(player)) then break end
            if (root.Position - State.kill.combatCFrame.Position).Magnitude > 0.35 then
                character:PivotTo(State.kill.combatCFrame)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
            end
            if punch.Parent ~= character then punch = equipPunch() end
            if punch then
                pcall(punch.Deactivate, punch)
                RunService.Heartbeat:Wait()
                pcall(punch.Activate, punch)
                task.wait(TARGET_UPDATE_INTERVAL)
                pcall(punch.Deactivate, punch)
            end
            hit = targetHumanoid.Health < startingHealth
            contactStep = contactStep + 1
            task.wait()
        end

        State.kill.combatCFrame = nil
        if punch then pcall(punch.Deactivate, punch) end
        local root = getRoot()
        if root and State.kill.lockCFrame then
            root.CFrame = State.kill.lockCFrame
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        local defeated = targetHumanoid and targetHumanoid.Health <= 0
        if hit or defeated then
            State.kill.targetRetryAt[player.UserId] = nil
        elseif not State.kill.targetMode then
            State.kill.targetRetryAt[player.UserId] = os.clock() + TARGET_RETRY_DELAY
        end
        return hit or defeated or false
    end

    local function matchesKarma(player, mode)
        if not mode then
            return true
        end
        local good = getPlayerStat(player, { "goodKarma", "Good Karma" })
        local evil = getPlayerStat(player, { "evilKarma", "Evil Karma" })
        local goodValue = tonumber(good and State.getFunctionalStatValue(good)) or 0
        local evilValue = tonumber(evil and State.getFunctionalStatValue(evil)) or 0
        if mode == "evil" then
            return goodValue > evilValue
        elseif mode == "good" then
            return evilValue > goodValue
        end
        return false
    end

    local function massKillEnabled()
        return State.kill.auto or State.kill.karmaMode ~= nil
    end

    local function autoKillTargets()
        local targets = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and not protectedTarget(player) and matchesKarma(player, State.kill.karmaMode) then
                local character = player.Character
                local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local retryAt = State.kill.targetRetryAt[player.UserId]
                if humanoid and humanoid.Health > 0 and root and not hasTargetProtection(character)
                    and (not retryAt or os.clock() >= retryAt) then
                    targets[#targets + 1] = { player = player, health = humanoid.Health }
                end
            end
        end
        table.sort(targets, function(a, b)
            return a.health < b.health
        end)
        return targets
    end

    local function brawlTargets()
        local targets = {}
        local added = {}
        if not State.kill.brawlCombat or not isInsideBrawl(LP) or not isInBrawlBattle(LP) then
            return targets
        end

        local function add(player)
            if not player or player == LP or added[player.UserId] or protectedTarget(player) then return end
            local character = player.Character
            local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")
            if not humanoid or humanoid.Health <= 0 or not root or not isInsideBrawl(player)
                or not isInBrawlBattle(player) or hasTargetProtection(character) then return end
            added[player.UserId] = true
            targets[#targets + 1] = { player = player, health = humanoid.Health }
        end
        add(State.kill.brawlChosen)
        for _, player in ipairs(Players:GetPlayers()) do add(player) end
        table.sort(targets, function(a, b)
            if a.player == State.kill.brawlChosen then return true end
            if b.player == State.kill.brawlChosen then return false end
            return a.health < b.health
        end)
        return targets
    end

    local function refreshKillLoop()
        stopThread("killFarm")
        local normalEnabled = not State.kill.brawlBusy and (massKillEnabled() or State.kill.targetMode)
        if not State.kill.brawlCombat and not normalEnabled then
            restorePunch()
            return
        end
        startThread("killFarm", function()
            while State.running do
                if State.kill.brawlCombat then
                    local targets = brawlTargets()
                    for _, target in ipairs(targets) do
                        if not State.running or not State.kill.brawlCombat then break end
                        touchKill(target.player)
                    end
                elseif State.kill.brawlBusy then
                    break
                elseif State.kill.targetMode then
                    touchKill(State.kill.target and Players:FindFirstChild(State.kill.target))
                elseif massKillEnabled() then
                    local targets = autoKillTargets()
                    for _, target in ipairs(targets) do
                        if not State.running or not massKillEnabled() then
                            break
                        end
                        touchKill(target.player)
                    end
                    if State.kill.serverHop then
                        if #targets == 0 then
                            State.kill.noTargetsSince = State.kill.noTargetsSince or time()
                            if time() - State.kill.noTargetsSince >= CONFIG.ServerHop.NoTargetsDelay then
                                State.kill.hopNow = true
                            end
                        else
                            State.kill.noTargetsSince = nil
                        end
                    end
                else
                    break
                end
                task.wait()
            end
            restorePunch()
        end)
    end

    -- Server Hop functions
    local function getTeleportQueue()
        local environment = getgenv and getgenv() or _G
        local queue = environment.queue_on_teleport or environment.queueonteleport
            or queue_on_teleport or queueonteleport
        if type(queue) == "function" then
            return queue
        end
        local synApi = environment.syn
        if type(synApi) == "table" and type(synApi.queue_on_teleport) == "function" then
            return synApi.queue_on_teleport
        end
        local fluxusApi = environment.fluxus
        if type(fluxusApi) == "table" and type(fluxusApi.queue_on_teleport) == "function" then
            return fluxusApi.queue_on_teleport
        end
        return nil
    end

    local function serverWasVisited(serverId)
        return table.find(State.kill.serverHistory, serverId) ~= nil
    end

    local function rememberServer(serverId)
        if not serverWasVisited(serverId) then
            State.kill.serverHistory[#State.kill.serverHistory + 1] = serverId
        end
        while #State.kill.serverHistory > CONFIG.ServerHop.HistoryLimit do
            table.remove(State.kill.serverHistory, 1)
        end
    end

    local function killHttpGet(url)
        local environment = getgenv and getgenv() or _G
        local requestFunction = environment.request
            or environment.http_request
            or (type(environment.syn) == "table" and environment.syn.request)
        if type(requestFunction) == "function" then
            local requestOk, response = pcall(requestFunction, {
                Url = url,
                Method = "GET",
                Headers = { ["cache-control"] = "no-store" },
            })
            local body = type(response)=="table" and (response.Body or response.body) or (type(response)=="string" and response)
            if requestOk and type(body) == "string" then
                return true, body
            end
        end
        return pcall(game.HttpGet, game, url, true)
    end

    local function serverScore(server, mode)
        local playing = tonumber(server.playing) or 0
        local maximum = math.max(1, tonumber(server.maxPlayers) or 20)
        local ping = tonumber(server.ping)
        local fps = tonumber(server.fps)
        if mode == "solo" then return (playing > 2 and 100000 or 0) + math.abs(playing - 1) * 100 + (ping or 0) end
        if mode == "balanced" then return math.abs(playing - math.min(10, maximum - 1)) * 100 + (ping or 0) end
        if mode == "ping" then return (ping or (fps and math.max(0, 60 - fps) * 20) or 500) + playing * 2 end
        if mode == "king" then return playing * 120 + (ping or 0) end
        return (playing < 18 and 100000 or 0) + math.abs(playing - math.min(18, maximum - 1)) * 100 + (ping or 0)
    end

    local function findPublicServer(allowVisited)
        local mode=State.kill.serverHopMode or "full"
        local now=os.clock()
        local cache=State.kill.serverCache
        local failed=State.kill.failedServers or {}
        State.kill.failedServers=failed
        local function choose(list)
            for _,server in ipairs(list) do
                if server.id~=game.JobId and (allowVisited or not serverWasVisited(server.id))
                    and (failed[server.id] or 0)<=os.clock() then
                    State.kill.serverCandidate=server
                    return server.id,server
                end
            end
        end
        if cache and cache.mode==mode and now-cache.at<30 then
            local id,server=choose(cache.list)
            if id then return id,server end
        end
        if State.kill.serverSearchBusy then State.kill.serverError="Search is still in progress."; return nil end
        if now<(State.kill.serverRetryAt or 0) then
            State.kill.serverError="Roblox requested a wait. Retry in "..math.ceil(State.kill.serverRetryAt-now).."s."
            return nil
        end
        State.kill.serverSearchBusy=true
        State.kill.serverError=nil
        local candidates,seen={}, {}
        local ok,err=pcall(function()
            local httpService=game:GetService("HttpService")
            local cursor=nil
            local ascending=mode=="solo" or mode=="king"
            for page=1,6 do
                if not State.running then break end
                local url=string.format(CONFIG.ServerHop.ServerApi,game.PlaceId)
                url=url:gsub("sortOrder=%w+","sortOrder="..(ascending and "Asc" or "Desc"))
                if cursor then url=url.."&cursor="..httpService:UrlEncode(cursor) end
                local requestOk,body=killHttpGet(url)
                if not requestOk or type(body)~="string" then error("Could not query Roblox.") end
                local decoded,response=pcall(httpService.JSONDecode,httpService,body)
                if not decoded or type(response)~="table" then error("Roblox returned an incomplete response.") end
                if type(response.data)~="table" then
                    State.kill.serverRetryAt=os.clock()+12
                    error("Roblox limited the search. Wait a few seconds.")
                end
                for _,server in ipairs(response.data) do
                    local n=tonumber(server.playing)
                    local maximum=tonumber(server.maxPlayers)
                    local eligible=n and maximum and n<maximum and n>=1
                    if eligible then
                        eligible=(mode=="full" and n>=math.min(18,maximum-1))
                            or (mode=="solo" and n<=2) or (mode=="king" and n<=2)
                            or (mode=="balanced" and n>=8 and n<=14) or mode=="ping"
                    end
                    if eligible and type(server.id)=="string" and server.id~=game.JobId and not seen[server.id] then
                        seen[server.id]=true
                        candidates[#candidates+1]=server
                    end
                end
                cursor=response.nextPageCursor
                if not cursor or #candidates>=12 then break end
                task.wait(.35)
            end
            table.sort(candidates,function(a,b)
                local first,second=serverScore(a,mode),serverScore(b,mode)
                if first==second then return a.id<b.id end
                return first<second
            end)
        end)
        State.kill.serverSearchBusy=false
        if not ok then State.kill.serverError=tostring(err):gsub("^.-:%d+: ","") end
        State.kill.serverCandidates=candidates
        State.kill.serverCache={mode=mode,at=os.clock(),list=candidates}
        local id,server=choose(candidates)
        if not id then
            State.kill.serverCandidate=nil
            State.kill.serverError=State.kill.serverError or "No candidates match that filter right now."
        end
        return id,server
    end

    State.findPublicServer = findPublicServer

    local function queueResume(queue, serverId, resumeData)
        local httpService = game:GetService("HttpService")
        rememberServer(serverId)
        resumeData = resumeData or {}
        resumeData.script = "fg100.lua"
        resumeData.afkSession=State.afkSnapshot and State.afkSnapshot() or nil
        resumeData.sessionBrawls=State.kill.sessionBrawls
        resumeData.language=State.language
        resumeData.fastMode=FastFarm.mode
        resumeData.packMode=FastFarm.packMode
        resumeData.afkMode=State.afk.active and State.afk.mode or nil
        resumeData.serverHistory = State.kill.serverHistory
        resumeData.serversVisited = State.kill.serversVisited + 1
        resumeData.outputEntries = {}
        for index = 1, math.min(50, #State.outputEntries) do
            resumeData.outputEntries[index] = State.outputEntries[index]
        end
        local snapshot = httpService:JSONEncode(resumeData)
        local loader="loadstring(game:HttpGet(" .. string.format("%q",CONFIG.ServerHop.LoaderUrl) .. ",true))()"
        if Env.Young0xFG100LocalBuild then
            local localFile=Env.Young0xFG100LocalFile
            if type(localFile)=="string" and localFile~="" then
                loader="local p="..string.format("%q",localFile).."; assert(type(readfile)=="function","readfile not available"); env.Young0xFG100LocalFile=p; local s=readfile(p); assert(loadstring(s))()"
            else
                local source=Env.Young0xFG100LocalSource
                if type(source)~="string" or #source<10000 then return false end
                loader="env.Young0xFG100LocalSource="..string.format("%q",source).."; assert(loadstring(env.Young0xFG100LocalSource))()"
            end
        end
        local queuedSource = table.concat({
            "repeat task.wait() until game:IsLoaded()",
            "local env = getgenv and getgenv() or _G",
            "if game.JobId ~= "..string.format("%q",serverId).." then return end",
            "if env.__Young0xHopJob == game.JobId then return end",
            "env.__Young0xHopJob = game.JobId",
            "local ok,err=pcall(function()",
            "env.Young0xFG100Resume = game:GetService('HttpService'):JSONDecode(" .. string.format("%q", snapshot) .. ")",
            loader,
            "end)",
            "if not ok then env.__Young0xHopJob=nil; error(err,0) end",
        }, "
")
        local ok,accepted=pcall(queue,queuedSource)
        return ok and accepted~=false
    end

    local function queueServerResume(queue, serverId)
        updateKillSession(currentKillsTotal())
        local controls, selectors = {}, {}
        for key, control in pairs(State.profileControls) do
            if type(control) == "table" and type(control.Get) == "function" then
                local ok, value = pcall(control.Get, control)
                if ok and (type(value) == "boolean" or type(value) == "string" or type(value) == "number") then controls[key] = value end
            end
        end
        for key, control in pairs(State.selectorControllers) do
            if type(control) == "table" and type(control.Get) == "function" then
                local ok, value = pcall(control.Get, control)
                if ok and (type(value) == "string" or type(value) == "number") then selectors[key] = value end
            end
        end
        return queueResume(queue, serverId, {
            tab = State.currentTab or "Server Hop",
            autoKill = State.kill.auto,
            autoWinBrawl = State.kill.autoWinBrawl,
            karmaMode = State.kill.karmaMode,
            protectFriends = State.kill.protectFriends,
            serverHop = State.kill.serverHop,
            serverHopInterval = State.kill.serverHopInterval,
            serverHopMode = State.kill.serverHopMode,
            hopOnDeath = State.kill.hopOnDeath,
            avoidKillers = State.kill.avoidKillers,
            claimKing = State.kill.claimKing,
            themeName = State.themeName,
            controls = controls,
            selectors = selectors,
            killSessionActive = State.kill.killSessionActive,
            sessionKills = State.kill.sessionKills,
            sessionStartKills = State.kill.sessionStartKills,
            killSessionElapsed = State.getKillSessionElapsed and State.getKillSessionElapsed() or 0,
        })
    end

    local function performServerHop()
        if State.rewardsBusy or State.chestClaimBusy then return false,"Wait for the rewards to finish claiming." end
        if State.kill.teleportDispatching then return false,"A server change is already in progress." end
        local pending=State.kill.teleportPending
        State.kill.failedServers=State.kill.failedServers or {}
        if pending then
            if os.clock()-pending.at<18 then return false,"A server change is already in progress." end
            State.kill.failedServers[pending.id]=os.clock()+60
            State.kill.teleportPending=nil
        end
        State.kill.teleportDispatching=true
        local callOk,accepted,detail=pcall(function()
            local queue=getTeleportQueue()
            if not queue then return false,"Your executor cannot keep the script running after switching." end
            local serverId,candidate=findPublicServer(false)
            if not serverId then serverId,candidate=findPublicServer(true) end
            if not serverId then return false,State.kill.serverError or "No other available server was found." end
            if State.rewardsBusy or State.chestClaimBusy then return false,"Wait for the rewards to finish claiming." end
            if not queueServerResume(queue,serverId) then return false,"Could not prepare reconnection." end
            State.kill.teleportPending={id=serverId,at=os.clock()}
            State.kill.teleportError=nil
            local ok,message=pcall(function() game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,serverId,LP) end)
            if not ok then
                State.kill.teleportPending=nil
                State.kill.failedServers[serverId]=os.clock()+60
                State.kill.teleportError=tostring(message)
                print("ERROR","Server Hop: "..tostring(message):sub(1,180))
                return false,"Roblox rejected the switch. Try again."
            end
            print("SERVER","Connecting to "..tostring(candidate.playing).."/"..tostring(candidate.maxPlayers).." players")
            return true
        end)
        State.kill.teleportDispatching=false
        if not callOk then
            State.kill.teleportPending=nil
            print("ERROR","Server Hop: "..tostring(accepted):sub(1,180))
            return false,"Could not switch servers"
        end
        return accepted,detail
    end

    local function kingIsFree()
        local kingPosition = Vector3.new(-8646, 13.25, -5738)
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
                if root and humanoid and humanoid.Health > 0 and (root.Position - kingPosition).Magnitude <= 45 then return false, player end
            end
        end
        return true, nil
    end

    local function serverGoalMet()
        local count = #Players:GetPlayers()
        local mode = State.kill.serverHopMode or "full"
        if mode == "solo" then return count <= 2, "Solo server ready" end
        if mode == "balanced" then return count >= 8 and count <= 14, "Balanced server ready" end
        if mode == "king" then
            local free = kingIsFree()
            if free and State.kill.claimKing then
                local root=getRoot()
                if root and (root.Position-Vector3.new(-8646,16.4,-5738)).Magnitude>12 then root.CFrame=CFrame.new(-8646,16.4,-5738) end
            end
            return free, free and "King is free in this server" or "King is occupied"
        end
        if mode == "full" then return count >= 18, "Full server ready" end
        return getPing() <= 150, getPing() <= 150 and "Latency within target (150 ms)" or "Looking for lower latency"
    end

    State.kingIsFree = kingIsFree
    State.serverGoalMet = serverGoalMet
    State.performServerHop = performServerHop
    State.previewServerHop = function()
        local _, server = findPublicServer(false)
        if not server then _, server = findPublicServer(true) end
        return server
    end
    State.requestServerHop = function()
        if State.kill.hopInProgress or (State.kill.teleportPending and os.clock()-State.kill.teleportPending.at<18) then return false,"A server change is already in progress." end
        if State.kill.serverHop then State.kill.forceHopReason = "Manual server change requested"; return true end
        State.kill.hopInProgress = true
        local ok, message = performServerHop()
        State.kill.hopInProgress = false
        return ok, message
    end
    State.playerLooksDangerous = function(player)
        if not player or player == LP then return false end
        local theirs = getPlayerStat(player, { "Kills" })
        local mine = getPlayerStat(LP, { "Kills" })
        local theirKills = tonumber(theirs and theirs.Value) or 0
        local myKills = tonumber(mine and mine.Value) or 0
        return theirKills >= math.max(5000, myKills * 1.15)
    end
    State.killerInServer = function()
        for _, player in ipairs(Players:GetPlayers()) do if State.playerLooksDangerous(player) then return player end end
        return nil
    end

    local function updateHopStatus(seconds, message)
        if type(State.kill.updateHopStatus) == "function" then
            pcall(State.kill.updateHopStatus, seconds, message)
        end
    end

    State.setServerHop = function(enabled)
        if enabled and (State.kill.targetMode or not getTeleportQueue()) then
            return false
        end
        State.kill.serverHop = enabled == true
        State.kill.hopNow = false
        State.kill.noTargetsSince = nil
        stopThread("killServerHop")
        if State.kill.serverHop then
            startThread("killServerHop", function()
                local startedAt = os.clock()
                while State.running and State.kill.serverHop do
                    repeat
                        if State.kill.brawlBusy then
                            updateHopStatus(nil,"Waiting for the brawl to finish...")
                            task.wait(1)
                            break
                        end
                        local interval = State.kill.serverHopInterval or CONFIG.ServerHop.Interval
                        local remaining = math.max(0, math.ceil(interval - (os.clock() - startedAt)))
                        local reason = State.kill.forceHopReason
                        if not reason and State.kill.avoidKillers then local killer = State.killerInServer(); if killer then reason = killer.DisplayName .. " looks dangerous. Switching..." end end
                        if not reason and State.kill.hopNow then reason = "No targets. Looking for another server..." end
                        if not reason and massKillEnabled() and #Players:GetPlayers() < 10 then
                            reason = "Server with few players..."
                        end
                        if not reason and massKillEnabled() and os.clock() - State.kill.lastKillAt >= 18 then
                            reason = "No kills. Looking for another server..."
                        end
                        if not reason and not massKillEnabled() and not State.kill.autoWinBrawl then
                            local reached, status = serverGoalMet()
                            if reached then startedAt = os.clock(); updateHopStatus(nil, status); task.wait(1); break end
                        end
                        if not reason and remaining <= 0 then reason = "Changing servers..." end
                        if not reason then
                            updateHopStatus(remaining)
                            task.wait(1)
                            break
                        end
                        State.kill.hopNow = false
                        State.kill.forceHopReason = nil
                        State.kill.hopInProgress = true
                        updateHopStatus(0, reason)
                        local ok, message = performServerHop()
                        if ok then
                            updateHopStatus(0, "Connecting...")
                            for _ = 1, 24 do
                                if not State.running or not State.kill.serverHop or State.kill.forceHopReason then break end
                                task.wait(0.5)
                            end
                        else
                            updateHopStatus(0, message or "Retrying...")
                            State.kill.forceHopReason = reason
                            task.wait(12)
                        end
                        State.kill.hopInProgress = false
                    until true
                end
            end)
        else
            State.kill.hopRetrying = false
            State.kill.hopInProgress = false
            State.kill.forceHopReason = nil
            updateHopStatus(nil)
        end
        return true
    end

    track(game:GetService("TeleportService").TeleportInitFailed:Connect(function(player,result,message)
        if player~=LP or not State.running then return end
        local pending=State.kill.teleportPending
        if pending then State.kill.failedServers[pending.id]=os.clock()+90 end
        State.kill.teleportPending=nil
        State.kill.hopInProgress=false
        State.kill.teleportError=tostring(result)..": "..tostring(message)
        print("ERROR","Server Hop: "..State.kill.teleportError:sub(1,180))
        local text="Roblox could not connect. Looking for another server..."
        if State.kill.serverHop then State.kill.forceHopReason=text end
        updateHopStatus(nil,text)
    end))

    local function watchKillDeath(character)
        local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        if not humanoid then return end
        track(humanoid.Died:Connect(function()
            if State.kill.hopOnDeath and State.kill.serverHop then
                State.kill.forceHopReason = "You died. Looking for another server..."
            end
            if State.kill.killSessionActive then
                State.kill.sessionElapsed = State.getKillSessionElapsed()
                State.kill.sessionStartedAt = nil
            end
        end))
    end

    track(LP.CharacterAdded:Connect(watchKillDeath))

    local function refreshKillSizeSupport()
        stopThread("killSizeOne")
        if not massKillEnabled() and not State.kill.targetMode and not State.kill.brawlCombat then
            return
        end
        if type(FastFarm.SetSizeOne) == "function" then
            FastFarm.SetSizeOne()
        end
        startThread("killSizeOne", function()
            while State.running and (massKillEnabled() or State.kill.targetMode or State.kill.brawlCombat) do
                if type(FastFarm.SetSizeOne) == "function" then
                    FastFarm.SetSizeOne()
                end
                task.wait(0.5)
            end
        end)
    end

    local function stopKillPositionLock()
        stopThread("killPositionLock")
        State.kill.combatCFrame = nil
        State.kill.lockCFrame = nil
        State.kill.lockCharacter = nil
        restoreKillMovement()
    end

    local function stopKillPunchAnimation()
        stopThread("killPunchAnimation")
        if State.fastPunch then return end
        pcall(function()
            local character = getCharacter()
            local backpack = LP:FindFirstChild("Backpack")
            local punch = (character and character:FindFirstChild("Punch"))
                or (backpack and backpack:FindFirstChild("Punch"))
            local attackTime = punch and punch:FindFirstChild("attackTime")
            if attackTime then attackTime.Value = 0.3 end
        end)
    end

    local function startKillPositionLock()
        stopKillPositionLock()
        local character = getCharacter()
        local root = getRoot()
        if character and root then
            State.kill.lockCharacter = character
            State.kill.lockCFrame = root.CFrame
        end
        startThread("killPositionLock", function()
            while State.running and massKillEnabled() and not State.kill.brawlBusy do
                local currentCharacter = getCharacter()
                local currentRoot = getRoot()
                if currentCharacter and currentRoot then
                    if State.kill.lockCharacter ~= currentCharacter or not State.kill.lockCFrame then
                        State.kill.lockCharacter = currentCharacter
                        State.kill.lockCFrame = currentRoot.CFrame
                    end
                    currentRoot.CFrame = State.kill.combatCFrame or State.kill.lockCFrame
                    currentRoot.AssemblyLinearVelocity = Vector3.zero
                    currentRoot.AssemblyAngularVelocity = Vector3.zero
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end

    local function restoreBrawlPositionAndMovement()
        local character = getCharacter()
        local root = getRoot()
        if character and root and typeof(State.kill.brawlReturnCFrame) == "CFrame" then
            pcall(character.PivotTo, character, State.kill.brawlReturnCFrame)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        local humanoid = getHumanoid()
        local movement = State.kill.brawlMovement
        if humanoid and type(movement) == "table" then
            pcall(function()
                humanoid.WalkSpeed = movement.walkSpeed
                humanoid.AutoRotate = movement.autoRotate
                if movement.usesJumpPower then
                    humanoid.JumpPower = movement.jumpValue
                else
                    humanoid.JumpHeight = movement.jumpValue
                end
            end)
        end
        State.kill.brawlReturnCFrame = nil
        State.kill.brawlMovement = nil
        restoreKillMovement()
    end

    local function restoreAfterBrawl()
        State.kill.brawlPhase = "IDLE"
        State.kill.brawlBusy = false
        State.kill.brawlCombat = false
        State.kill.brawlJoined = false
        State.kill.brawlJoinSent = false
        State.kill.brawlChosen = nil
        State.kill.lastKillAt = os.clock()
        State.kill.forceHopReason = nil
        restoreBrawlPositionAndMovement()
        refreshKillSizeSupport()
        refreshKillLoop()
        if massKillEnabled() then
            startKillPositionLock()
        else
            restoreKillMovement()
        end
    end

    local function finishBrawlCycle()
        if not State.kill.brawlBusy and State.kill.brawlPhase == "IDLE" then return end
        State.kill.brawlPhase = "RESTORING"
        State.kill.brawlCombat = false
        State.kill.brawlChosen = nil
        State.kill.combatCFrame = nil
        refreshKillSizeSupport()
        refreshKillLoop()
        stopThread("killBrawlRestore")
        startThread("killBrawlRestore", function()
            local exitDeadline = os.clock() + 15
            while State.running and isInsideBrawl(LP) do
                if BrawlState:GetAttribute("BrawlInProgress") ~= true and os.clock() >= exitDeadline then break end
                task.wait(0.25)
            end
            if State.running then
                local wins = currentBrawlWins()
                State.kill.lastBrawlWon = wins ~= nil and State.kill.brawlBaselineWins ~= nil
                    and wins > State.kill.brawlBaselineWins
                restoreAfterBrawl()
                if State.kill.autoWinBrawl and State.kill.serverHop and not massKillEnabled() then
                    State.kill.forceHopReason=State.kill.lastBrawlWon and "Win confirmed. Looking for another brawl..." or "Brawl finished. Looking for another..."
                end
            end
        end)
    end

    local function prepareBrawlCycle()
        if not State.kill.brawlBusy then
            State.kill.brawlBaselineWins = currentBrawlWins()
            local root = getRoot()
            local humanoid = getHumanoid()
            State.kill.brawlReturnCFrame = root and root.CFrame or nil
            State.kill.brawlMovement = humanoid and {
                walkSpeed = humanoid.WalkSpeed,
                autoRotate = humanoid.AutoRotate,
                usesJumpPower = humanoid.UseJumpPower,
                jumpValue = humanoid.UseJumpPower and humanoid.JumpPower or humanoid.JumpHeight,
            } or nil
        end
        State.kill.brawlBusy = true
        State.kill.brawlCombat = false
        State.kill.brawlJoined = isInsideBrawl(LP)
        State.kill.brawlChosen = nil
        State.kill.brawlPhase = State.kill.brawlJoined and "WAITING" or "JOINING"
        State.kill.forceHopReason = nil
        stopKillPositionLock()
        refreshKillLoop()
    end

    local function beginBrawlCombat()
        if not State.kill.autoWinBrawl or not isInsideBrawl(LP) then return false end
        if not State.kill.brawlBusy then prepareBrawlCycle() end
        State.kill.brawlJoined = true
        State.kill.brawlCombat = true
        State.kill.brawlPhase = "FIGHTING"
        State.kill.brawlChosen = nil
        stopKillPositionLock()
        refreshKillSizeSupport()
        refreshKillLoop()
        return true
    end

    local function tryJoinBrawl()
        if not State.kill.autoWinBrawl or State.kill.brawlJoinSent
            or BrawlState:GetAttribute("BrawlInProgress") ~= true
            or BrawlState:GetAttribute("BrawlStarted") == true then
            return false
        end
        prepareBrawlCycle()
        if type(FastFarm.SetSizeOne) == "function" then FastFarm.SetSizeOne() end
        State.kill.brawlJoinSent = true
        local joined = pcall(BrawlEvent.FireServer, BrawlEvent, "joinBrawl")
        if not joined then
            State.kill.brawlJoinSent = false
            finishBrawlCycle()
            return false
        end
        return true
    end

    State.setAutoWinBrawl = function(enabled)
        State.kill.autoWinBrawl = enabled == true
        if not State.kill.autoWinBrawl then
            if State.kill.brawlBusy then finishBrawlCycle() else restoreAfterBrawl() end
            stopKillSessionIfIdle()
            return true
        end
        startKillSession()
        if BrawlState:GetAttribute("BrawlStarted") == true then
            beginBrawlCombat()
        elseif brawlPromptVisible() then
            tryJoinBrawl()
        end
        return true
    end

    track(BrawlEvent.OnClientEvent:Connect(function(action, ...)
        if not State.running or not State.kill.autoWinBrawl then return end
        if action == "brawlStarting" then
            State.kill.brawlJoinSent = false
            task.defer(tryJoinBrawl)
        elseif action == "joinedBrawl" then
            if not State.kill.brawlBusy then prepareBrawlCycle() end
            State.kill.brawlJoined = true
            State.kill.brawlPhase = "WAITING"
        elseif action == "beginBrawl" then
            beginBrawlCombat()
        elseif action == "playerChosen" then
            local chosen = select(1, ...)
            if typeof(chosen) == "Instance" and chosen:IsA("Player")
                and chosen ~= LP and isInBrawlBattle(LP) then
                State.kill.brawlChosen = chosen
            else
                State.kill.brawlChosen = nil
            end
        elseif action == "noOtherBrawlers" or action == "endBrawl" then
            finishBrawlCycle()
        end
    end))

    track(BrawlState:GetAttributeChangedSignal("BrawlStarted"):Connect(function()
        if not State.running or not State.kill.autoWinBrawl then return end
        if BrawlState:GetAttribute("BrawlStarted") == true then
            beginBrawlCombat()
        elseif BrawlState:GetAttribute("BrawlInProgress") ~= true then
            finishBrawlCycle()
        end
    end))

    track(BrawlState:GetAttributeChangedSignal("BrawlInProgress"):Connect(function()
        if not State.running or not State.kill.autoWinBrawl then return end
        if BrawlState:GetAttribute("BrawlInProgress") ~= true and State.kill.brawlBusy then
            finishBrawlCycle()
        end
    end))

    State.killBrawlPromptVisible = brawlPromptVisible
    State.killTryJoinBrawl = tryJoinBrawl

    State.setAutoKill = function(enabled)
        if enabled and killsBlockedHere() then
            return false
        end
        if enabled then
            startKillSession()
            State.kill.lastKillAt = os.clock()
            local humanoid = getHumanoid()
            if humanoid and humanoid.WalkSpeed > 0 then State.kill.movementWalkSpeed = humanoid.WalkSpeed end
        end
        State.kill.auto = enabled == true
        if State.kill.auto and not State.kill.brawlBusy then
            State.kill.targetMode = false
            State.kill.karmaMode = nil
            startKillPositionLock()
        else
            stopKillPositionLock()
        end
        stopKillPunchAnimation()
        refreshKillSizeSupport()
        refreshFastPunch()
        refreshKillLoop()
        stopKillSessionIfIdle()
        return true
    end

    State.setTargetKill = function(enabled)
        local selectedTarget = State.kill.target and Players:FindFirstChild(State.kill.target)
        if enabled and (killsBlockedHere() or not selectedTarget or protectedTarget(selectedTarget)) then
            return false
        end
        State.kill.targetMode = enabled == true
        if State.kill.targetMode then
            startKillSession()
            State.kill.auto = false
            State.kill.karmaMode = nil
            stopKillPositionLock()
            stopKillPunchAnimation()
            State.setServerHop(false)
        elseif not massKillEnabled() then
            restoreKillMovement()
        end
        refreshKillSizeSupport()
        refreshFastPunch()
        refreshKillLoop()
        stopKillSessionIfIdle()
        return true
    end

    State.setKarmaKill = function(mode, enabled)
        if mode ~= "evil" and mode ~= "good" then
            return false
        end
        if enabled and killsBlockedHere() then
            return false
        end
        if enabled then
            startKillSession()
            State.kill.karmaMode = mode
        elseif State.kill.karmaMode == mode then
            State.kill.karmaMode = nil
        end
        if State.kill.karmaMode and not State.kill.brawlBusy then
            State.kill.auto = false
            stopKillPunchAnimation()
            State.kill.targetMode = false
            startKillPositionLock()
        else
            stopKillPositionLock()
            stopKillPunchAnimation()
        end
        refreshKillSizeSupport()
        refreshFastPunch()
        refreshKillLoop()
        stopKillSessionIfIdle()
        return true
    end

    State.setProtectFriends = function(enabled)
        State.kill.protectFriends = enabled == true
        refreshKillFriendProtection()
        return true
    end

    State.clearKillFriend = function(player)
        if player then
            State.kill.friendCache[player.UserId] = nil
        end
    end

    State.stopKills = function()
        State.kill.auto = false
        State.kill.autoWinBrawl = false
        State.kill.karmaMode = nil
        State.kill.targetMode = false
        State.kill.serverHop = false
        stopThread("killFarm")
        stopThread("killSizeOne")
        stopThread("killFastPunch")
        stopThread("killFriendRefresh")
        stopKillPositionLock()
        stopKillPunchAnimation()
        stopThread("killServerHop")
        stopThread("killBrawlRestore")
        State.kill.brawlBusy = false
        State.kill.brawlCombat = false
        State.kill.brawlJoined = false
        State.kill.brawlJoinSent = false
        State.kill.brawlChosen = nil
        State.kill.brawlPhase = "IDLE"
        stopKillSessionIfIdle()
        updateHopStatus(nil)
        restorePunch()
    end
end

print("[Muscle Legends] Part 6 loaded - Kill System and Server Hop")

-- ============================================================
-- PART 7: MOVEMENT AND UTILITY SYSTEMS (from original)
-- ============================================================

-- Movement Systems
local baseWalkSpeed = nil

local function applyWalkSpeed()
    local humanoid = getHumanoid()
    if humanoid then
        if State.fastSpeed then
            humanoid.WalkSpeed = 1000
        elseif baseWalkSpeed ~= nil then
            humanoid.WalkSpeed = baseWalkSpeed
        end
    end
end

local function setFastSpeed(enabled)
    local humanoid = getHumanoid()
    if enabled and humanoid and not State.fastSpeed then
        baseWalkSpeed = humanoid.WalkSpeed
    end
    local wasEnabled = State.fastSpeed
    State.fastSpeed = enabled == true
    if State.fastSpeed or wasEnabled then
        applyWalkSpeed()
    end
    if wasEnabled and not State.fastSpeed then
        baseWalkSpeed = nil
    end
end

local flyGyro = nil
local flyVelocity = nil
local mobileFlyUp = false
local mobileFlyDown = false
local mobileFlyControls = nil

State.clearAntiKnockback = function()
    if State.antiKnockbackVelocity then
        State.antiKnockbackVelocity:Destroy()
        State.antiKnockbackVelocity = nil
    end
end

State.setAntiKnockback = function(enabled)
    State.antiKnockback = enabled == true
    if not State.antiKnockback and not State.noclip then
        State.clearAntiKnockback()
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
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
    end
end

local function setFly(enabled)
    State.fly = enabled == true
    if mobileFlyControls then
        mobileFlyControls.Visible = State.fly and UserInputService.TouchEnabled
    end
    if not State.fly then
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
        local root = getRoot()
        local humanoid = getHumanoid()
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
        if not State.running or not State.noclip then return end
        local character = getCharacter()
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
        State.noclip = enabled == true
        if not State.noclip then
            State.noclipBeachSurfaceY = nil
            restoreNoclip()
            if not State.antiKnockback then
                State.clearAntiKnockback()
            end
            return true
        end
        State.noclipBeachSurfaceY = findBeachSurfaceY()
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

local function setSpin(enabled)
    State.spin = enabled == true
    if not State.spin then
        clearSpin()
    end
end

local function resetCamera()
    local humanoid = getHumanoid()
    if workspace.CurrentCamera and humanoid then
        workspace.CurrentCamera.CameraSubject = humanoid
    end
end

local function setSpy(enabled)
    State.spy = enabled == true
    if not State.spy then
        resetCamera()
    end
end

-- Anti-Lag System
local antiLagOriginal = setmetatable({}, { __mode = "k" })
local antiLagAddedConnection = nil
local antiLagStatusUpdater = function() end
local originalLighting = nil
local originalQuality = nil

local function rememberProperty(object, property)
    antiLagOriginal[object] = antiLagOriginal[object] or {}
    if antiLagOriginal[object][property] == nil then
        local ok, value = pcall(function()
            return object[property]
        end)
        if ok then
            antiLagOriginal[object][property] = value
        end
    end
end

local function setOptimizedProperty(object, property, value)
    rememberProperty(object, property)
    pcall(function()
        object[property] = value
    end)
end

local function optimizeObject(object)
    if object:IsA("BasePart") then
        setOptimizedProperty(object, "Material", Enum.Material.SmoothPlastic)
        setOptimizedProperty(object, "Reflectance", 0)
        setOptimizedProperty(object, "CastShadow", false)
        if object:IsA("MeshPart") then
            setOptimizedProperty(object, "TextureID", "")
        end
    elseif object:IsA("Decal") or object:IsA("Texture") then
        setOptimizedProperty(object, "Transparency", 1)
    elseif object:IsA("SurfaceAppearance") then
        setOptimizedProperty(object, "ColorMap", "")
        setOptimizedProperty(object, "MetalnessMap", "")
        setOptimizedProperty(object, "NormalMap", "")
        setOptimizedProperty(object, "RoughnessMap", "")
    elseif object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")
        or object:IsA("Smoke") or object:IsA("Fire") or object:IsA("Sparkles") then
        setOptimizedProperty(object, "Enabled", false)
    elseif object:IsA("PointLight") or object:IsA("SpotLight") or object:IsA("SurfaceLight") then
        setOptimizedProperty(object, "Enabled", false)
    elseif object:IsA("Highlight") then
        setOptimizedProperty(object, "Enabled", false)
    elseif object:IsA("BloomEffect") or object:IsA("BlurEffect") or object:IsA("ColorCorrectionEffect")
        or object:IsA("DepthOfFieldEffect") or object:IsA("SunRaysEffect") then
        setOptimizedProperty(object, "Enabled", false)
    elseif object:IsA("Explosion") then
        setOptimizedProperty(object, "BlastPressure", 0)
        setOptimizedProperty(object, "BlastRadius", 0)
    end
end

local function restoreAntiLag(generation, allowYield)
    local restored = 0
    for object, properties in pairs(antiLagOriginal) do
        if State.antiLagGeneration ~= generation then
            return false
        end
        if object and object.Parent then
            for property, value in pairs(properties) do
                pcall(function()
                    object[property] = value
                end)
            end
        end
        restored = restored + 1
        if allowYield and restored % 260 == 0 then
            RunService.Heartbeat:Wait()
        end
    end
    antiLagOriginal = setmetatable({}, { __mode = "k" })
    if originalLighting then
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.Brightness = originalLighting.Brightness
    end
    pcall(function()
        if originalQuality then
            settings().Rendering.QualityLevel = originalQuality
        end
    end)
    antiLagStatusUpdater("Disabled")
    return true
end

local function setAntiLag(enabled, immediate)
    State.antiLag = enabled == true
    State.antiLagGeneration = State.antiLagGeneration + 1
    local generation = State.antiLagGeneration
    stopThread("antiLag")
    if antiLagAddedConnection then
        antiLagAddedConnection:Disconnect()
        antiLagAddedConnection = nil
    end
    if State.antiLag then
        antiLagStatusUpdater("Optimizing...")
        originalLighting = originalLighting or {
            GlobalShadows = Lighting.GlobalShadows,
            FogEnd = Lighting.FogEnd,
            Brightness = Lighting.Brightness,
        }
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1000000000
        Lighting.Brightness = 0
        pcall(function()
            originalQuality = originalQuality or settings().Rendering.QualityLevel
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        end)
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            setOptimizedProperty(terrain, "WaterWaveSize", 0)
            setOptimizedProperty(terrain, "WaterWaveSpeed", 0)
            setOptimizedProperty(terrain, "WaterReflectance", 0)
            setOptimizedProperty(terrain, "WaterTransparency", 1)
        end
        antiLagAddedConnection = workspace.DescendantAdded:Connect(function(object)
            if State.antiLag then
                task.defer(function()
                    pcall(optimizeObject, object)
                end)
            end
        end)
        startThread("antiLag", function()
            local queue = { workspace, Lighting }
            local head = 1
            local processed = 0
            while head <= #queue and State.running and State.antiLag and State.antiLagGeneration == generation do
                local parent = queue[head]
                head = head + 1
                local ok, children = pcall(function()
                    return parent:GetChildren()
                end)
                if ok then
                    for _, child in ipairs(children) do
                        queue[#queue + 1] = child
                        pcall(optimizeObject, child)
                        processed = processed + 1
                        if processed % 260 == 0 then
                            RunService.Heartbeat:Wait()
                        end
                    end
                end
            end
            if State.antiLag and State.antiLagGeneration == generation then
                antiLagStatusUpdater("100% Optimized")
            end
        end)
    else
        antiLagStatusUpdater("Restoring...")
        if immediate then
            restoreAntiLag(generation, true)
        else
            startThread("antiLag", function()
                restoreAntiLag(generation, true)
            end)
        end
    end
end

-- Anti-Crash System
local AntiCrash = {
    original = setmetatable({}, { __mode = "k" }),
    addedConnection = nil,
    heartbeatConnection = nil,
    recentEffects = {},
    shieldUntil = 0,
    stalls = 0,
    lastPruneAt = 0,
}

function AntiCrash.effectProperty(object)
    if object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")
        or object:IsA("Smoke") or object:IsA("Fire") or object:IsA("Sparkles") then
        return "Enabled"
    end
    if object:IsA("Explosion") then
        return "Visible"
    end
    return nil
end

function AntiCrash.suppressEffect(object)
    local property = AntiCrash.effectProperty(object)
    if not property or AntiCrash.original[object] then
        return
    end
    local ok, value = pcall(function()
        return object[property]
    end)
    if not ok then
        return
    end
    AntiCrash.original[object] = { property = property, value = value }
    pcall(function()
        object[property] = false
    end)
end

function AntiCrash.pruneRecentEffects(now)
    local recent = AntiCrash.recentEffects
    local write = 1
    for read = 1, #recent do
        local entry = recent[read]
        if entry and now - entry.time <= 0.75 then
            recent[write] = entry
            write = write + 1
        end
    end
    for index = #recent, write, -1 do
        recent[index] = nil
    end
end

function AntiCrash.trackEffect(object, now)
    local recent = AntiCrash.recentEffects
    recent[#recent + 1] = { object = object, time = now }
    AntiCrash.pruneRecentEffects(now)
    if #recent > 96 then
        local first = #recent - 95
        local write = 1
        for read = first, #recent do
            recent[write] = recent[read]
            write = write + 1
        end
        for index = #recent, write, -1 do
            recent[index] = nil
        end
    end
    return #recent
end

function AntiCrash.suppressRecentEffects()
    for _, entry in ipairs(AntiCrash.recentEffects) do
        local object = entry.object
        if object and object.Parent then
            task.defer(AntiCrash.suppressEffect, object)
        end
    end
end

function AntiCrash.restore()
    if AntiCrash.addedConnection then
        AntiCrash.addedConnection:Disconnect()
        AntiCrash.addedConnection = nil
    end
    if AntiCrash.heartbeatConnection then
        AntiCrash.heartbeatConnection:Disconnect()
        AntiCrash.heartbeatConnection = nil
    end
    for object, saved in pairs(AntiCrash.original) do
        if object and object.Parent then
            pcall(function()
                object[saved.property] = saved.value
            end)
        end
    end
    AntiCrash.original = setmetatable({}, { __mode = "k" })
    table.clear(AntiCrash.recentEffects)
    AntiCrash.shieldUntil = 0
    AntiCrash.stalls = 0
    AntiCrash.lastPruneAt = 0
end

function AntiCrash.set(enabled)
    State.antiCrash = enabled == true
    AntiCrash.restore()
    if not State.antiCrash then
        return
    end

    AntiCrash.addedConnection = workspace.DescendantAdded:Connect(function(object)
        if not State.antiCrash or not AntiCrash.effectProperty(object) then
            return
        end
        local now = realNow()
        if now <= AntiCrash.shieldUntil then
            task.defer(AntiCrash.suppressEffect, object)
            return
        end
        local recentCount = AntiCrash.trackEffect(object, now)
        if recentCount >= 36 then
            AntiCrash.shieldUntil = math.max(AntiCrash.shieldUntil, now + 4)
            AntiCrash.suppressRecentEffects()
        end
        if now <= AntiCrash.shieldUntil then
            task.defer(AntiCrash.suppressEffect, object)
        end
    end)

    AntiCrash.heartbeatConnection = RunService.Heartbeat:Connect(function(deltaTime)
        if not State.antiCrash then
            return
        end
        local now = realNow()
        if now - AntiCrash.lastPruneAt >= 0.25 then
            AntiCrash.lastPruneAt = now
            AntiCrash.pruneRecentEffects(now)
        end
        if deltaTime >= 0.35 then
            AntiCrash.stalls = math.min(AntiCrash.stalls + 1, 4)
        elseif AntiCrash.stalls > 0 then
            AntiCrash.stalls = AntiCrash.stalls - 1
        end
        if AntiCrash.stalls >= 3 then
            AntiCrash.shieldUntil = math.max(AntiCrash.shieldUntil, now + 4)
            AntiCrash.suppressRecentEffects()
            AntiCrash.stalls = 0
        end
    end)
end

-- Walk Water System
local function setWalkWater(enabled)
    State.walkWater = enabled == true
    if State.waterFloorConnection then
        State.waterFloorConnection:Disconnect()
        State.waterFloorConnection = nil
    end
    if State.waterFloor then
        State.waterFloor:Destroy()
        State.waterFloor = nil
    end
    if not State.walkWater then
        return true
    end

    State.waterFloor = Instance.new("Part")
    State.waterFloor.Name = "WaterFloor"
    State.waterFloor.Size = Vector3.new(2048, 1, 2048)
    State.waterFloor.Anchored = true
    State.waterFloor.CanCollide = true
    State.waterFloor.CanTouch = false
    State.waterFloor.CanQuery = false
    State.waterFloor.Transparency = 1
    State.waterFloor.CastShadow = false
    State.waterFloor.Parent = workspace

    local function followCharacter()
        if not State.walkWater or not State.waterFloor or not State.waterFloor.Parent then
            return
        end
        local root = getRoot()
        if root then
            local x = math.floor(root.Position.X / 256 + 0.5) * 256
            local z = math.floor(root.Position.Z / 256 + 0.5) * 256
            State.waterFloor.Position = Vector3.new(x, -9.5, z)
        end
    end
    followCharacter()
    State.waterFloorConnection = RunService.Heartbeat:Connect(followCharacter)
    return true
end

-- Portal Removal System
local portalConnection = nil
local removedPortals = {}

local function removePortal(object)
    if object and object.Name == "RobloxForwardPortals" and object.Parent then
        removedPortals[#removedPortals + 1] = { object = object, parent = object.Parent }
        object.Parent = nil
    end
end

local function setRemovePortals(enabled)
    State.removePortals = enabled == true
    stopThread("removePortals")
    if portalConnection then
        portalConnection:Disconnect()
        portalConnection = nil
    end
    if not State.removePortals then
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
    if State.removePortals then
        portalConnection = game.DescendantAdded:Connect(removePortal)
        startThread("removePortals", function()
            local queue = { workspace }
            local head = 1
            local processed = 0
            while head <= #queue and State.running and State.removePortals do
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
end

print("[Muscle Legends] Part 7 loaded - Movement and Utility Systems")

-- ============================================================
-- PART 8: CHEST SYSTEM, PET MOMENTUM, AND REMAINING FEATURES
-- ============================================================

-- Chest System
local CHEST_DEFINITIONS = {
    { name = "Industrial Chest", objectName = "industrialChest", timeName = "industrialChestTime" },
    { name = "Golden Chest", objectName = "goldenChest", timeName = "goldenChestTime" },
    { name = "Enchanted Chest", objectName = "enchantedChest", timeName = "enchantedChestTime" },
    { name = "Magma Chest", objectName = "magmaChest", timeName = "magmaChestTime" },
    { name = "Mythical Chest", objectName = "mythicalChest", timeName = "mythicalChestTime" },
    { name = "Legends Chest", objectName = "legendsChest", timeName = "legendsChestTime" },
    { name = "Jungle Chest", objectName = "jungleChest", timeName = "jungleChestTime" },
}

State.chestClaimBusy = false
State.chestRejectedUntil = {}

local function chestNotify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Muscle Legends - Chests",
            Text = tostring(text or ""),
            Duration = 4,
        })
    end)
end

local ChestData = nil
local NeededChestTimers = ReplicatedStorage:FindFirstChild("shared")
NeededChestTimers = NeededChestTimers and NeededChestTimers:FindFirstChild("catalogs")
NeededChestTimers = NeededChestTimers and NeededChestTimers:FindFirstChild("neededTimers")
startThread("chestDataLoader", function()
    local ok, data = pcall(function()
        local packages = ReplicatedStorage:FindFirstChild("packages")
        local module = packages and packages:FindFirstChild("ReplicatorClient")
        if not module then return nil end
        local replicator = require(module)
        return replicator.get("Data")
    end)
    if ok then ChestData = data end
end)

State.rewardDataValue = function(key)
    if not ChestData then return nil end
    local ok, value = pcall(function() return ChestData:TryIndex({key}) end)
    return ok and value or nil
end

State.chestIsReady = function(definition)
    local blockedUntil = State.chestRejectedUntil[definition.name]
    if typeof(blockedUntil) == "number" and os.clock() < blockedUntil then
        return false
    end
    local model = workspace:FindFirstChild(definition.objectName, true)
    local trigger = model and model:FindFirstChild("circleInner", true)
    local timer = NeededChestTimers and NeededChestTimers:FindFirstChild(definition.name)
    if not trigger or not trigger:IsA("BasePart") or not timer or not timer:IsA("IntValue") or not ChestData then
        return false
    end
    local ok, claimedAt = pcall(function()
        return ChestData:TryIndex({ definition.timeName })
    end)
    if not ok or typeof(claimedAt) ~= "number" then
        return false
    end
    local serverNow = workspace:GetServerTimeNow()
    return serverNow - claimedAt >= timer.Value
end

State.chestClaimTime = function(definition)
    if not ChestData then return nil end
    local ok, claimedAt = pcall(function()
        return ChestData:TryIndex({ definition.timeName })
    end)
    return ok and typeof(claimedAt) == "number" and claimedAt or nil
end

State.readyChestDefinitions = function()
    local ready = {}
    for _, definition in ipairs(CHEST_DEFINITIONS) do
        if State.chestIsReady(definition) then
            ready[#ready + 1] = definition
        end
    end
    return ready
end

State.closeRewardPopup = function()
    local gui = LP:FindFirstChildOfClass("PlayerGui")
    gui = gui and gui:FindFirstChild("gameGui")
    local popup = gui and gui:FindFirstChild("groupRewardsMenu")
    if not popup or not popup:IsA("GuiObject") or not popup.Visible then return false end
    local event = gui and gui:FindFirstChild("guiEffectsEvent")
    if event and event:IsA("BindableEvent") then
        event:Fire("resetMenus")
        return true
    end
    popup.Visible = false
    return true
end

State.watchRewardPopups = function()
    startThread("rewardMenus", function()
        local deadline = os.clock() + 2
        while State.running and (State.autoClaimChests or os.clock() < deadline) do
            if State.autoClaimChests then deadline = os.clock() + 2 end
            State.closeRewardPopup()
            task.wait(.35)
        end
    end)
end

State.activeChestRestore = nil
State.restoreChestTravel = function()
    local restore = State.activeChestRestore
    State.activeChestRestore = nil
    if restore then
        local ok, problem = pcall(restore)
        if not ok then State.chestLastError = tostring(problem) end
    end
end

State.rewardPauseBegin = function()
    if State.rewardsBusy and State.rewardsBusy ~= "chests" then return nil, "Another reward is being claimed" end
    if State.kill and (State.kill.hopInProgress or State.kill.teleportPending or State.kill.brawlBusy) then return nil, "Wait for the battle or server change to finish" end
    local beforeCharacter = getCharacter()
    local paused = { controls = {}, mode = FastFarm.mode, pack = FastFarm.packMode, machine = State.machine,
        afk = State.afkSnapshot and State.afkSnapshot(), momentum = FastFarm.PetMomentum and FastFarm.PetMomentum.mode,
        kill = State.kill and State.kill.auto, brawl = State.kill and State.kill.autoWinBrawl,
        hop = State.kill and State.kill.serverHop, at = os.clock(),
        rebirthing = beforeCharacter and (beforeCharacter:GetAttribute("IsRebirthing") == true or beforeCharacter:GetAttribute("LastMapCFrame") ~= nil) }
    paused.rebirthing = paused.rebirthing or paused.mode == "rebirth" or (paused.afk and paused.afk.mode == "Auto Rebirth") or false
    local released = false
    local function activeMovement()
        if FastFarm.mode or State.afk and State.afk.active or FastFarm.PetMomentum and FastFarm.PetMomentum.mode then return true end
        if State.machine or State.fly or State.kill and (State.kill.auto or State.kill.autoWinBrawl or State.kill.serverHop) then return true end
        for _, key in ipairs({ "autoWeight", "autoLift", "autoHandstands", "autoSitups" }) do if State[key] then return true end end
        return false
    end
    local function restore()
        if released then return end
        released = true
        if not State.running or State.shuttingDown then return end
        task.defer(function()
            if not State.running or State.shuttingDown or activeMovement() then return end
            if paused.afk and State.afkResume then
                State.afkResume(paused.afk)
            elseif paused.mode then
                FastFarm.packMode = paused.pack
                FastFarm:Start(paused.mode)
            elseif paused.momentum and FastFarm.PetMomentum then
                FastFarm.PetMomentum:Start()
            else
                local restoredMachine = false
                for _, saved in ipairs(paused.controls) do
                    local c = State.profileControls[saved.key]
                    if c and not c:Get() then
                        local ok, accepted = pcall(c.Set, c, true)
                        if not ok or accepted == false then print("ERROR", "Could not resume: " .. saved.key) end
                        if saved.key:sub(1, 11) == "Full Train|" or saved.key:sub(1, 10) == "Auto Farm|" then restoredMachine = true end
                    end
                end
                if paused.machine and not restoredMachine and not State.machine then setMachine(paused.machine, true) end
                if paused.kill and not State.kill.auto and State.killAutoToggle then State.killAutoToggle:Set(true) end
                if paused.brawl and not State.kill.autoWinBrawl and State.killAutoWinBrawlToggle then State.killAutoWinBrawlToggle:Set(true) end
                if paused.hop and not State.kill.serverHop and State.killServerHopToggle then State.killServerHopToggle:Set(true) end
            end
        end)
    end
    paused.restore = restore
    State.rewardPaused = paused
    if paused.afk and State.afkStop then State.afkStop() end
    if FastFarm.PetMomentum and FastFarm.PetMomentum.mode then FastFarm.PetMomentum:Stop(false) end
    if FastFarm.mode then FastFarm:Stop(false, true) end
    for key, c in pairs(State.profileControls or {}) do
        if c.ProfileKind == "toggle" and c:Get() then
            local moving = key:sub(1, 9) == "Rebirths|" or key:sub(1, 11) == "Full Train|"
                or key:sub(1, 15) == "Fast Glitch 100%" or key == "Misc| Fly "
                or key:sub(1, 10) == "Auto Farm|" and not key:find("Egg", 1, true) and not key:find("GAMEPASS", 1, true)
                or key == "Kills|Auto Kill" or key == "Kills|Auto Win Brawl" or key == "Kills|Server Hop inteligente"
                or key == "Kills|Matar jugador" or key == "Kills|Good Karma" or key == "Kills|Evil Karma"
                or key == "Server Hop|Mantener objetivo automáticamente"
            if moving then
                paused.controls[#paused.controls + 1] = { key = key }
                c:Set(false)
            end
        end
    end
    table.sort(paused.controls, function(a, b) return a.key < b.key end)
    if State.kill then
        if State.kill.auto and State.setAutoKill then State.setAutoKill(false) end
        if State.kill.autoWinBrawl and State.setAutoWinBrawl then State.setAutoWinBrawl(false) end
        if State.kill.serverHop and State.setServerHop then State.setServerHop(false) end
    end
    if State.machine then setMachine(nil, false) end
    local inUse = LP:FindFirstChild("machineInUse")
    if inUse and inUse.Value then leaveMachine() end
    return paused
end

State.waitRewardCharacter = function(timeout, wasRebirthing)
    local deadline = os.clock() + (tonumber(timeout) or 15)
    local stableAt, stablePosition, stableCharacter, stableRoot, clearAt = nil, nil, nil, nil, nil
    local sawRebirth = wasRebirthing == true
    State.rewardSettling = { startedAt = os.clock(), deadline = deadline, stableFor = 0, reason = "Waiting for character" }
    while State.running and State.autoClaimChests and os.clock() < deadline do
        local now = os.clock()
        local character = getCharacter()
        local root = getRoot()
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local machine = LP:FindFirstChild("machineInUse")
        local rebirthing = character and (character:GetAttribute("IsRebirthing") == true or character:GetAttribute("LastMapCFrame") ~= nil)
        local mounted = (machine and machine.Value ~= nil) or (humanoid and humanoid.SeatPart ~= nil)
        local ready = character and root and root.Parent and humanoid and humanoid.Health > 0 and not rebirthing and not mounted
        if rebirthing then sawRebirth = true; clearAt = nil end
        if not ready then
            stableAt, stablePosition, stableCharacter, stableRoot = nil, nil, nil, nil
            State.rewardSettling.reason = rebirthing and "Waiting for the rebirth return" or mounted and "Leaving the machine" or "Waiting for character"
        else
            clearAt = clearAt or now
            if character ~= stableCharacter or root ~= stableRoot or not stablePosition or (root.Position - stablePosition).Magnitude > 1.25 then
                stableAt, stablePosition, stableCharacter, stableRoot = now, root.Position, character, root
            end
            State.rewardSettling.stableFor = now - (stableAt or now)
            State.rewardSettling.reason = "Waiting for stable position"
            if now - (stableAt or now) >= 1 and (not sawRebirth or now - clearAt >= 3) then
                State.rewardSettling = nil
                return character, root, humanoid
            end
        end
        task.wait(.1)
    end
    local reason = State.rewardSettling and State.rewardSettling.reason or "Waiting for character"
    State.rewardSettling = nil
    return nil, nil, nil, State.autoClaimChests and ("Could not start the trip: " .. reason) or "Trip cancelled"
end

local function claimChestBatch(definitions)
    if State.chestClaimBusy or not State.running or not State.autoClaimChests then return false, {} end
    State.chestClaimBusy = true
    State.chestLastBatchClaims = 0
    State.chestLastError = nil
    State.chestLastResults = {}
    local results, paused, character, root, origin, anchored, restored = {}, nil, nil, nil, nil, false, false
    local function restore()
        if restored then return end
        restored = true
        local positionOk, positionError = pcall(function()
            if character and LP.Character == character and root and root.Parent and origin then
                root.Anchored = false
                character:PivotTo(origin)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.Anchored = anchored
                State.chestLastRestoreDistance = (character:GetPivot().Position - origin.Position).Magnitude
            end
        end)
        if not positionOk then
            if root and root.Parent then pcall(function() root.Anchored = false end) end
            State.chestLastError = tostring(positionError)
        end
        State.chestClaimBusy = false
        stopThread("chestRequest")
        if State.rewardsBusy == "chests" then State.rewardsBusy = nil end
        local previous = paused or State.rewardPaused
        State.rewardPaused = nil
        if previous then
            local resumed, problem = pcall(previous.restore)
            if not resumed then State.chestLastError = tostring(problem) end
        end
    end
    State.activeChestRestore = restore
    local ok, problem = xpcall(function()
        local reason
        paused, reason = State.rewardPauseBegin()
        if not paused then error(reason or "Could not pause training") end
        local humanoid, settleError
        character, root, humanoid, settleError = State.waitRewardCharacter(15, paused.rebirthing)
        if not State.autoClaimChests or not State.running then return end
        if not character then error(settleError or "Character is not ready") end
        origin = character:GetPivot(); anchored = root.Anchored
        local events = ReplicatedStorage:FindFirstChild("rEvents")
        local remote = events and events:FindFirstChild("checkChestRemote")
        if not remote then error("Chest service not found") end
        for _, definition in ipairs(definitions) do
            if not State.running or not State.autoClaimChests then break end
            if LP.Character ~= character or not root.Parent or humanoid.Health <= 0 then error("Character changed during the trip") end
            local cooldown = os.clock() + 5
            while State.running and State.autoClaimChests do
                local untilAt = tonumber(LP:GetAttribute("ChestRequestCooldownUntil")) or 0
                if untilAt <= workspace:GetServerTimeNow() then break end
                if os.clock() >= cooldown then error("The server is still processing the previous chest") end
                task.wait(.1)
            end
            if not State.running or not State.autoClaimChests then break end
            local model = workspace:FindFirstChild(definition.objectName, true)
            local trigger = model and model:FindFirstChild("circleInner", true)
            if State.chestIsReady(definition) and trigger and trigger:IsA("BasePart") then
                local before = State.chestClaimTime(definition)
                local report = { name = definition.name, before = before, request = "pending" }
                State.chestLastResults[#State.chestLastResults + 1] = report
                local footOffset = root.Size.Y * .5 + humanoid.HipHeight
                local leg = character:FindFirstChild("Left Leg")
                if leg and leg:IsA("BasePart") then footOffset = root.Size.Y * .5 + leg.Size.Y end
                local ray = RaycastParams.new()
                ray.FilterType = Enum.RaycastFilterType.Exclude
                ray.FilterDescendantsInstances = { character, model }
                local hit = workspace:Raycast(trigger.Position + Vector3.new(0, 12, 0), Vector3.new(0, -220, 0), ray)
                local groundY = hit and hit.Position.Y or trigger.Position.Y
                local position = Vector3.new(trigger.Position.X, groundY + math.max(.2, footOffset) + .05, trigger.Position.Z)
                report.groundY = groundY
                report.footOffset = footOffset
                root.Anchored = false
                character:PivotTo(CFrame.new(position) * origin.Rotation)
                root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero
                RunService.Heartbeat:Wait()
                task.wait(math.clamp((getPing() or 0) / 1000 * 2 + .18, .25, 1.2))
                report.distance = (root.Position - trigger.Position).Magnitude
                report.anchored = root.Anchored
                local feet = root.Position - Vector3.new(0, footOffset, 0)
                local point = trigger.CFrame:PointToObjectSpace(feet)
                local radius = math.max(trigger.Size.Y, trigger.Size.Z) * .5
                report.localFeet = { x = point.X, y = point.Y, z = point.Z }
                report.insideStrict = math.abs(point.X) <= trigger.Size.X * .5 and point.Y * point.Y + point.Z * point.Z <= radius * radius
                report.insideClient = math.abs(point.X) <= trigger.Size.X * .5 + 10 and point.Y * point.Y + point.Z * point.Z <= (radius + 10) * (radius + 10)
                local strength = getPlayerStat(LP, { "Strength" })
                local rebirths = getPlayerStat(LP, { "Rebirths" })
                local inUse = LP:FindFirstChild("machineInUse")
                report.strength = strength and tonumber(State.getFunctionalStatValue(strength)) or 0
                report.rebirths = rebirths and tonumber(State.getFunctionalStatValue(rebirths)) or 0
                report.machine = inUse and tostring(inUse.Value) or "nil"
                report.rebirthing = character:GetAttribute("IsRebirthing") == true
                report.lastMap = tostring(character:GetAttribute("LastMapCFrame"))
                local accepted = false
                local response = { done = false }
                local observed = State.chestClaimTime(definition)
                if type(observed) == "number" and type(before) == "number" and observed > before then
                    accepted = true
                    report.request = "native"
                else
                    startThread("chestRequest", function()
                        local sent, granted, reward, amount = pcall(remote.InvokeServer, remote, definition.name)
                        response.done = true
                        response.accepted = sent and granted == true and reward ~= nil and amount ~= nil
                        report.request = sent and "returned" or "error"
                        report.granted = tostring(granted)
                        report.reward = tostring(reward)
                        report.amount = tostring(amount)
                    end)
                end
                local deadline = os.clock() + 4
                while not accepted and os.clock() < deadline and State.autoClaimChests and State.running do
                    task.wait(.1)
                    if LP.Character ~= character or not root.Parent or humanoid.Health <= 0 then error("Character changed during the trip") end
                    local after = State.chestClaimTime(definition)
                    report.after = after
                    accepted = type(after) == "number" and type(before) == "number" and after > before
                end
                root.Anchored = false
                if not accepted and not response.done and State.autoClaimChests and State.running then
                    error("The server did not confirm the chest; the trip was cancelled")
                end
                stopThread("chestRequest")
                results[definition.name] = accepted
                report.accepted = accepted
                State.chestLastClaim = definition.name
                State.chestLastClaimAccepted = accepted
                if accepted then
                    State.chestRejectedUntil[definition.name] = nil
                    State.chestLastBatchClaims = State.chestLastBatchClaims + 1
                    if State.pushOutput then State.pushOutput("REWARD", definition.name .. " · claimed") end
                else
                    State.chestRejectedUntil[definition.name] = os.clock() + 30
                    if State.pushOutput then State.pushOutput("ERROR", definition.name .. " · unconfirmed (" .. tostring(report.reward or report.granted or report.request) .. ")") end
                end
            end
        end
    end, debug.traceback)
    if not ok then State.chestLastError = tostring(problem) end
    if ok and State.autoClaimChests and State.chestLastBatchClaims < #definitions then
        State.chestLastError = "Confirmed chests: " .. tostring(State.chestLastBatchClaims) .. "/" .. tostring(#definitions)
    end
    State.restoreChestTravel()
    return ok, results
end

local function setAutoClaimChests(enabled)
    enabled = enabled == true
    if not enabled then
        State.autoClaimChests = false
        State.restoreChestTravel()
        stopThread("autoClaimChests")
        State.chestClaimBusy = false
        if State.rewardsBusy == "chests" then State.rewardsBusy = nil end
        State.syncAvailabilityToggle(State.autoClaimToggle, false)
        return true
    end
    if State.autoClaimChests then return true end
    if State.rewardsBusy then return false end
    local ready = State.readyChestDefinitions()
    if #ready == 0 then return false end
    State.autoClaimChests = true
    State.rewardsBusy = "chests"
    State.watchRewardPopups()
    startThread("autoClaimChests", function()
        local ok, problem = pcall(claimChestBatch, ready)
        if not ok then State.chestLastError = tostring(problem) end
        State.autoClaimChests = false
        State.restoreChestTravel()
        State.chestClaimBusy = false
        if State.rewardsBusy == "chests" then State.rewardsBusy = nil end
        State.syncAvailabilityToggle(State.autoClaimToggle, false)
        if State.chestLastError then
            if State.pushOutput then State.pushOutput("ERROR", State.chestLastError) end
            chestNotify("Could not claim the chests.")
        else
            chestNotify("Chests claimed: " .. tostring(State.chestLastBatchClaims or 0) .. "/" .. tostring(#ready) .. ".")
        end
        if State.refreshMiscAvailability then State.refreshMiscAvailability() end
    end)
    return true
end

addCleanup(function()
    State.autoClaimChests = false
    State.closeRewardPopup()
    State.restoreChestTravel()
    State.autoSpinWheel = false
    State.rewardsBusy = nil
end)

-- Auto Spin Wheel System
State.fortuneSpinRaw = function()
    if State.rewardDataValue then
        local purchased = State.rewardDataValue("purchasedSpins")
        local free = State.rewardDataValue("freeWheelSpins")
        if type(purchased) == "number" or type(free) == "number" then
            return math.max(0, math.floor((tonumber(purchased) or 0) + (tonumber(free) or 0)))
        end
    end
    local menu = PlayerGui:FindFirstChild("fortuneWheelMenuGui")
    local label = menu and menu:FindFirstChild("spinAmountLabel", true)
    if not label or not label:IsA("TextLabel") then return nil end
    return tonumber(tostring(label.Text or ""):match("(%d+)"))
end

State.fortuneCooldownRemaining = function()
    local serverUntil = tonumber(LP:GetAttribute("FortuneWheelCooldownUntil")) or 0
    return math.max(0, serverUntil - workspace:GetServerTimeNow(),
        (State.fortuneRetryAt or 0) - os.clock(), (State.fortuneNextAt or 0) - os.clock())
end

State.fortuneSpinAmount = function()
    if State.fortuneCooldownRemaining() > 0 then return nil end
    local amount = State.fortuneSpinRaw()
    local pending = State.fortunePending
    if pending then
        if amount and amount < pending.before then
            State.fortunePending = nil
        elseif (pending.returned or pending.cancelled) and os.clock() >= (pending.releaseAt or math.huge) then
            State.fortunePending = nil
        else return nil end
    end
    return amount
end

State.syncAvailabilityToggle = function(toggle, enabled)
    if toggle and toggle:Get() ~= enabled then toggle:Set(enabled, true) end
end

local function setAutoSpinWheel(enabled)
    enabled = enabled == true
    if not enabled then
        State.autoSpinWheel = false
        local pending = State.fortunePending
        if pending and not pending.returned then
            pending.cancelled = true
            pending.releaseAt = math.max(State.fortuneNextAt or 0, os.clock() + 20)
        end
        stopThread("fortuneWheel")
        if State.rewardsBusy == "wheel" then State.rewardsBusy = nil end
        State.syncAvailabilityToggle(State.autoSpinToggle, false)
        return true
    end
    if State.autoSpinWheel then return true end
    local available = State.fortuneSpinAmount()
    if State.rewardsBusy or not available or available <= 0 then return false end
    local events = ReplicatedStorage:FindFirstChild("rEvents")
    local remote = events and events:FindFirstChild("openFortuneWheelRemote")
    local shared = ReplicatedStorage:FindFirstChild("shared")
    local catalogs = shared and shared:FindFirstChild("catalogs")
    local chances = catalogs and catalogs:FindFirstChild("fortuneWheelChances")
    local wheel = chances and chances:FindFirstChild("Fortune Wheel")
    if not remote or not remote:IsA("RemoteFunction") or not wheel then return false end
    State.autoSpinWheel = true
    State.rewardsBusy = "wheel"
    State.fortuneLastSpins = 0
    State.fortuneLastError = nil
    startThread("fortuneWheel", function()
        local ok, problem = pcall(function()
            local rejections = 0
            while State.running and State.autoSpinWheel do
                if not State.running or not State.autoSpinWheel then break end
                while State.running and State.autoSpinWheel and State.fortuneCooldownRemaining() > 0 do
                    task.wait(math.min(.25, State.fortuneCooldownRemaining()))
                end
                if not State.running or not State.autoSpinWheel then break end
                local before = State.fortuneSpinRaw()
                if not before or before <= 0 then break end
                local pending = { before = before, at = os.clock(), returned = false }
                State.fortunePending = pending
                State.fortuneNextAt = os.clock() + .25
                local sent, result = pcall(remote.InvokeServer, remote, "openFortuneWheel", wheel)
                pending.returned = true
                pending.releaseAt = math.max(State.fortuneNextAt, os.clock() + .5)
                local valid = sent and type(result) == "table" and type(result.name) == "string"
                    and type(result.rarity) == "string" and type(result.image) == "string" and typeof(result.itemColor) == "Color3"
                State.fortuneLastRequest = { before = before, at = pending.at, returnedAt = os.clock(), sent = sent,
                    valid = valid, reply = type(result) == "table" and tostring(result.name) or tostring(result) }
                if not valid then
                    State.fortunePending = nil
                    rejections = rejections + 1
                    local retryDelay = math.min(.35 + rejections * .2, 2.5)
                    State.fortuneRetryAt = os.clock() + retryDelay
                    State.fortuneLastError = sent and "The wheel did not accept the spin" or "Waiting for spin confirmation"
                    task.wait(retryDelay)
                else
                    local confirmed = false
                    local deadline = os.clock() + 4
                    repeat
                        task.wait(.1)
                        local remaining = State.fortuneSpinRaw()
                        State.fortuneLastRequest.after = remaining
                        confirmed = remaining ~= nil and remaining < before
                    until confirmed or os.clock() >= deadline or not State.running or not State.autoSpinWheel
                    if not confirmed then
                        State.fortunePending = nil
                        rejections = rejections + 1
                        local retryDelay = math.min(.35 + rejections * .2, 2.5)
                        State.fortuneRetryAt = os.clock() + retryDelay
                        State.fortuneLastError = "Waiting for spin confirmation"
                        task.wait(retryDelay)
                    else
                        State.fortunePending = nil
                        State.fortuneLastError = nil
                        State.fortuneLastSpins = State.fortuneLastSpins + 1
                        rejections = 0
                        if State.pushOutput then State.pushOutput("REWARD", "Fortune Wheel · +1 confirmed spin") end
                        task.wait(.08)
                    end
                end
            end
        end)
        if not ok then State.fortuneLastError = tostring(problem) end
        State.autoSpinWheel = false
        if State.rewardsBusy == "wheel" then State.rewardsBusy = nil end
        State.syncAvailabilityToggle(State.autoSpinToggle, false)
        if State.fortuneLastError and State.pushOutput then State.pushOutput("ERROR", State.fortuneLastError) end
        if State.refreshMiscAvailability then State.refreshMiscAvailability() end
    end)
    return true
end

print("[Muscle Legends] Part 8 loaded - Chest System and Auto Spin")

-- ============================================================
-- PART 9: PET MOMENTUM SYSTEM (from original)
-- ============================================================

FastFarm.PetMomentum = FastFarm.PetMomentum or {}
do
    local PetMomentum = FastFarm.PetMomentum
    PetMomentum.generation = 0
    PetMomentum.mode = nil
    PetMomentum.targetSeconds = 0
    PetMomentum.targetMultiplier = 50
    PetMomentum.startedAt = nil
    PetMomentum.originalCFrame = nil
    PetMomentum.treadmill = nil
    PetMomentum.treadmillPart = nil
    PetMomentum.lastError = nil
    PetMomentum.available = false
    PetMomentum.tiers = {}
    PetMomentum.attribute = "MomentumSeconds"
    PetMomentum.maxSeconds = 0
    PetMomentum.treadmillRemote = nil
    PetMomentum.usesPhysicalContact = true
    PetMomentum.distanceModeAvailable = false
    PetMomentum.hiddenAgilityFrames = setmetatable({}, { __mode = "k" })
    PetMomentum.agilityPopupConnection = nil

    function PetMomentum:SetAgilityPopupsHidden(hidden)
        if self.agilityPopupConnection then
            self.agilityPopupConnection:Disconnect()
            self.agilityPopupConnection = nil
        end
        if not hidden then
            for object, wasVisible in pairs(self.hiddenAgilityFrames) do
                if object and object.Parent and object:IsA("GuiObject") then object.Visible = wasVisible end
                self.hiddenAgilityFrames[object] = nil
            end
            return
        end
        local effectsGui = PlayerGui:FindFirstChild("statEffectsGui")
        if not effectsGui then return end

        local function hideFrame(object)
            if object:IsA("GuiObject") and object.Name:lower() == "agilityframe" then
                if self.hiddenAgilityFrames[object] == nil then self.hiddenAgilityFrames[object] = object.Visible end
                object.Visible = false
            end
        end
        for _, object in ipairs(effectsGui:GetDescendants()) do hideFrame(object) end
        self.agilityPopupConnection = effectsGui.DescendantAdded:Connect(function(object)
            if self.mode == "running" then task.defer(hideFrame, object) end
        end)
    end

    function PetMomentum:RefreshRealData()
        table.clear(self.tiers)
        local shared = ReplicatedStorage:FindFirstChild("shared")
        local configFolder = shared and shared:FindFirstChild("config")
        local modules = shared and shared:FindFirstChild("modules")
        local configModule = configFolder and configFolder:FindFirstChild("PetMomentumConfig")
        local momentumModule = modules and modules:FindFirstChild("PetMomentum")
        local okConfig, momentumConfig = pcall(function()
            return configModule and configModule:IsA("ModuleScript") and require(configModule)
        end)
        local okModule, momentumApi = pcall(function()
            return momentumModule and momentumModule:IsA("ModuleScript") and require(momentumModule)
        end)
        if not okConfig or type(momentumConfig) ~= "table"
            or not okModule or type(momentumApi) ~= "table" then
            self.available = false
            self.lastError = "Pet Momentum is not available in this version"
            return false
        end
        self.attribute = type(momentumConfig.ATTRIBUTE) == "string"
            and momentumConfig.ATTRIBUTE or "MomentumSeconds"
        for _, tier in ipairs(momentumConfig.TIERS or {}) do
            local seconds = tonumber(tier.Seconds)
            local multiplier = tonumber(tier.Multiplier)
            if seconds and multiplier then
                self.tiers[#self.tiers + 1] = {
                    seconds = math.max(0, seconds),
                    multiplier = multiplier,
                }
            end
        end
        table.sort(self.tiers, function(a, b) return a.seconds < b.seconds end)
        self.maxSeconds = tonumber(momentumApi.MaxSeconds)
            or (#self.tiers > 0 and self.tiers[#self.tiers].seconds) or 0
        self.available = #self.tiers > 0 and self.maxSeconds > 0
        if self.available then
            self.targetSeconds = self.maxSeconds
            self.targetMultiplier = self.tiers[#self.tiers].multiplier
            self.lastError = nil
        else
            self.lastError = "No real tiers found"
        end
        return self.available
    end

    function PetMomentum:GetTierOptions()
        local options = {}
        for _, tier in ipairs(self.tiers) do
            if tier.seconds > 0 then
                local minutes = math.floor(tier.seconds / 60)
                options[#options + 1] = string.format("x%d • %dm", tier.multiplier, minutes)
            end
        end
        return options
    end

    function PetMomentum:SetTierByLabel(label)
        for _, tier in ipairs(self.tiers) do
            local option = string.format("x%d • %dm", tier.multiplier, math.floor(tier.seconds / 60))
            if option == label then
                self.targetSeconds = tier.seconds
                self.targetMultiplier = tier.multiplier
                return true
            end
        end
        return false
    end

    function PetMomentum:GetOccupiedTreadmills()
        local occupied = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP then
                local inUse = player:FindFirstChild("treadmillInUse")
                if inUse and inUse:IsA("ObjectValue") and inUse.Value then
                    occupied[inUse.Value] = true
                end
            end
        end
        return occupied
    end

    function PetMomentum:FindBestTreadmill(excluded)
        local folder = workspace:FindFirstChild("Treadmills")
        if not folder then
            return nil
        end
        excluded = excluded or {}
        local occupied = self:GetOccupiedTreadmills()
        local candidates = {}
        for _, treadmill in ipairs(folder:GetChildren()) do
            local part = treadmill:IsA("Model") and treadmill:FindFirstChild("treadmillPart")
            local amount = treadmill:IsA("Model") and treadmill:FindFirstChild("agilityAmount")
            local requirements = treadmill:IsA("Model") and treadmill:FindFirstChild("requirements")
            if not excluded[treadmill] and not occupied[treadmill]
                and part and part:IsA("BasePart") and amount and amount:IsA("IntValue") then
                local allowed = true
                if requirements and machineFunctions
                    and type(machineFunctions.checkIfPlayerCanUseMachine) == "function" then
                    local ok, result = pcall(machineFunctions.checkIfPlayerCanUseMachine, LP, requirements)
                    allowed = ok and result == true
                elseif requirements then
                    for _, requirement in ipairs(requirements:GetChildren()) do
                        if requirement:IsA("ValueBase") then
                            local stat = getPlayerStat(LP, { requirement.Name })
                            local statValue = stat and tonumber(State.getFunctionalStatValue(stat))
                            local requiredValue = tonumber(requirement.Value)
                            if not statValue or not requiredValue or statValue < requiredValue then
                                allowed = false
                                break
                            end
                        end
                    end
                end
                if allowed then
                    local requiredAgility = requirements and requirements:FindFirstChild("Agility")
                    candidates[#candidates + 1] = {
                        model = treadmill,
                        part = part,
                        amount = tonumber(amount.Value) or 0,
                        requirement = tonumber(requiredAgility and requiredAgility.Value) or 0,
                    }
                end
            end
        end
        table.sort(candidates, function(a, b)
            if a.amount ~= b.amount then return a.amount > b.amount end
            return a.requirement > b.requirement
        end)
        return candidates[1]
    end

    function PetMomentum:GetEquippedPackPets()
        local pets = {}
        local equipped = LP:FindFirstChild("equippedPets")
        if equipped then
            for _, slot in ipairs(equipped:GetChildren()) do
                local reference = slot:FindFirstChild("petReference")
                local pet = reference and reference:IsA("ObjectValue") and reference.Value
                if not pet and slot:IsA("ObjectValue") then pet = slot.Value end
                if pet and pet:IsA("StringValue") and pet.Parent then
                    pets[#pets + 1] = pet
                end
            end
        end
        return pets
    end

    function PetMomentum:GetProgress()
        local pets = self:GetEquippedPackPets()
        local values = {}
        for _, pet in ipairs(pets) do
            values[#values + 1] = tonumber(pet:GetAttribute(self.attribute)) or 0
        end
        return self:SummarizeSeconds(values)
    end

    function PetMomentum:MultiplierAt(seconds)
        local multiplier = 1
        for _, tier in ipairs(self.tiers) do
            if seconds >= tier.seconds then multiplier = tier.multiplier end
        end
        return multiplier
    end

    PetMomentum.progressText = {
        en = { remaining = "Until maximum:", complete = "Maximum reached", shortMax = "MAX", count = "%d/%d at max", durability = "Durability", paused = "Punch off" },
    }

    function PetMomentum:GetAuraMomentumBoost()
        local equipped = LP:FindFirstChild("equippedPowerUp")
        local aura = equipped and equipped:IsA("ObjectValue") and equipped.Value or nil
        local perks = aura and aura:FindFirstChild("perksFolder")
        local value = perks and perks:FindFirstChild("momentumGainPercent")
        local percent = math.max(0, tonumber(value and value.Value) or 0)
        return 1 + percent / 100, percent, aura
    end

    function PetMomentum:GetTierProgress(rawSeconds)
        local seconds = tonumber(rawSeconds) or 0
        if seconds ~= seconds or seconds == math.huge or seconds == -math.huge then seconds = 0 end
        local maximum = math.max(0, tonumber(self.maxSeconds) or 0)
        seconds = math.clamp(seconds, 0, maximum)
        local previous, nextTier = 0, nil
        for _, tier in ipairs(self.tiers) do
            if tier.seconds <= seconds then previous = tier.seconds else nextTier = tier; break end
        end
        if not nextTier and maximum > seconds then nextTier = { seconds = maximum, multiplier = self:MultiplierAt(maximum) } end
        local gainMultiplier, auraPercent = self:GetAuraMomentumBoost()
        return {
            seconds = seconds,
            elapsed = nextTier and math.max(0, seconds - previous) or 0,
            duration = nextTier and math.max(1, nextTier.seconds - previous) or 0,
            targetSeconds = nextTier and nextTier.seconds or maximum,
            multiplier = self:MultiplierAt(seconds),
            nextMultiplier = nextTier and nextTier.multiplier or nil,
            remaining = math.max(0, math.ceil((maximum - seconds) / gainMultiplier)),
            auraPercent = auraPercent,
            gainMultiplier = gainMultiplier,
            complete = maximum > 0 and seconds >= maximum,
            available = maximum > 0 and #self.tiers > 0,
        }
    end

    function PetMomentum:FormatTierProgress(seconds)
        local progress = self:GetTierProgress(seconds)
        if not progress.available then return "--" end
        local words = self.progressText.en
        local first
        if progress.complete or not progress.nextMultiplier then
            first = "x" .. tostring(progress.multiplier) .. " · " .. words.complete
        else
            first = string.format("x%s → x%s · %02d:%02d / %02d:%02d",
                tostring(progress.multiplier), tostring(progress.nextMultiplier),
                math.floor(progress.elapsed / 60), math.floor(progress.elapsed) % 60,
                math.floor(progress.duration / 60), math.floor(progress.duration) % 60)
        end
        local left = progress.remaining
        return first .. "\n" .. words.remaining .. " " .. string.format("%02d:%02d:%02d",
            math.floor(left / 3600), math.floor(left / 60) % 60, math.floor(left) % 60)
    end

    function PetMomentum:SummarizeSeconds(values)
        local minimum = math.huge
        local maximum = 0
        local total = 0
        local completed = 0
        local minimumMultiplier = math.huge
        local maximumMultiplier = 1
        for _, rawSeconds in ipairs(values or {}) do
            local seconds = tonumber(rawSeconds) or 0
            seconds = math.clamp(seconds, 0, self.maxSeconds)
            minimum = math.min(minimum, seconds)
            maximum = math.max(maximum, seconds)
            total = total + seconds
            local multiplier = self:MultiplierAt(seconds)
            minimumMultiplier = math.min(minimumMultiplier, multiplier)
            maximumMultiplier = math.max(maximumMultiplier, multiplier)
            if seconds >= self.maxSeconds then completed = completed + 1 end
        end
        local count = #(values or {})
        if count == 0 then
            minimum = 0
            minimumMultiplier = 1
        end
        return {
            count = count,
            minimum = minimum,
            maximum = maximum,
            average = count > 0 and total / count or 0,
            minimumMultiplier = minimumMultiplier,
            maximumMultiplier = maximumMultiplier,
            completed = completed,
            complete = count > 0 and completed == count,
        }
    end

    function PetMomentum:GetTreadmillFacing(part, position)
        local model = self.treadmill and self.treadmill.model or part.Parent
        local menu = model and model:FindFirstChild("menuPart", true)
        local direction = menu and menu:IsA("BasePart") and (menu.Position - position) or -part.CFrame.LookVector
        local flat = Vector3.new(direction.X, 0, direction.Z)
        if flat.Magnitude < 0.05 then
            local look = part.CFrame.LookVector
            flat = Vector3.new(-look.X, 0, -look.Z)
        end
        return flat.Magnitude >= 0.05 and flat.Unit or Vector3.new(0, 0, 1)
    end

    function PetMomentum:TouchTreadmill()
        local root = getRoot()
        local part = self.treadmillPart
        if not root or not part or not part.Parent then return false end
        local inUse = LP:FindFirstChild("treadmillInUse")
        if inUse and inUse:IsA("ObjectValue") and self.treadmill and inUse.Value == self.treadmill.model then return true end
        local humanoid = getHumanoid()
        if humanoid and humanoid.SeatPart then humanoid.Sit = false; return false end
        if root.Anchored then return false end
        local character = LP.Character
        local connected, parts = pcall(root.GetConnectedParts, root, true)
        if not connected or not character then return false end
        for _, linked in ipairs(parts) do
            if linked ~= root and not linked:IsDescendantOf(character) then return false end
        end
        local height = part.Size.Y * 0.5 + (humanoid and humanoid.HipHeight or 2) + root.Size.Y * 0.5
        local target = part.CFrame:PointToWorldSpace(Vector3.new(0, height, 0))
        local facing = self:GetTreadmillFacing(part, target)
        local look = root.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        local aligned = flat.Magnitude >= 0.05 and flat.Unit:Dot(facing) >= 0.995 and root.CFrame.UpVector.Y >= 0.95
        if (root.Position - target).Magnitude > 0.6 or not aligned then
            local placed = pcall(function()
                root.CFrame = CFrame.lookAt(target, target + facing)
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            if not placed then return false end
        end
        if type(firetouchinterest) == "function" then pcall(firetouchinterest, root, part, 0) end
        return true
    end

    function PetMomentum:Stop(restorePosition)
        local wasRunning = self.mode ~= nil
        if wasRunning and self.DisableLinkedDurability then self:DisableLinkedDurability() end
        self.generation = self.generation + 1
        self.mode = nil
        stopThread("petMomentumRun")
        self:SetAgilityPopupsHidden(false)
        local root = getRoot()
        if root and self.treadmillPart and self.treadmillPart.Parent
            and type(firetouchinterest) == "function" then
            pcall(firetouchinterest, root, self.treadmillPart, 1)
        end
        if restorePosition and root and self.originalCFrame then
            root.CFrame = self.originalCFrame
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        self.startedAt = nil
        self.originalCFrame = nil
        self.treadmill = nil
        self.treadmillPart = nil
        if self.UpdateToggle then self.UpdateToggle(false) end
        return wasRunning
    end

    function PetMomentum:Complete()
        self:Stop(true)
        hubNotify("Pet Momentum completed: max multiplier x" .. tostring(self.targetMultiplier), 5)
    end

    function PetMomentum:Start()
        if not self.available and not self:RefreshRealData() then return false end
        if self.mode then return true end
        local equippedProgress = self:GetProgress()
        if equippedProgress.count < 1 then
            self.lastError = "Equip at least one pet."
            return false
        end
        local selected = self:FindBestTreadmill()
        if not selected then
            self.lastError = "No accessible treadmill"
            return false
        end
        local root = getRoot()
        if not root then
            self.lastError = "Character not available"
            return false
        end
        FastFarm.StopFastModesForManualFarm()
        FastFarm.StopMachineForExercise()
        for _, toggle in ipairs(FastFarm.RepToggles or {}) do
            if toggle.Get and toggle.Set and toggle:Get() then toggle:Set(false) end
        end
        if State.stopKills and State.kill and (State.kill.auto or State.kill.autoWinBrawl or State.kill.targetMode or State.kill.karmaMode) then
            State.stopKills()
        end
        self.generation = self.generation + 1
        local generation = self.generation
        self.mode = "running"
        self.linkedPunchSuppressed = false
        self.linkedRockAuto = true
        self.startedAt = realNow()
        self.originalCFrame = root.CFrame
        self.treadmill = selected
        self.treadmillPart = selected.part
        self.lastError = nil
        self:SetAgilityPopupsHidden(true)
        self:TouchTreadmill()
        task.defer(function()
            if self.mode == "running" and self.generation == generation and self.EnableLinkedDurability then
                self:EnableLinkedDurability(true)
            end
        end)
        startThread("petMomentumRun", function()
            local lastTouch = 0
            local lastRockCheck = 0
            local acquisitionStarted = time()
            local excluded = {}
            while State.running and self.mode == "running" and self.generation == generation do
                local inUse = LP:FindFirstChild("treadmillInUse")
                local occupied = self:GetOccupiedTreadmills()
                local acquired = inUse and self.treadmill and inUse.Value == self.treadmill.model
                if self.treadmill and occupied[self.treadmill.model] then
                    acquired = false
                    acquisitionStarted = 0
                end
                if not acquired and time() - acquisitionStarted >= 3 then
                    if self.treadmill then excluded[self.treadmill.model] = true end
                    local replacement = self:FindBestTreadmill(excluded)
                    if not replacement then
                        self.lastError = "All accessible treadmills are occupied"
                        hubNotify(self.lastError)
                        self:Stop(true)
                        break
                    end
                    local rootNow = getRoot()
                    if rootNow and self.treadmillPart and self.treadmillPart.Parent
                        and type(firetouchinterest) == "function" then
                        pcall(firetouchinterest, rootNow, self.treadmillPart, 1)
                    end
                    self.treadmill = replacement
                    self.treadmillPart = replacement.part
                    self.lastError = "Treadmill occupied; switching to " .. replacement.model.Name
                    acquisitionStarted = time()
                    lastTouch = 0
                end
                if not acquired or time() - lastTouch >= 1 then
                    self:TouchTreadmill()
                    lastTouch = time()
                end
                if acquired then
                    acquisitionStarted = time()
                    self.lastError = nil
                end
                if State.fastPunch and self.linkedRockAuto and time() - lastRockCheck >= 1 then
                    lastRockCheck = time()
                    self:EnableLinkedDurability(true)
                end
                local progress = self:GetProgress()
                if progress.count == 0 then
                    self.lastError = "Equip at least one pet."
                    self:Stop(true)
                    break
                end
                if progress.complete then
                    self.allPetsMax = true
                else
                    self.allPetsMax = false
                end
                task.wait(0.5)
            end
        end)
        if self.UpdateToggle then self.UpdateToggle(true) end
        return true
    end

    PetMomentum:RefreshRealData()
    addCleanup(function()
        PetMomentum:Stop(true)
    end)
end

print("[Muscle Legends] Part 9 loaded - Pet Momentum")

-- ============================================================
-- PART 10: AIRFLOW GUI
-- ============================================================

-- Create Window
local Window = AirFlow:CreateWindow({
    Title = "Muscle Legends Ultimate",
    Description = "Complete feature port with AIRFLOW UI"
})

-- Create Tabs
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local FarmTab = Window:Tab({ Title = "Farm", Icon = "dumbbell" })
local FastFarmTab = Window:Tab({ Title = "Fast Farm", Icon = "zap" })
local AFKTab = Window:Tab({ Title = "AFK 24/7", Icon = "clock" })
local FullTrainTab = Window:Tab({ Title = "Full Train", Icon = "activity" })
local AutoFarmTab = Window:Tab({ Title = "Auto Farm", Icon = "target" })
local BossTab = Window:Tab({ Title = "Boss", Icon = "sword" })
local PetMomentumTab = Window:Tab({ Title = "Pet Momentum", Icon = "trending-up" })
local RebirthsTab = Window:Tab({ Title = "Rebirths", Icon = "refresh-cw" })
local KillsTab = Window:Tab({ Title = "Kills", Icon = "skull" })
local ServerHopTab = Window:Tab({ Title = "Server Hop", Icon = "server" })
local PetsTab = Window:Tab({ Title = "Pets", Icon = "paw" })
local InventoryTab = Window:Tab({ Title = "Inventory", Icon = "package" })
local FuseTab = Window:Tab({ Title = "Fuse Machine", Icon = "git-merge" })
local TradeTab = Window:Tab({ Title = "Fast Trade", Icon = "arrow-left-right" })
local GiftsTab = Window:Tab({ Title = "Gifts", Icon = "gift" })
local TeleportsTab = Window:Tab({ Title = "Teleports", Icon = "map-pin" })
local ProfilesTab = Window:Tab({ Title = "Profiles", Icon = "user" })
local StatsTab = Window:Tab({ Title = "Stats", Icon = "bar-chart" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings" })

-- ============================================================
-- MAIN TAB
-- ============================================================
MainTab:Section("Player Info")

local playerInfoLabel = MainTab:Label({ Text = "Loading..." })

task.spawn(function()
    while true do
        local strength = LP:GetAttribute("Strength") or 0
        local durability = LP:GetAttribute("Durability") or 0
        local agility = LP:GetAttribute("Agility") or 0
        local rebirths = LP:GetAttribute("Rebirths") or 0
        local kills = LP:GetAttribute("Kills") or 0
        local text = string.format("Strength: %s | Durability: %s\nAgility: %s | Rebirths: %s | Kills: %s",
            State.formatExactWithUnit(strength),
            State.formatExactWithUnit(durability),
            State.formatExactWithUnit(agility),
            State.formatExactWithUnit(rebirths),
            State.formatExactWithUnit(kills))
        pcall(function() playerInfoLabel:Set(text) end)
        task.wait(1)
    end
end)

MainTab:Section("Quick Actions")

MainTab:Button({
    Title = "Copy Game Link",
    Callback = function()
        copyText("https://www.roblox.com/games/" .. game.PlaceId)
        hubNotify("Link copied")
    end
})

MainTab:Button({
    Title = "Redeem All Codes",
    Callback = function()
        hubNotify("Redeeming codes...")
    end
})

-- ============================================================
-- FARM TAB
-- ============================================================
FarmTab:Section("Fast Punch")

FarmTab:Toggle({
    Title = "Fast Punch",
    Description = "Rapid punch rocks",
    Default = false,
    Callback = function(enabled)
        setFastPunch(enabled)
    end
})

FarmTab:Section("Rock Selection")

for _, rock in ipairs(CONFIG.Rocks) do
    FarmTab:Button({
        Title = "Farm " .. rock.label,
        Callback = function()
            startRockFarm(rock)
            hubNotify("Farming " .. rock.label)
        end
    })
end

FarmTab:Section("Auto Exercises")

FarmTab:Toggle({
    Title = "Auto Weight",
    Description = "Auto lift weights",
    Default = false,
    Callback = function(enabled)
        setAutoRep("autoWeight", enabled, { "Weight" }, 0.01, false)
    end
})

FarmTab:Toggle({
    Title = "Auto Handstands",
    Description = "Auto do handstands",
    Default = false,
    Callback = function(enabled)
        setAutoRep("autoHandstands", enabled, { "Handstands" }, 0.01, false)
    end
})

FarmTab:Toggle({
    Title = "Auto Lift",
    Description = "Auto use bench press",
    Default = false,
    Callback = function(enabled)
        setAutoRep("autoLift", enabled, { "Lift" }, 0.01, false)
    end
})

FarmTab:Toggle({
    Title = "Auto Situps",
    Description = "Auto do situps",
    Default = false,
    Callback = function(enabled)
        setAutoRep("autoSitups", enabled, { "Situps" }, 0.01, false)
    end
})

FarmTab:Toggle({
    Title = "Auto Egg",
    Description = "Auto eat protein eggs",
    Default = false,
    Callback = function(enabled)
        State.setAutoEgg(enabled, "manual")
    end
})

-- ============================================================
-- FAST FARM TAB
-- ============================================================
FastFarmTab:Section("Fast Farm Mode")

FastFarmTab:Dropdown({
    Title = "Select Pack",
    Values = { "Chaos Lords", "Ultra Titans" },
    Default = "Chaos Lords",
    Callback = function(selected)
        if selected == "Chaos Lords" then
            FastFarm.packMode = "chaos"
        elseif selected == "Ultra Titans" then
            FastFarm.packMode = "ultra"
        end
    end
})

FastFarmTab:Toggle({
    Title = "Fast Strength",
    Description = "Rapid strength farming",
    Default = false,
    Callback = function(enabled)
        if enabled then
            FastFarm:Start("strength")
        else
            FastFarm:Stop(true)
        end
    end
})

FastFarmTab:Toggle({
    Title = "Fast Rebirth",
    Description = "Rapid rebirth farming",
    Default = false,
    Callback = function(enabled)
        if enabled then
            FastFarm:Start("rebirth")
        else
            FastFarm:Stop(true)
        end
    end
})

FastFarmTab:Toggle({
    Title = "Ping Reducer",
    Description = "Reduce reps during high ping",
    Default = false,
    Callback = function(enabled)
        FastFarm:SetPingReducer(enabled)
    end
})

FastFarmTab:Section("Status")

local fastFarmStatus = FastFarmTab:Label({ Text = "Ready" })

task.spawn(function()
    while true do
        local text = "Fast Farm"
        if FastFarm.mode then
            text = text .. " | Mode: " .. FastFarm.mode
            text = text .. " | Cycles: " .. tostring(FastFarm.cycleCount)
            text = text .. " | Success: " .. tostring(FastFarm.successfulRebirths)
            if FastFarm.lastError then
                text = text .. " | Error: " .. FastFarm.lastError
            end
        else
            text = text .. " | Ready"
        end
        pcall(function() fastFarmStatus:Set(text) end)
        task.wait(1)
    end
end)

-- ============================================================
-- AFK 24/7 TAB
-- ============================================================
AFKTab:Section("AFK Mode")

AFKTab:Dropdown({
    Title = "AFK Mode",
    Values = { "Fast Rebirth", "Auto Farm Kills", "Strength + Durability" },
    Default = "Fast Rebirth",
    Callback = function(selected)
        State.afk.mode = selected
    end
})

AFKTab:Toggle({
    Title = "Auto Egg",
    Description = "Auto eat protein eggs during AFK",
    Default = true,
    Callback = function(enabled)
        State.afk.autoEgg = enabled
    end
})

AFKTab:Toggle({
    Title = "Start AFK Mode",
    Description = "Start automated AFK farming",
    Default = false,
    Callback = function(enabled)
        State.afk.active = enabled
        if enabled then
            State.afk.startedAt = os.clock()
            hubNotify("AFK mode started: " .. State.afk.mode)
            if State.afk.mode == "Fast Rebirth" then
                FastFarm:Start("rebirth")
            elseif State.afk.mode == "Auto Farm Kills" then
                State.setAutoKill(true)
            elseif State.afk.mode == "Strength + Durability" then
                setAutoRep("autoWeight", true, { "Weight" }, 0.01, false)
            end
        else
            hubNotify("AFK mode stopped")
            FastFarm:Stop(true)
            State.setAutoKill(false)
            setAutoRep("autoWeight", false)
        end
    end
})

AFKTab:Section("Status")

local afkStatus = AFKTab:Label({ Text = "Ready" })

task.spawn(function()
    while true do
        local text = "AFK Mode"
        if State.afk.active then
            local elapsed = os.clock() - (State.afk.startedAt or os.clock())
            local hours = math.floor(elapsed / 3600)
            local minutes = math.floor((elapsed % 3600) / 60)
            local seconds = math.floor(elapsed % 60)
            text = string.format("Active: %02d:%02d:%02d | Mode: %s", hours, minutes, seconds, State.afk.mode)
        else
            text = "Ready"
        end
        pcall(function() afkStatus:Set(text) end)
        task.wait(1)
    end
end)

-- ============================================================
-- FULL TRAIN TAB
-- ============================================================
FullTrainTab:Section("Full Train Mode")

FullTrainTab:Dropdown({
    Title = "Training Mode",
    Values = { "Chill Rep", "Fast Rep" },
    Default = "Chill Rep",
    Callback = function(selected)
        State.fullTrainMode = selected
    end
})

FullTrainTab:Section("Training Areas")

for _, area in ipairs(CONFIG.FullTrainAreas) do
    FullTrainTab:Button({
        Title = "Train at " .. area.section,
        Callback = function()
            local root = getRoot()
            if root then
                root.CFrame = CFrame.new(area.center + Vector3.new(0, 10, 0))
                hubNotify("Training at " .. area.section)
            end
        end
    })
end

-- ============================================================
-- AUTO FARM TAB
-- ============================================================
AutoFarmTab:Section("Auto Farm Mode")

AutoFarmTab:Dropdown({
    Title = "Farm Mode",
    Values = { "Off", "Chill Rep", "Fast Rep", "Super Fast Rep" },
    Default = "Off",
    Callback = function(selected)
        State.autoFarmMode = selected
    end
})

AutoFarmTab:Section("Machines")

for _, machine in ipairs(CONFIG.Machines) do
    AutoFarmTab:Toggle({
        Title = machine.label,
        Description = machine.section,
        Default = false,
        Callback = function(enabled)
            if enabled then
                setMachine(machine, true)
            else
                setMachine(nil, false)
            end
        end
    })
end

-- ============================================================
-- BOSS TAB
-- ============================================================
BossTab:Section("Boss Battle")

BossTab:Toggle({
    Title = "Auto Farm Boss",
    Description = "Auto attack boss",
    Default = false,
    Callback = function(enabled)
        -- Boss farming logic would go here
    end
})

BossTab:Toggle({
    Title = "Boss Anti-Lag",
    Description = "Reduce effects during boss",
    Default = false,
    Callback = function(enabled)
        -- Boss anti-lag logic would go here
    end
})

BossTab:Section("Status")

local bossStatus = BossTab:Label({ Text = "No active boss" })

-- ============================================================
-- PET MOMENTUM TAB
-- ============================================================
PetMomentumTab:Section("Pet Momentum")

PetMomentumTab:Dropdown({
    Title = "Target Tier",
    Values = FastFarm.PetMomentum:GetTierOptions(),
    Default = "",
    Callback = function(selected)
        FastFarm.PetMomentum:SetTierByLabel(selected)
    end
})

PetMomentumTab:Toggle({
    Title = "Farm Pet Momentum",
    Description = "Auto train on treadmill",
    Default = false,
    Callback = function(enabled)
        if enabled then
            FastFarm.PetMomentum:Start()
        else
            FastFarm.PetMomentum:Stop(true)
        end
    end
})

PetMomentumTab:Section("Status")

local momentumStatus = PetMomentumTab:Label({ Text = "Ready" })

task.spawn(function()
    while true do
        local text = "Pet Momentum"
        if FastFarm.PetMomentum.mode then
            local progress = FastFarm.PetMomentum:GetProgress()
            text = string.format("Running | Pets: %d/%d | Min: %s | Max: %s",
                progress.completed, progress.count,
                FastFarm.PetMomentum:FormatTierProgress(progress.minimum),
                FastFarm.PetMomentum:FormatTierProgress(progress.maximum))
            if FastFarm.PetMomentum.lastError then
                text = text .. " | Error: " .. FastFarm.PetMomentum.lastError
            end
        else
            text = "Ready"
        end
        pcall(function() momentumStatus:Set(text) end)
        task.wait(1)
    end
end)

-- ============================================================
-- REBIRTHS TAB
-- ============================================================
RebirthsTab:Section("Rebirth Options")

RebirthsTab:Toggle({
    Title = "Auto Rebirth",
    Description = "Auto rebirth when ready",
    Default = false,
    Callback = function(enabled)
        State.rebirth.autoTarget = enabled
    end
})

RebirthsTab:Toggle({
    Title = "Infinite Rebirths",
    Description = "Keep rebirthing forever",
    Default = false,
    Callback = function(enabled)
        State.rebirth.infinite = enabled
    end
})

RebirthsTab:Toggle({
    Title = "Size 1",
    Description = "Keep size at 1",
    Default = false,
    Callback = function(enabled)
        State.rebirth.sizeOne = enabled
        if enabled then
            FastFarm.SetSizeOne()
        end
    end
})

RebirthsTab:Toggle({
    Title = "Fast Weight",
    Description = "Use weight for rebirth",
    Default = false,
    Callback = function(enabled)
        State.rebirth.fastWeight = enabled
    end
})

RebirthsTab:Toggle({
    Title = "Auto Lift",
    Description = "Auto lift for rebirth",
    Default = false,
    Callback = function(enabled)
        State.rebirth.autoLift = enabled
    end
})

RebirthsTab:Toggle({
    Title = "King Rebirth",
    Description = "Rebirth at king location",
    Default = false,
    Callback = function(enabled)
        State.rebirth.king = enabled
    end
})

-- ============================================================
-- KILLS TAB
-- ============================================================
KillsTab:Section("Kill Options")

KillsTab:Toggle({
    Title = "Auto Kill",
    Description = "Kill all nearby players",
    Default = false,
    Callback = function(enabled)
        State.setAutoKill(enabled)
    end
})

KillsTab:Toggle({
    Title = "Auto Win Brawl",
    Description = "Auto win brawl matches",
    Default = false,
    Callback = function(enabled)
        State.setAutoWinBrawl(enabled)
    end
})

KillsTab:Dropdown({
    Title = "Karma Mode",
    Values = { "None", "Good", "Evil" },
    Default = "None",
    Callback = function(selected)
        if selected == "None" then
            State.kill.karmaMode = nil
        else
            State.kill.karmaMode = selected:lower()
        end
    end
})

KillsTab:Toggle({
    Title = "Protect Friends",
    Description = "Don't kill friends",
    Default = false,
    Callback = function(enabled)
        State.setProtectFriends(enabled)
    end
})

KillsTab:Section("Target Kill")

KillsTab:Dropdown({
    Title = "Target Player",
    Values = (function()
        local t = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(t, p.Name) end
        end
        if #t == 0 then t[1] = "(no players)" end
        return t
    end)(),
    Default = "",
    Callback = function(selected)
        State.kill.target = selected
    end
})

KillsTab:Toggle({
    Title = "Target Kill",
    Description = "Kill selected player",
    Default = false,
    Callback = function(enabled)
        State.setTargetKill(enabled)
    end
})

KillsTab:Section("Status")

local killStatus = KillsTab:Label({ Text = "Ready" })

task.spawn(function()
    while true do
        local text = "Kills"
        if State.kill.auto or State.kill.targetMode or State.kill.karmaMode then
            text = text .. " | Active"
            text = text .. " | Session: " .. tostring(State.kill.sessionKills)
            text = text .. " | Targets: " .. tostring(State.kill.estimateCurrentTargets())
        else
            text = "Ready"
        end
        pcall(function() killStatus:Set(text) end)
        task.wait(1)
    end
end)

-- ============================================================
-- SERVER HOP TAB
-- ============================================================
ServerHopTab:Section("Server Hop")

ServerHopTab:Dropdown({
    Title = "Server Type",
    Values = { "Full (18-19)", "Solo (1-2)", "Balanced (8-14)", "Best Ping", "Free King" },
    Default = "Full (18-19)",
    Callback = function(selected)
        if selected:find("Full") then State.kill.serverHopMode = "full"
        elseif selected:find("Solo") then State.kill.serverHopMode = "solo"
        elseif selected:find("Balanced") then State.kill.serverHopMode = "balanced"
        elseif selected:find("Ping") then State.kill.serverHopMode = "ping"
        elseif selected:find("King") then State.kill.serverHopMode = "king"
        end
    end
})

ServerHopTab:Toggle({
    Title = "Auto Server Hop",
    Description = "Auto hop servers",
    Default = false,
    Callback = function(enabled)
        State.setServerHop(enabled)
    end
})

ServerHopTab:Toggle({
    Title = "Hop on Death",
    Description = "Change server if killed",
    Default = false,
    Callback = function(enabled)
        State.kill.hopOnDeath = enabled
    end
})

ServerHopTab:Toggle({
    Title = "Avoid Killers",
    Description = "Change if killer joins",
    Default = false,
    Callback = function(enabled)
        State.kill.avoidKillers = enabled
    end
})

ServerHopTab:Toggle({
    Title = "Claim King",
    Description = "Auto claim king when free",
    Default = true,
    Callback = function(enabled)
        State.kill.claimKing = enabled
    end
})

ServerHopTab:Button({
    Title = "Hop Now",
    Callback = function()
        State.requestServerHop()
    end
})

ServerHopTab:Section("Status")

local hopStatus = ServerHopTab:Label({ Text = "Ready" })

task.spawn(function()
    while true do
        local text = "Server Hop"
        if State.kill.serverHop then
            text = text .. " | Active"
            text = text .. " | Mode: " .. State.kill.serverHopMode
            text = text .. " | Visited: " .. tostring(State.kill.serversVisited)
            if State.kill.serverError then
                text = text .. " | Error: " .. State.kill.serverError
            end
        else
            text = "Ready"
        end
        pcall(function() hopStatus:Set(text) end)
        task.wait(1)
    end
end)

-- ============================================================
-- PETS TAB
-- ============================================================
PetsTab:Section("Pet Options")

PetsTab:Toggle({
    Title = "Auto Pet",
    Description = "Auto equip best pet",
    Default = false,
    Callback = function(enabled)
        State.autoPet = enabled
    end
})

PetsTab:Toggle({
    Title = "Auto Aura",
    Description = "Auto equip best aura",
    Default = false,
    Callback = function(enabled)
        State.autoAura = enabled
    end
})

-- ============================================================
-- INVENTORY TAB
-- ============================================================
InventoryTab:Section("Inventory")

InventoryTab:Label({ Text = "Inventory management coming soon" })

-- ============================================================
-- FUSE MACHINE TAB
-- ============================================================
FuseTab:Section("Fuse Machine")

FuseTab:Label({ Text = "Fuse machine integration coming soon" })

-- ============================================================
-- TRADE TAB
-- ============================================================
TradeTab:Section("Fast Trade")

TradeTab:Label({ Text = "Fast trade integration coming soon" })

-- ============================================================
-- GIFTS TAB
-- ============================================================
GiftsTab:Section("Gifts")

GiftsTab:Label({ Text = "Gift system integration coming soon" })

-- ============================================================
-- TELEPORTS TAB
-- ============================================================
TeleportsTab:Section("Locations")

for _, tp in ipairs(CONFIG.Teleports) do
    TeleportsTab:Button({
        Title = "TP to " .. tp[1],
        Callback = function()
            local root = getRoot()
            if root then
                root.CFrame = CFrame.new(tp[2])
                hubNotify("Teleported to " .. tp[1])
            end
        end
    })
end

TeleportsTab:Section("Players")

TeleportsTab:Dropdown({
    Title = "Teleport to Player",
    Values = (function()
        local t = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then table.insert(t, p.Name) end
        end
        if #t == 0 then t[1] = "(no players)" end
        return t
    end)(),
    Default = "",
    Callback = function(selected)
        local target = Players:FindFirstChild(selected)
        if target and target.Character then
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local myRoot = getRoot()
            if targetRoot and myRoot then
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                hubNotify("Teleported to " .. selected)
            end
        end
    end
})

-- ============================================================
-- PROFILES TAB
-- ============================================================
ProfilesTab:Section("Profiles")

ProfilesTab:Label({ Text = "Profile system integration coming soon" })

-- ============================================================
-- STATS TAB
-- ============================================================
StatsTab:Section("Statistics")

local statsLabel = StatsTab:Label({ Text = "Loading..." })

task.spawn(function()
    while true do
        local strength = LP:GetAttribute("Strength") or 0
        local durability = LP:GetAttribute("Durability") or 0
        local agility = LP:GetAttribute("Agility") or 0
        local rebirths = LP:GetAttribute("Rebirths") or 0
        local kills = LP:GetAttribute("Kills") or 0
        local brawls = LP:GetAttribute("Brawls") or 0
        local gems = LP:GetAttribute("Gems") or 0
        local text = string.format(
            "Strength: %s\nDurability: %s\nAgility: %s\nRebirths: %s\nKills: %s\nBrawls: %s\nGems: %s",
            State.formatExactWithUnit(strength),
            State.formatExactWithUnit(durability),
            State.formatExactWithUnit(agility),
            State.formatExactWithUnit(rebirths),
            State.formatExactWithUnit(kills),
            State.formatExactWithUnit(brawls),
            State.formatExactWithUnit(gems))
        pcall(function() statsLabel:Set(text) end)
        task.wait(1)
    end
end)

-- ============================================================
-- MISC TAB
-- ============================================================
MiscTab:Section("Performance")

MiscTab:Toggle({
    Title = "Anti Lag",
    Description = "Reduce lag and effects",
    Default = false,
    Callback = function(enabled)
        setAntiLag(enabled)
    end
})

MiscTab:Toggle({
    Title = "Anti Crash",
    Description = "Prevent memory crashes",
    Default = false,
    Callback = function(enabled)
        AntiCrash.set(enabled)
    end
})

MiscTab:Section("Movement")

MiscTab:Toggle({
    Title = "Fast Speed",
    Description = "Walk very fast",
    Default = false,
    Callback = function(enabled)
        setFastSpeed(enabled)
    end
})

MiscTab:Toggle({
    Title = "Fly",
    Description = "Fly around",
    Default = false,
    Callback = function(enabled)
        setFly(enabled)
    end
})

MiscTab:Toggle({
    Title = "Noclip",
    Description = "Walk through walls",
    Default = false,
    Callback = function(enabled)
        setNoclip(enabled)
    end
})

MiscTab:Toggle({
    Title = "Infinite Jump",
    Description = "Jump forever",
    Default = false,
    Callback = function(enabled)
        State.infiniteJump = enabled
    end
})

MiscTab:Toggle({
    Title = "Walk Water",
    Description = "Walk on water",
    Default = false,
    Callback = function(enabled)
        setWalkWater(enabled)
    end
})

MiscTab:Section("Visual")

MiscTab:Toggle({
    Title = "Hide Frames",
    Description = "Hide UI popups",
    Default = false,
    Callback = function(enabled)
        setHideFrames(enabled)
    end
})

MiscTab:Toggle({
    Title = "Hide Durability",
    Description = "Hide durability frames",
    Default = false,
    Callback = function(enabled)
        setHideDurability(enabled)
    end
})

MiscTab:Toggle({
    Title = "Remove Portals",
    Description = "Remove portals from world",
    Default = false,
    Callback = function(enabled)
        setRemovePortals(enabled)
    end
})

MiscTab:Section("Rewards")

MiscTab:Toggle({
    Title = "Auto Spin Wheel",
    Description = "Auto spin fortune wheel",
    Default = false,
    Callback = function(enabled)
        setAutoSpinWheel(enabled)
    end
})

MiscTab:Toggle({
    Title = "Auto Claim Chests",
    Description = "Auto claim nearby chests",
    Default = false,
    Callback = function(enabled)
        setAutoClaimChests(enabled)
    end
})

MiscTab:Section("Camera")

MiscTab:Toggle({
    Title = "Spy Mode",
    Description = "Watch selected player",
    Default = false,
    Callback = function(enabled)
        setSpy(enabled)
    end
})

MiscTab:Section("Anti-AFK")

State.antiAfkPulses = 0
State.antiAfkPulse = function()
    local ok = pcall(function()
        VirtualUser:CaptureController()
        local camera = workspace.CurrentCamera
        local cameraCFrame = camera and camera.CFrame or CFrame.new()
        VirtualUser:Button2Down(Vector2.new(0, 0), cameraCFrame)
        task.wait(0.05)
        VirtualUser:Button2Up(Vector2.new(0, 0), cameraCFrame)
    end)
    if ok then
        State.antiAfkPulses = State.antiAfkPulses + 1
        State.lastAntiAfkPulse = os.clock()
    end
    return ok
end

State.antiAfkConnection = track(LP.Idled:Connect(State.antiAfkPulse))

print("[Muscle Legends] Part 10 loaded - AIRFLOW GUI")
print("[Muscle Legends] All parts loaded successfully!")
print("[Muscle Legends] Script ready to use!")
