--[=[
    @class CubeRuntimeService
    
    ### ⏲Release Version:
    
    ### 📃Description:
    Handles all runtime stuff for The Cube
]=]

--Roblox Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Modules
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages.Knit)
local Promise = require(Knit.Util.Promise)

local CubeRuntimeService = Knit.CreateService {
    Name = "CubeRuntimeService",
    Client = {},
}

--Communication
local communication = ReplicatedStorage:FindFirstChild("Comm")
local functions = communication:FindFirstChild("Functions")
    local playerInCubeProximityFunction = functions:WaitForChild("PlayerInCubeProximity")
    local moveCubeFunction = functions:WaitForChild("MoveCube")

--[=[
@within CubeRuntimeService
@method KnitStart
@since 
Knit will call KnitStart after all services have been initialized

]=]
function CubeRuntimeService:KnitStart()

end

--[=[
@within CubeRuntimeService
@method KnitInit
@since 
Knit will call KnitInit when Knit is first started

]=]
function CubeRuntimeService:KnitInit()
    local map = workspace.Map
    local cube = map:FindFirstChild("TheCube")
    local cubeProximity = cube:FindFirstChild("ProximityPrompt")

    self._SetRandomMapPosition(nil, cube)

    local function playerInProximity(character)
        local hrp

        local hrpPromise = Promise.try(function()
            hrp = character.HumanoidRootPart
        end)

        local hrpPromiseStatus = hrpPromise:awaitStatus()

        print(hrpPromiseStatus)

        if hrpPromiseStatus ~= "Resolved" then
            print("Not resolved")
            return false
        end

        local magnitude = (cube.PrimaryPart.Position - hrp.Position).Magnitude
        print(magnitude)

        if magnitude < cubeProximity.MaxActivationDistance * 2 then
            print("Passed playerInProximity")
            return true
        else
            print("Too far away")
            return false
        end
    end

    local function changeCubeOwnership(player)
        local yesSound = cube:FindFirstChild("Yes")

        yesSound:Play()
        cube:SetAttribute("CubeOwnerId", player.UserId)

    end

    local function playerShouldBeCube()
        local random = math.random(1,1)
        if random == 1 then
            return true
        else
            return false
        end
    end

    local function movePlayerElsewhere(character)
        local noSound = cube:FindFirstChild("No")

        local positionGood = false
        local position

        while positionGood == false do
            position = self._GetRandomMapPosition()
            if (position - cube.PrimaryPart.Position).Magnitude >= 100 then
                positionGood = true
            end
        end
        
        noSound:Play()
        character.HumanoidRootPart.CFrame = CFrame.new(position)
    end

    local function playerIsCube(player)
        if cube:GetAttribute("CubeOwnerId") == player.UserId then
            return true
        else
            return false
        end
    end

    playerInCubeProximityFunction.OnServerInvoke = function(player)
        if playerInProximity(player.Character) and not playerIsCube(player)  then
            if playerShouldBeCube() then
                print("Becoming Cube")
                changeCubeOwnership(player)
                return true
            else
                print("Moving player")
                movePlayerElsewhere(player.Character)
            end
        end
    end

    moveCubeFunction.OnServerInvoke = function(_)
        local goodPlacement = false
        
        while not goodPlacement do
            local cubePossiblePosition = self._GetRandomMapPosition()
            for _, player in pairs(Players:GetPlayers()) do
                local character = player.Character
                local hrp = character:FindFirstChild("HumanoidRootPart")
				
				print("Player searching")
				if (hrp.Position - cubePossiblePosition).Magnitude >= 10 then
					print("Good position")
                    cube.PrimaryPart.Position = cubePossiblePosition
                    goodPlacement = true
                end
            end
        end
        print("Done moving cube")
        return true
    end
end

function CubeRuntimeService:_GetRandomMapPosition()
    --255 (maybe 230)
    return Vector3.new(math.random(-30, 30), 2.5, math.random(-30, 30))
end

function CubeRuntimeService:_SetRandomMapPosition(item)
    if item:IsA("Part") then
        item.Position = CubeRuntimeService._GetRandomMapPosition()
    elseif item:IsA("Model") then
        item:MoveTo(CubeRuntimeService._GetRandomMapPosition())
    end
end


return CubeRuntimeService
