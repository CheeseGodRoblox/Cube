--[=[
    @class LocalTeleportService
    
    ### ⏲Release Version:
    
    ### 📃Description:
    Teleports players within this place
]=]

--Roblox Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Modules
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages.Knit)

local LocalTeleportService = Knit.CreateService {
    Name = "LocalTeleportService",
    Client = {},
}

--Communication
local communication = ReplicatedStorage:FindFirstChild("Comm")
local events = communication:FindFirstChild("Events")
    local teleportPlayerToJailEvent = events:WaitForChild("TeleportPlayerToJail")

--[=[
@within LocalTeleportService
@method KnitStart
@since 
Knit will call KnitStart after all services have been initialized

]=]
function LocalTeleportService:KnitStart()
    teleportPlayerToJailEvent.OnServerEvent:Connect(function(player)
        repeat
            task.wait()
        until player.Character

        local map = workspace.Map
        local cage = map:FindFirstChild("Cage")
        local cageSpawn = cage:FindFirstChild("Spawn")

        local character = player.Character
        local hrp = character.HumanoidRootPart

        hrp.CFrame = cageSpawn.CFrame
    end)
end

--[=[
@within LocalTeleportService
@method KnitInit
@since 
Knit will call KnitInit when Knit is first started

]=]
function LocalTeleportService:KnitInit()
    
end


return LocalTeleportService
