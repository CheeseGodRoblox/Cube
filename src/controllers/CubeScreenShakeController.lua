--[=[
    @class CubeScreenShakeController
    
    ### ⏲Release Version:
    
    ### 📃Description:
    This manages the screen shake that is based on the proximity of the player and the cube.

    ### ⚙️Dependencies:
    * ScreenShakeController
]=]

--Roblox Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

--Modules
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages.Knit)
local Shake = require(Packages.Shake)

local player = Players.LocalPlayer
local PlayerScripts = player.PlayerScripts
local Controllers = PlayerScripts.Controllers
local ScreenShakeController = require(Controllers.ScreenShakeController)

local CubeScreenShakeController = Knit.CreateController { Name = "CubeScreenShakeController" }

--[=[
@within CubeScreenShakeController
@method KnitStart
@since 
Knit will call KnitStart after all services have been initialized

]=]
function CubeScreenShakeController:KnitStart()
    
end

--[=[
@within CubeScreenShakeController
@method KnitInit
@since 
Knit will call KnitInit when Knit is first started

]=]
function CubeScreenShakeController:KnitInit()
    local map = workspace.Map
    local cube = map:FindFirstChild("TheCube")

    repeat
        task.wait()
    until workspace.Camera and workspace.CurrentCamera
    local camera = workspace.CurrentCamera
    print(cube, camera)

    local startConstantShake = coroutine.create(function()
        
    end)

    coroutine.resume(startConstantShake)

    self._constantShake = self._StartConstantShake(nil, cube, camera)

end

function CubeScreenShakeController:_StartConstantShake(cube, camera)
    local camCf = camera.CFrame
    local constantShake = ScreenShakeController.New(nil, 0, nil, .05, nil, Vector3.new(.1, .1, .1), true)
    constantShake:Start()

    return constantShake

    -- self._constantShake:BindToRenderStep("ConstantCubeShake", Enum.RenderPriority.Last.Value, function(pos, rot, done)
    --     local distance = (camera.CFrame.Position - cube.PrimaryPart.Position).Magnitude / 100
    --     pos = (Shake.InverseSquare(pos, distance)) / 12.5
    --     rot = (Shake.InverseSquare(rot, distance)) / 12.5
    --     camera.CFrame = camera.CFrame * CFrame.new(pos) * CFrame.Angles(rot.X, rot.Y, rot.Z)

    --     if done then
    --         camera.CFrame = camCf
    --     end
    -- end)
end

function CubeScreenShakeController:_PauseConstantShake()
    if self._constantShake then
        self._constantShake:Stop()
    end
end



return CubeScreenShakeController
