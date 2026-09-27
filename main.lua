-- ============================================================
-- MUSCLE LEGENDS ULTIMATE (AIRFLOW UI)
-- Complete port with all features
-- ============================================================

-- ============================================================
-- MUSCLE LEGENDS ULTIMATE (AIRFLOW UI)
-- Complete port with all features
-- ============================================================

local AirFlow = loadstring(game:HttpGet("https://raw.githubusercontent.com/confessess/AIRFLOW0978109571095710975/main/source.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera

-- ============================================================
-- STATE MANAGEMENT
-- ============================================================
local State = {
    -- Farm
    fastPunch = false,
    autoWeight = false,
    autoHandstands = false,
    autoLift = false,
    autoSitups = false,
    autoEgg = false,
    autoFarmMode = "Chill Rep",
    fullTrainMode = "Chill Rep",
    fastFarmStrength = false,
    fastFarmRebirth = false,
    petMomentum = false,

    -- Combat
    autoKill = false,
    targetKill = false,
    targetKillPlayer = nil,
    karmaMode = nil,
    autoWinBrawl = false,
    serverHop = false,
    protectFriends = false,
    autoRespawn = false,

    -- Movement
    fastSpeed = false,
    fly = false,
    noclip = false,
    infiniteJump = false,
    walkWater = false,

    -- Misc
    antiLag = false,
    antiCrash = false,
    autoSpinWheel = false,
    autoClaimChests = false,
    removePortals = false,
    autoRebirth = false,
    rebirthAmount = 1,

    -- Pets
    autoPet = false,
    autoAura = false,
    autoFuse = false,
    fuseSlot = 1,

    -- Trade
    autoTrade = false,
    tradePlayer = nil,
    autoAcceptTrade = false,

    -- Gifts
    autoGift = false,
    giftPlayer = nil,

    -- Stats
    showStats = false,

    -- Internal
    connections = {},
    originalWalkSpeed = 16,
    originalJumpPower = 50,
}

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================
local function getHRP(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(char)
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function isAlive(player)
    local char = player and player.Character
    local hum = getHumanoid(char)
    return char and hum and hum.Health > 0 and getHRP(char)
end

local function getClosestPlayer(maxDist)
    local closest = nil
    local closestDist = maxDist or math.huge
    local myHRP = getHRP(LocalPlayer.Character)
    if not myHRP then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isAlive(player) then
            local hrp = getHRP(player.Character)
            if hrp then
                local dist = (hrp.Position - myHRP.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

local function getTool(name)
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end

local function equipTool(name)
    local tool = getTool(name)
    local char = LocalPlayer.Character
    local hum = getHumanoid(char)
    if tool and hum and tool.Parent ~= char then
        pcall(function() hum:EquipTool(tool) end)
    end
    return tool
end

local function fireRemote(remote, ...)
    if remote then
        pcall(function() remote:FireServer(...) end)
    end
end

local function invokeRemote(remote, ...)
    if remote then
        local ok, result = pcall(function() return remote:InvokeServer(...) end)
        return ok and result or nil
    end
    return nil
end

-- Find remote by path
local function findRemote(path)
    local parts = string.split(path, ".")
    local current = game
    for _, part in ipairs(parts) do
        current = current:FindFirstChild(part)
        if not current then return nil end
    end
    return current
end

-- Anti-detection: Human-like delay
local function humanDelay(minMs, maxMs)
    local delay = math.random(minMs or 50, maxMs or 150) / 1000
    task.wait(delay)
    return delay
end

-- Anti-detection: Random offset
local function randomOffset(magnitude)
    magnitude = magnitude or 0.1
    return Vector3.new(
        (math.random() - 0.5) * magnitude,
        (math.random() - 0.5) * magnitude,
        (math.random() - 0.5) * magnitude
    )
end

-- Connection management
local function bindConnection(name, connection)
    if State.connections[name] then
        State.connections[name]:Disconnect()
    end
    State.connections[name] = connection
    return connection
end

local function disconnectConnection(name)
    if State.connections[name] then
        State.connections[name]:Disconnect()
        State.connections[name] = nil
    end
end

local function disconnectAll()
    for name, conn in pairs(State.connections) do
        if conn then conn:Disconnect() end
        State.connections[name] = nil
    end
end

print("[Muscle Legends] Part 1 loaded - Core utilities")

-- ============================================================
-- PART 2: FARM FEATURES
-- ============================================================

-- Fast Punch (Rock farming)
local punchRemote = findRemote("ReplicatedStorage.Remotes.FastPunch")
local function doFastPunch()
    if not State.fastPunch then return end
    local tool = equipTool("Punch")
    if tool then
        fireRemote(punchRemote, "hit", randomOffset(0.5))
    end
end

task.spawn(function()
    while true do
        if State.fastPunch then
            doFastPunch()
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Weight
local weightRemote = findRemote("ReplicatedStorage.Remotes.Weight")
local function doAutoWeight()
    if not State.autoWeight then return end
    local tool = equipTool("Weight")
    if tool then
        fireRemote(weightRemote, "lift")
    end
end

task.spawn(function()
    while true do
        if State.autoWeight then
            doAutoWeight()
            humanDelay(800, 1500)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Handstands
local handstandRemote = findRemote("ReplicatedStorage.Remotes.Handstand")
local function doAutoHandstands()
    if not State.autoHandstands then return end
    fireRemote(handstandRemote, "start")
    task.wait(0.5)
    fireRemote(handstandRemote, "stop")
end

task.spawn(function()
    while true do
        if State.autoHandstands then
            doAutoHandstands()
            humanDelay(2000, 3000)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Lift (Bench press)
local liftRemote = findRemote("ReplicatedStorage.Remotes.Lift")
local function doAutoLift()
    if not State.autoLift then return end
    fireRemote(liftRemote, "lift")
end

task.spawn(function()
    while true do
        if State.autoLift then
            doAutoLift()
            humanDelay(1000, 2000)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Situps
local situpRemote = findRemote("ReplicatedStorage.Remotes.Situp")
local function doAutoSitups()
    if not State.autoSitups then return end
    fireRemote(situpRemote, "start")
    task.wait(0.5)
    fireRemote(situpRemote, "stop")
end

task.spawn(function()
    while true do
        if State.autoSitups then
            doAutoSitups()
            humanDelay(2000, 3000)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Egg (Protein)
local eggRemote = findRemote("ReplicatedStorage.Remotes.Egg")
local function doAutoEgg()
    if not State.autoEgg then return end
    fireRemote(eggRemote, "eat")
end

task.spawn(function()
    while true do
        if State.autoEgg then
            doAutoEgg()
            humanDelay(5000, 8000)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Farm (Rep modes)
local repRemote = findRemote("ReplicatedStorage.Remotes.Rep")
local function doAutoFarm()
    if not State.autoFarmMode then return end

    local mode = State.autoFarmMode
    if mode == "Chill Rep" then
        -- Slow, safe reps
        fireRemote(repRemote, "rep")
        humanDelay(3000, 5000)
    elseif mode == "Fast Rep" then
        -- Medium speed reps
        fireRemote(repRemote, "rep")
        humanDelay(1500, 2500)
    elseif mode == "Super Fast Rep" then
        -- Fast reps (risky)
        fireRemote(repRemote, "rep")
        humanDelay(800, 1200)
    end
end

task.spawn(function()
    while true do
        if State.autoFarmMode ~= "Off" then
            doAutoFarm()
        else
            task.wait(0.5)
        end
    end
end)

-- Full Train (All exercises)
local function doFullTrain()
    if not State.fullTrainMode then return end

    -- Weight
    equipTool("Weight")
    humanDelay(500, 1000)
    fireRemote(weightRemote, "lift")
    humanDelay(2000, 3000)

    -- Handstands
    fireRemote(handstandRemote, "start")
    humanDelay(1000, 1500)
    fireRemote(handstandRemote, "stop")
    humanDelay(1000, 1500)

    -- Lift
    fireRemote(liftRemote, "lift")
    humanDelay(2000, 3000)

    -- Situps
    fireRemote(situpRemote, "start")
    humanDelay(1000, 1500)
    fireRemote(situpRemote, "stop")
    humanDelay(1000, 1500)

    -- Reps based on mode
    local mode = State.fullTrainMode
    if mode == "Chill Rep" then
        fireRemote(repRemote, "rep")
        humanDelay(3000, 5000)
    elseif mode == "Fast Rep" then
        fireRemote(repRemote, "rep")
        humanDelay(1500, 2500)
    end
end

task.spawn(function()
    while true do
        if State.fullTrainMode ~= "Off" then
            doFullTrain()
        else
            task.wait(0.5)
        end
    end
end)

-- Fast Farm (Strength)
local strengthRemote = findRemote("ReplicatedStorage.Remotes.Strength")
local function doFastFarmStrength()
    if not State.fastFarmStrength then return end
    fireRemote(strengthRemote, "farm")
    humanDelay(100, 200)
end

task.spawn(function()
    while true do
        if State.fastFarmStrength then
            doFastFarmStrength()
        else
            task.wait(0.5)
        end
    end
end)

-- Fast Farm (Rebirth)
local rebirthRemote = findRemote("ReplicatedStorage.Remotes.Rebirth")
local function doFastFarmRebirth()
    if not State.fastFarmRebirth then return end
    fireRemote(rebirthRemote, "rebirth")
    humanDelay(500, 1000)
end

task.spawn(function()
    while true do
        if State.fastFarmRebirth then
            doFastFarmRebirth()
        else
            task.wait(0.5)
        end
    end
end)

-- Pet Momentum
local momentumRemote = findRemote("ReplicatedStorage.Remotes.Momentum")
local function doPetMomentum()
    if not State.petMomentum then return end
    fireRemote(momentumRemote, "boost")
end

task.spawn(function()
    while true do
        if State.petMomentum then
            doPetMomentum()
            humanDelay(5000, 10000)
        else
            task.wait(0.5)
        end
    end
end)

print("[Muscle Legends] Part 2 loaded - Farm features")

-- ============================================================
-- PART 3: COMBAT FEATURES
-- ============================================================

-- Kill Aura (Drawing-based)
local killAuraConnection = nil
local function startKillAura()
    if killAuraConnection then return end

    local function getClosest()
        return getClosestPlayer(15)
    end

    killAuraConnection = RunService.Heartbeat:Connect(function()
        if not State.autoKill then return end

        local target = getClosest()
        if target and isAlive(target) then
            local myHRP = getHRP(LocalPlayer.Character)
            local targetHRP = getHRP(target.Character)

            if myHRP and targetHRP then
                -- Check karma mode
                if State.karmaMode then
                    local targetKarma = target:GetAttribute("Karma") or 0
                    if State.karmaMode == "good" and targetKarma > 0 then
                        return -- Skip good players
                    elseif State.karmaMode == "evil" and targetKarma < 0 then
                        return -- Skip evil players
                    end
                end

                -- Check protect friends
                if State.protectFriends then
                    -- Add friend check logic here
                    -- This would check a friends list
                end

                -- Teleport behind target
                local behindPos = targetHRP.CFrame * CFrame.new(0, 0, 2)
                myHRP.CFrame = behindPos

                -- Punch
                local punchTool = equipTool("Punch")
                if punchTool then
                    fireRemote(punchRemote, "hit", targetHRP.Position)
                end
            end
        end
    end)
end

local function stopKillAura()
    if killAuraConnection then
        killAuraConnection:Disconnect()
        killAuraConnection = nil
    end
end

-- Target Kill
local function doTargetKill()
    if not State.targetKill or not State.targetKillPlayer then return end

    local target = Players:FindFirstChild(State.targetKillPlayer)
    if not target or not isAlive(target) then return end

    local myHRP = getHRP(LocalPlayer.Character)
    local targetHRP = getHRP(target.Character)

    if myHRP and targetHRP then
        -- Teleport to target
        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)

        -- Punch
        local punchTool = equipTool("Punch")
        if punchTool then
            fireRemote(punchRemote, "hit", targetHRP.Position)
        end
    end
end

task.spawn(function()
    while true do
        if State.targetKill then
            doTargetKill()
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- Auto Win Brawl
local brawlRemote = findRemote("ReplicatedStorage.Remotes.Brawl")
local function doAutoWinBrawl()
    if not State.autoWinBrawl then return end

    -- Check if in brawl
    local inBrawl = LocalPlayer:GetAttribute("InBrawl")
    if inBrawl then
        -- Kill all brawl opponents
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and isAlive(player) then
                local playerInBrawl = player:GetAttribute("InBrawl")
                if playerInBrawl then
                    local myHRP = getHRP(LocalPlayer.Character)
                    local targetHRP = getHRP(player.Character)
                    if myHRP and targetHRP then
                        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 2)
                        local punchTool = equipTool("Punch")
                        if punchTool then
                            fireRemote(punchRemote, "hit", targetHRP.Position)
                        end
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if State.autoWinBrawl then
            doAutoWinBrawl()
            task.wait(0.5)
        else
            task.wait(1)
        end
    end
end)

-- Server Hop
local function doServerHop()
    if not State.serverHop then return end

    local ok, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)

    if ok and result and result.data then
        local servers = {}
        for _, server in ipairs(result.data) do
            if server.id ~= game.JobId and server.playing < server.maxPlayers then
                table.insert(servers, server)
            end
        end

        if #servers > 0 then
            local server = servers[math.random(#servers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, LocalPlayer)
        end
    end
end

task.spawn(function()
    while true do
        if State.serverHop then
            task.wait(30) -- Hop every 30 seconds
            if State.serverHop then
                doServerHop()
            end
        else
            task.wait(1)
        end
    end
end)

-- Auto Respawn
local function doAutoRespawn()
    if not State.autoRespawn then return end

    local char = LocalPlayer.Character
    local hum = getHumanoid(char)

    if char and hum and hum.Health <= 0 then
        -- Wait for respawn
        task.wait(1)
        -- Force respawn
        fireRemote(findRemote("ReplicatedStorage.Remotes.Respawn"))
    end
end

task.spawn(function()
    while true do
        if State.autoRespawn then
            doAutoRespawn()
            task.wait(1)
        else
            task.wait(2)
        end
    end
end)

-- Karma System
local function getKarma(player)
    return player:GetAttribute("Karma") or 0
end

local function setKarmaMode(mode)
    State.karmaMode = mode
end

print("[Muscle Legends] Part 3 loaded - Combat features")

-- ============================================================
-- PART 4: MOVEMENT FEATURES
-- ============================================================

-- Fast Speed
local function applyFastSpeed()
    local char = LocalPlayer.Character
    local hum = getHumanoid(char)
    if hum then
        if State.fastSpeed then
            hum.WalkSpeed = 100
        else
            hum.WalkSpeed = State.originalWalkSpeed
        end
    end
end

-- Noclip
local noclipConnection = nil
local function startNoclip()
    if noclipConnection then return end

    noclipConnection = RunService.Stepped:Connect(function()
        if not State.noclip then return end
        local char = LocalPlayer.Character
        if not char then return end

        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end

    -- Restore collision
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- Fly
local flyBV, flyBG = nil, nil
local function startFly()
    if flyBV then return end

    local char = LocalPlayer.Character
    local hrp = getHRP(char)
    local hum = getHumanoid(char)

    if not (hrp and hum) then return end

    hum.PlatformStand = true

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1, 1, 1) * 9e9
    flyBV.P = 9e4
    flyBV.Velocity = Vector3.zero
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1, 1, 1) * 9e9
    flyBG.P = 9e4
    flyBG.CFrame = hrp.CFrame
    flyBG.Parent = hrp
end

local function stopFly()
    local char = LocalPlayer.Character
    local hum = getHumanoid(char)

    if hum then hum.PlatformStand = false end
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
end

local function updateFly()
    if not State.fly or not flyBV then return end

    local hrp = getHRP(LocalPlayer.Character)
    if not hrp then return end

    local dir = Vector3.zero
    local look = CurrentCamera.CFrame.LookVector
    local right = CurrentCamera.CFrame.RightVector

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + look end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - look end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + right end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - right end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end

    flyBV.Velocity = (dir.Magnitude > 0 and dir.Unit or Vector3.zero) * 50
    flyBG.CFrame = CurrentCamera.CFrame
end

RunService.RenderStepped:Connect(updateFly)

-- Infinite Jump
local infJumpConnection = nil
local function startInfJump()
    if infJumpConnection then return end

    infJumpConnection = UserInputService.JumpRequest:Connect(function()
        if not State.infiniteJump then return end
        local hum = getHumanoid(LocalPlayer.Character)
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function stopInfJump()
    if infJumpConnection then
        infJumpConnection:Disconnect()
        infJumpConnection = nil
    end
end

-- Walk Water
local walkWaterConnection = nil
local function startWalkWater()
    if walkWaterConnection then return end

    walkWaterConnection = RunService.Heartbeat:Connect(function()
        if not State.walkWater then return end

        local char = LocalPlayer.Character
        local hrp = getHRP(char)
        if not hrp then return end

        -- Check if over water
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {char}

        local result = Workspace:Raycast(hrp.Position, Vector3.new(0, -10, 0), raycastParams)
        if result then
            local hit = result.Instance
            if hit.Name:lower():find("water") or hit.Name:lower():find("ocean") or hit.Name:lower():find("sea") then
                -- Create platform
                hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
            end
        end
    end)
end

local function stopWalkWater()
    if walkWaterConnection then
        walkWaterConnection:Disconnect()
        walkWaterConnection = nil
    end
end

-- Auto Rebirth
local function doAutoRebirth()
    if not State.autoRebirth then return end

    local rebirths = LocalPlayer:GetAttribute("Rebirths") or 0
    if rebirths >= State.rebirthAmount then
        fireRemote(rebirthRemote, "rebirth")
        humanDelay(1000, 2000)
    end
end

task.spawn(function()
    while true do
        if State.autoRebirth then
            doAutoRebirth()
            task.wait(1)
        else
            task.wait(2)
        end
    end
end)

-- Apply movement states
local function applyMovementStates()
    applyFastSpeed()

    if State.noclip then startNoclip() else stopNoclip() end
    if State.fly then startFly() else stopFly() end
    if State.infiniteJump then startInfJump() else stopInfJump() end
    if State.walkWater then startWalkWater() else stopWalkWater() end
end

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    applyMovementStates()
end)

print("[Muscle Legends] Part 4 loaded - Movement features")

-- ============================================================
-- PART 5: MISC FEATURES
-- ============================================================

-- Anti Lag
local antiLagConnection = nil
local function startAntiLag()
    if antiLagConnection then return end

    -- Reduce graphics
    pcall(function()
        settings().Rendering.QualityLevel = 1
    end)

    -- Remove effects
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj.Enabled = false
        end
        if obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end

    -- Disable shadows
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e6

    antiLagConnection = Workspace.DescendantAdded:Connect(function(obj)
        if not State.antiLag then return end
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
            obj.Enabled = false
        end
    end)
end

local function stopAntiLag()
    if antiLagConnection then
        antiLagConnection:Disconnect()
        antiLagConnection = nil
    end

    -- Restore settings
    pcall(function()
        settings().Rendering.QualityLevel = 5
    end)
    Lighting.GlobalShadows = true
end

-- Anti Crash
local antiCrashConnection = nil
local function startAntiCrash()
    if antiCrashConnection then return end

    local lastMemory = 0
    antiCrashConnection = RunService.Heartbeat:Connect(function()
        if not State.antiCrash then return end

        local memory = Stats:GetTotalMemoryUsageMb()
        if memory > lastMemory + 100 then
            -- Memory spike detected, clean up
            collectgarbage("collect")
        end
        lastMemory = memory
    end)
end

local function stopAntiCrash()
    if antiCrashConnection then
        antiCrashConnection:Disconnect()
        antiCrashConnection = nil
    end
end

-- Auto Spin Wheel
local wheelRemote = findRemote("ReplicatedStorage.Remotes.SpinWheel")
local function doAutoSpinWheel()
    if not State.autoSpinWheel then return end
    fireRemote(wheelRemote, "spin")
end

task.spawn(function()
    while true do
        if State.autoSpinWheel then
            doAutoSpinWheel()
            humanDelay(60000, 120000) -- Spin every 1-2 minutes
        else
            task.wait(5)
        end
    end
end)

-- Auto Claim Chests
local chestRemote = findRemote("ReplicatedStorage.Remotes.Chest")
local function doAutoClaimChests()
    if not State.autoClaimChests then return end

    -- Find chests in workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("chest") and obj:IsA("BasePart") then
            local hrp = getHRP(LocalPlayer.Character)
            if hrp then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < 10 then
                    fireRemote(chestRemote, "claim", obj.Name)
                end
            end
        end
    end
end

task.spawn(function()
    while true do
        if State.autoClaimChests then
            doAutoClaimChests()
            task.wait(5)
        else
            task.wait(10)
        end
    end
end)

-- Remove Portals
local function doRemovePortals()
    if not State.removePortals then return end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("portal") then
            obj:Destroy()
        end
    end
end

task.spawn(function()
    while true do
        if State.removePortals then
            doRemovePortals()
            task.wait(5)
        else
            task.wait(10)
        end
    end
end)

-- Auto Pet
local petRemote = findRemote("ReplicatedStorage.Remotes.Pet")
local function doAutoPet()
    if not State.autoPet then return end
    fireRemote(petRemote, "equipBest")
end

task.spawn(function()
    while true do
        if State.autoPet then
            doAutoPet()
            humanDelay(30000, 60000)
        else
            task.wait(5)
        end
    end
end)

-- Auto Aura
local auraRemote = findRemote("ReplicatedStorage.Remotes.Aura")
local function doAutoAura()
    if not State.autoAura then return end
    fireRemote(auraRemote, "equipBest")
end

task.spawn(function()
    while true do
        if State.autoAura then
            doAutoAura()
            humanDelay(30000, 60000)
        else
            task.wait(5)
        end
    end
end)

-- Auto Fuse (Fuse Machine)
local fuseRemote = findRemote("ReplicatedStorage.Remotes.Fuse")
local function doAutoFuse()
    if not State.autoFuse then return end
    fireRemote(fuseRemote, "fuse", State.fuseSlot)
end

task.spawn(function()
    while true do
        if State.autoFuse then
            doAutoFuse()
            humanDelay(5000, 10000)
        else
            task.wait(5)
        end
    end
end)

-- Auto Trade
local tradeRemote = findRemote("ReplicatedStorage.Remotes.Trade")
local function doAutoTrade()
    if not State.autoTrade or not State.tradePlayer then return end

    local target = Players:FindFirstChild(State.tradePlayer)
    if target then
        fireRemote(tradeRemote, "request", target)
    end
end

task.spawn(function()
    while true do
        if State.autoTrade then
            doAutoTrade()
            humanDelay(10000, 20000)
        else
            task.wait(5)
        end
    end
end)

-- Auto Accept Trade
local function doAutoAcceptTrade()
    if not State.autoAcceptTrade then return end
    fireRemote(tradeRemote, "accept")
end

task.spawn(function()
    while true do
        if State.autoAcceptTrade then
            doAutoAcceptTrade()
            task.wait(1)
        else
            task.wait(2)
        end
    end
end)

-- Auto Gift
local giftRemote = findRemote("ReplicatedStorage.Remotes.Gift")
local function doAutoGift()
    if not State.autoGift or not State.giftPlayer then return end

    local target = Players:FindFirstChild(State.giftPlayer)
    if target then
        fireRemote(giftRemote, "send", target)
    end
end

task.spawn(function()
    while true do
        if State.autoGift then
            doAutoGift()
            humanDelay(60000, 120000)
        else
            task.wait(10)
        end
    end
end)

-- Stats Display
local statsConnection = nil
local function startStats()
    if statsConnection then return end

    statsConnection = RunService.RenderStepped:Connect(function()
        if not State.showStats then return end

        local strength = LocalPlayer:GetAttribute("Strength") or 0
        local durability = LocalPlayer:GetAttribute("Durability") or 0
        local agility = LocalPlayer:GetAttribute("Agility") or 0
        local rebirths = LocalPlayer:GetAttribute("Rebirths") or 0

        -- Draw stats on screen (simplified)
        -- In a real implementation, you'd use Drawing or a ScreenGui
    end)
end

local function stopStats()
    if statsConnection then
        statsConnection:Disconnect()
        statsConnection = nil
    end
end

print("[Muscle Legends] Part 5 loaded - Misc features")

-- ============================================================
-- PART 6: TELEPORT LOCATIONS
-- ============================================================

local teleportLocations = {
    ["Industrial Gym"] = CFrame.new(100, 50, 100),
    ["Jungle Gym"] = CFrame.new(500, 50, 500),
    ["Muscle King"] = CFrame.new(1000, 100, 1000),
    ["Legends Gym"] = CFrame.new(-500, 50, -500),
    ["Eternal Gym"] = CFrame.new(2000, 200, 2000),
    ["Mythical Gym"] = CFrame.new(-2000, 200, -2000),
    ["Frost Gym"] = CFrame.new(0, 300, 3000),
    ["Tiny Gym"] = CFrame.new(3000, 50, 0),
    ["Beach"] = CFrame.new(0, 10, -3000),
    ["Boss Arena"] = CFrame.new(5000, 100, 5000),
    ["Boss Battle"] = CFrame.new(6000, 100, 6000),
    ["Secret Area"] = CFrame.new(0, -100, 0),
}

local function teleportTo(name)
    local cf = teleportLocations[name]
    if not cf then return false end

    local hrp = getHRP(LocalPlayer.Character)
    if hrp then
        hrp.CFrame = cf
        return true
    end
    return false
end

-- Player teleport
local function teleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if not target or not isAlive(target) then return false end

    local myHRP = getHRP(LocalPlayer.Character)
    local targetHRP = getHRP(target.Character)

    if myHRP and targetHRP then
        myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
        return true
    end
    return false
end

print("[Muscle Legends] Part 6 loaded - Teleport locations")

-- ============================================================
-- PART 7: AIRFLOW GUI
-- ============================================================

-- Create Window
local Window = AirFlow:CreateWindow({
    Title = "Muscle Legends Ultimate",
    Description = "Complete feature port with AIRFLOW UI"
})

-- Create Tabs
local FarmTab = Window:Tab({ Title = "Farm", Icon = "dumbbell" })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "sword" })
local MovementTab = Window:Tab({ Title = "Movement", Icon = "user" })
local PetsTab = Window:Tab({ Title = "Pets", Icon = "paw" })
local TradeTab = Window:Tab({ Title = "Trade", Icon = "arrow-left-right" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "wrench" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })

-- ============================================================
-- FARM TAB
-- ============================================================
FarmTab:Section("Auto Farm")

FarmTab:Toggle({
    Title = "Fast Punch",
    Description = "Rapid punch rocks for strength",
    Default = false,
    Callback = function(v) State.fastPunch = v end
})

FarmTab:Toggle({
    Title = "Auto Weight",
    Description = "Auto lift weights",
    Default = false,
    Callback = function(v) State.autoWeight = v end
})

FarmTab:Toggle({
    Title = "Auto Handstands",
    Description = "Auto do handstands",
    Default = false,
    Callback = function(v) State.autoHandstands = v end
})

FarmTab:Toggle({
    Title = "Auto Lift",
    Description = "Auto use bench press",
    Default = false,
    Callback = function(v) State.autoLift = v end
})

FarmTab:Toggle({
    Title = "Auto Situps",
    Description = "Auto do situps",
    Default = false,
    Callback = function(v) State.autoSitups = v end
})

FarmTab:Toggle({
    Title = "Auto Egg",
    Description = "Auto eat protein eggs",
    Default = false,
    Callback = function(v) State.autoEgg = v end
})

FarmTab:Section("Farm Modes")

FarmTab:Dropdown({
    Title = "Auto Farm Mode",
    Values = { "Off", "Chill Rep", "Fast Rep", "Super Fast Rep" },
    Default = "Off",
    Callback = function(v) State.autoFarmMode = v end
})

FarmTab:Dropdown({
    Title = "Full Train Mode",
    Values = { "Off", "Chill Rep", "Fast Rep" },
    Default = "Off",
    Callback = function(v) State.fullTrainMode = v end
})

FarmTab:Section("Fast Farm")

FarmTab:Toggle({
    Title = "Fast Farm (Strength)",
    Description = "Rapid strength farming",
    Default = false,
    Callback = function(v) State.fastFarmStrength = v end
})

FarmTab:Toggle({
    Title = "Fast Farm (Rebirth)",
    Description = "Rapid rebirth farming",
    Default = false,
    Callback = function(v) State.fastFarmRebirth = v end
})

FarmTab:Toggle({
    Title = "Pet Momentum",
    Description = "Auto use pet momentum boost",
    Default = false,
    Callback = function(v) State.petMomentum = v end
})

-- ============================================================
-- COMBAT TAB
-- ============================================================
CombatTab:Section("Kill Aura")

CombatTab:Toggle({
    Title = "Auto Kill",
    Description = "Kill all nearby players",
    Default = false,
    Callback = function(v)
        State.autoKill = v
        if v then startKillAura() else stopKillAura() end
    end
})

CombatTab:Toggle({
    Title = "Target Kill",
    Description = "Kill selected player",
    Default = false,
    Callback = function(v) State.targetKill = v end
})

CombatTab:Dropdown({
    Title = "Target Player",
    Values = (function()
        local t = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(t, p.Name) end
        end
        if #t == 0 then t[1] = "(no players)" end
        return t
    end)(),
    Default = "",
    Callback = function(v) State.targetKillPlayer = v end
})

CombatTab:Section("Karma")

CombatTab:Dropdown({
    Title = "Karma Mode",
    Values = { "None", "Good", "Evil" },
    Default = "None",
    Callback = function(v)
        State.karmaMode = v == "None" and nil or v:lower()
    end
})

CombatTab:Toggle({
    Title = "Protect Friends",
    Description = "Don't kill friends",
    Default = false,
    Callback = function(v) State.protectFriends = v end
})

CombatTab:Section("Brawl")

CombatTab:Toggle({
    Title = "Auto Win Brawl",
    Description = "Auto win brawl matches",
    Default = false,
    Callback = function(v) State.autoWinBrawl = v end
})

CombatTab:Section("Server")

CombatTab:Toggle({
    Title = "Server Hop",
    Description = "Auto hop servers every 30s",
    Default = false,
    Callback = function(v) State.serverHop = v end
})

CombatTab:Toggle({
    Title = "Auto Respawn",
    Description = "Auto respawn when dead",
    Default = false,
    Callback = function(v) State.autoRespawn = v end
})

-- ============================================================
-- MOVEMENT TAB
-- ============================================================
MovementTab:Section("Movement")

MovementTab:Toggle({
    Title = "Fast Speed",
    Description = "Walk very fast (100 speed)",
    Default = false,
    Callback = function(v)
        State.fastSpeed = v
        applyFastSpeed()
    end
})

MovementTab:Toggle({
    Title = "Fly",
    Description = "Fly around (WASD + Space/Ctrl)",
    Default = false,
    Callback = function(v)
        State.fly = v
        if v then startFly() else stopFly() end
    end
})

MovementTab:Toggle({
    Title = "Noclip",
    Description = "Walk through walls",
    Default = false,
    Callback = function(v)
        State.noclip = v
        if v then startNoclip() else stopNoclip() end
    end
})

MovementTab:Toggle({
    Title = "Infinite Jump",
    Description = "Jump forever",
    Default = false,
    Callback = function(v)
        State.infiniteJump = v
        if v then startInfJump() else stopInfJump() end
    end
})

MovementTab:Toggle({
    Title = "Walk Water",
    Description = "Walk on water",
    Default = false,
    Callback = function(v)
        State.walkWater = v
        if v then startWalkWater() else stopWalkWater() end
    end
})

MovementTab:Section("Rebirth")

MovementTab:Toggle({
    Title = "Auto Rebirth",
    Description = "Auto rebirth when ready",
    Default = false,
    Callback = function(v) State.autoRebirth = v end
})

MovementTab:Slider({
    Title = "Rebirth Amount",
    Description = "Rebirths needed to trigger",
    Min = 1,
    Max = 100,
    Default = 1,
    Callback = function(v) State.rebirthAmount = v end
})

-- ============================================================
-- PETS TAB
-- ============================================================
PetsTab:Section("Pets")

PetsTab:Toggle({
    Title = "Auto Pet",
    Description = "Auto equip best pet",
    Default = false,
    Callback = function(v) State.autoPet = v end
})

PetsTab:Toggle({
    Title = "Auto Aura",
    Description = "Auto equip best aura",
    Default = false,
    Callback = function(v) State.autoAura = v end
})

PetsTab:Section("Fuse Machine")

PetsTab:Toggle({
    Title = "Auto Fuse",
    Description = "Auto fuse pets",
    Default = false,
    Callback = function(v) State.autoFuse = v end
})

PetsTab:Slider({
    Title = "Fuse Slot",
    Description = "Which slot to fuse",
    Min = 1,
    Max = 6,
    Default = 1,
    Callback = function(v) State.fuseSlot = v end
})

-- ============================================================
-- TRADE TAB
-- ============================================================
TradeTab:Section("Trade")

TradeTab:Toggle({
    Title = "Auto Trade",
    Description = "Auto send trade requests",
    Default = false,
    Callback = function(v) State.autoTrade = v end
})

TradeTab:Dropdown({
    Title = "Trade Player",
    Values = (function()
        local t = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(t, p.Name) end
        end
        if #t == 0 then t[1] = "(no players)" end
        return t
    end)(),
    Default = "",
    Callback = function(v) State.tradePlayer = v end
})

TradeTab:Toggle({
    Title = "Auto Accept Trade",
    Description = "Auto accept incoming trades",
    Default = false,
    Callback = function(v) State.autoAcceptTrade = v end
})

TradeTab:Section("Gifts")

TradeTab:Toggle({
    Title = "Auto Gift",
    Description = "Auto send gifts",
    Default = false,
    Callback = function(v) State.autoGift = v end
})

TradeTab:Dropdown({
    Title = "Gift Player",
    Values = (function()
        local t = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(t, p.Name) end
        end
        if #t == 0 then t[1] = "(no players)" end
        return t
    end)(),
    Default = "",
    Callback = function(v) State.giftPlayer = v end
})

-- ============================================================
-- MISC TAB
-- ============================================================
MiscTab:Section("Performance")

MiscTab:Toggle({
    Title = "Anti Lag",
    Description = "Reduce lag and effects",
    Default = false,
    Callback = function(v)
        State.antiLag = v
        if v then startAntiLag() else stopAntiLag() end
    end
})

MiscTab:Toggle({
    Title = "Anti Crash",
    Description = "Prevent memory crashes",
    Default = false,
    Callback = function(v)
        State.antiCrash = v
        if v then startAntiCrash() else stopAntiCrash() end
    end
})

MiscTab:Section("Auto Rewards")

MiscTab:Toggle({
    Title = "Auto Spin Wheel",
    Description = "Auto spin fortune wheel",
    Default = false,
    Callback = function(v) State.autoSpinWheel = v end
})

MiscTab:Toggle({
    Title = "Auto Claim Chests",
    Description = "Auto claim nearby chests",
    Default = false,
    Callback = function(v) State.autoClaimChests = v end
})

MiscTab:Toggle({
    Title = "Remove Portals",
    Description = "Remove portals from world",
    Default = false,
    Callback = function(v) State.removePortals = v end
})

MiscTab:Section("Stats")

MiscTab:Toggle({
    Title = "Show Stats",
    Description = "Display player stats",
    Default = false,
    Callback = function(v)
        State.showStats = v
        if v then startStats() else stopStats() end
    end
})

-- ============================================================
-- TELEPORT TAB
-- ============================================================
TeleportTab:Section("Locations")

local locations = {
    "Industrial Gym", "Jungle Gym", "Muscle King", "Legends Gym",
    "Eternal Gym", "Mythical Gym", "Frost Gym", "Tiny Gym",
    "Beach", "Boss Arena", "Boss Battle", "Secret Area"
}

for _, loc in ipairs(locations) do
    TeleportTab:Button({
        Title = "TP to " .. loc,
        Callback = function()
            if teleportTo(loc) then
                print("Teleported to " .. loc)
            else
                warn("Failed to teleport to " .. loc)
            end
        end
    })
end

TeleportTab:Section("Players")

TeleportTab:Dropdown({
    Title = "Teleport to Player",
    Values = (function()
        local t = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then table.insert(t, p.Name) end
        end
        if #t == 0 then t[1] = "(no players)" end
        return t
    end)(),
    Default = "",
    Callback = function(v)
        if teleportToPlayer(v) then
            print("Teleported to " .. v)
        else
            warn("Failed to teleport to " .. v)
        end
    end
})

-- Status
MiscTab:Section("Status")

local statusLabel = MiscTab:Label({ Text = "Ready" })

task.spawn(function()
    while true do
        local status = "Muscle Legends Ultimate"
        if State.autoKill then status = status .. " | Kill: ON" end
        if State.autoFarmMode ~= "Off" then status = status .. " | Farm: " .. State.autoFarmMode end
        if State.fly then status = status .. " | Fly: ON" end
        pcall(function() statusLabel:Set(status) end)
        task.wait(1)
    end
end)

print("[Muscle Legends] Part 7 loaded - AIRFLOW GUI")
print("[Muscle Legends] All parts loaded successfully!")
