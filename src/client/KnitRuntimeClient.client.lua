--Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
    local player = Players.LocalPlayer

--Folders
local controllersFolder = player:WaitForChild("PlayerScripts"):WaitForChild("Controllers")
--Modules
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddControllers(controllersFolder)
Knit.AddControllersDeep(controllersFolder)

Knit.Start()
