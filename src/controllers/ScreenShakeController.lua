--[=[
    @class ScreenShakeController
    
    ### ⏲Release Version:
    
    ### 📃Description:
    Handles screen shake using the Shake module

]=]

--Roblox Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Modules
local Packages = ReplicatedStorage:WaitForChild("Packages")
local Knit = require(Packages.Knit)
local Shake = require(Packages.Shake)

local ScreenShakeController = Knit.CreateController { Name = "ScreenShakeController" }

--[=[
@within ScreenShakeController
@method KnitStart
@since 
Knit will call KnitStart after all services have been initialized

]=]
function ScreenShakeController:KnitStart()
    
end

--[=[
@within ScreenShakeController
@method KnitInit
@since 
Knit will call KnitInit when Knit is first started

]=]
function ScreenShakeController:KnitInit()
    
end

--[=[
@within ScreenShakeController
@method New
@since v0.1.1-alpha

Creates and returns a new screen shake object from the Shake package
]=]
function ScreenShakeController.New(Amplitude, FadeInTime, FadeOutTime, Frequency, PositionInfluence, RotationInfluence, Sustain, SustainTime, TimeFunction)
    local newShake = Shake.new()
    setmetatable(newShake, ScreenShakeController)

    newShake.Amplitude = Amplitude
    newShake.FadeInTime = FadeInTime
    newShake.FadeOutTime = FadeOutTime
    newShake.Frequency = Frequency
    newShake.PositionInfluence = PositionInfluence
    newShake.RotationInfluence = RotationInfluence
    newShake.Sustain = Sustain
    newShake.SustainTime = SustainTime
    newShake.TimeFunction = TimeFunction

    return newShake
end

function ScreenShakeController:DistanceShake(item, distanceFrom, shake, origCFrame, name, renderPriority, distanceFactor, posFactor, rotFactor)
    shake:BindToRenderStep(name, renderPriority or Enum.RenderPriority.Last.Value, function(pos, rot, done)
        local distance = (item.Position or item.PrimaryPart.Position or item.CFrame.Position - distanceFrom.Position or distanceFrom.PrimaryPart.Position or distanceFrom.CFrame.Position).Magnitude / distanceFactor or 100
        pos = (Shake.InverseSquare(pos, distance)) / posFactor or 12.5
        rot = (Shake.InverseSquare(rot, distance)) / rotFactor or 12.5
        item.CFrame = item.CFrame * CFrame.new(pos) * CFrame.Angles(rot.X, rot.Y, rot.Z)

        if done then
            item.CFrame = origCFrame
        end
    end)
end


return ScreenShakeController
