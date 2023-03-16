--[=[
    @class CubeRuntimeController
    
    ### ⏲Release Version:
    
    ### 📃Description:
    Controls the client side of the runtime for The Cube

]=]

--Roblox Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

--Modules
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages.Knit)

local CubeRuntimeController = Knit.CreateController { Name = "CubeRuntimeController" }

--Communication
local communication = ReplicatedStorage:FindFirstChild("Comm")
local functions = communication:FindFirstChild("Functions")
    local playerInCubeProximityFunction = functions:WaitForChild("PlayerInCubeProximity")
    local moveCubeFunction = functions:WaitForChild("MoveCube")
local events = communication:FindFirstChild("Events")
    local teleportPlayerToJailEvent = events:WaitForChild("TeleportPlayerToJail")

--[=[
@within CubeRuntimeController
@method KnitStart
@since 
Knit will call KnitStart after all services have been initialized

]=]
function CubeRuntimeController:KnitStart()
    local map = workspace.Map
    local cube = map:FindFirstChild("TheCube")
    local cubeProximity = cube:FindFirstChild("ProximityPrompt")

    local cubeProximityDebounce = false

    local player = Players.LocalPlayer

    repeat
        task.wait()
    until player.Character

    local character = player.Character

    cubeProximity.PromptShown:Connect(function()
        if cubeProximityDebounce == false then
            cubeProximityDebounce = true
            local becomingCube = playerInCubeProximityFunction:InvokeServer()
            if becomingCube then
                local camera = workspace.CurrentCamera
                self._PlayCubeTransformationCutscene(nil, camera, cube, character)
            end
            print("Event fired")
            task.wait(.5)
            cubeProximityDebounce = false
        end
    end)
end

--[=[
@within CubeRuntimeController
@method KnitInit
@since 
Knit will call KnitInit when Knit is first started

]=]
function CubeRuntimeController:KnitInit()
    
end

function CubeRuntimeController:_PlayCubeTransformationCutscene(camera, cube, character)
    local Controls = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")):GetControls() --GetControls
    Controls:Disable()
    -- Controls:Enable()

    local cubePart = cube.PrimaryPart

    local cubeRotationTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local cubeRotationTweenGoal = {CFrame = CFrame.lookAt(cube.PrimaryPart.Position, character.HumanoidRootPart.Position)}
    local cubeRotationTween = TweenService:Create(cubePart, cubeRotationTweenInfo, cubeRotationTweenGoal)
    cubeRotationTween:Play()

    cubeRotationTween.Completed:Wait()

    local cameraView = Instance.new("Part")
    cameraView.Anchored = true
    cameraView.CanCollide = false
    cameraView.Name = "CameraView"
    cameraView.Transparency = 1
    cameraView.CFrame = CFrame.lookAt(cube.PrimaryPart.Position, character.HumanoidRootPart.Position) * CFrame.new(0, 0, -(cube.PrimaryPart.Position-character.HumanoidRootPart.Position).Magnitude / 2)
    cameraView.Parent = cube.Parent

    camera.CameraType = Enum.CameraType.Scriptable
    
    local cameraTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    local camGoalPos = Vector3.new(cube.PrimaryPart.Position.X - 14, cube.PrimaryPart.Position.Y + 8.5, cube.PrimaryPart.Position.Z)
    local cameraTweenGoal = {CFrame = CFrame.lookAt(camGoalPos, cameraView.Position)}
    local cameraTween = TweenService:Create(camera, cameraTweenInfo, cameraTweenGoal)
    cameraTween:Play()

    task.wait(1)

    local cubeTweenInfo = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, true)
    local cubeTweenGoal = {Position = character.HumanoidRootPart.Position, Size = Vector3.new(cubePart.Size.X * 1.3, cubePart.Size.Y * 1.3, cubePart.Size.Z * 1.3)}
    local cubeTween = TweenService:Create(cubePart, cubeTweenInfo, cubeTweenGoal)
    cubeTween:Play()

    task.wait(1.75)

    teleportPlayerToJailEvent:FireServer()

    cubeTween.Completed:Wait()

    moveCubeFunction:InvokeServer(cube)

    camera.CameraType = Enum.CameraType.Custom

    local function updateCamera()
        camera.CameraSubject = cube
    end

    updateCamera()
    local positionUpdateConnection
    positionUpdateConnection = cubePart:GetPropertyChangedSignal("Position"):Connect(function()
        if cube:GetAttribute("CubeOwnerId") ~= Players:GetPlayerFromCharacter(character).UserId then
            print("Disconnected")
            positionUpdateConnection:Disconnect()
        end
        updateCamera()
    end)

    print("Cutscene played")
end


return CubeRuntimeController
