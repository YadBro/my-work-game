--!strict

-- SERVICES
local ReplicatedStorageService = game:GetService("ReplicatedStorage")

-- PACKAGES
local PackagesFolder = ReplicatedStorageService.Shared.Packages

local TestEZ = require(PackagesFolder.TestEZ)

TestEZ.run(ReplicatedStorageService.Shared.tests, print)