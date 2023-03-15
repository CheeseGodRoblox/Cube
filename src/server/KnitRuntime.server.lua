--Services
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--Folders
local servicesFolder = ServerStorage:WaitForChild("Services")

--Modules
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServices(servicesFolder)
Knit.AddServicesDeep(servicesFolder)

Knit.Start()
