
-- SERVICES
local RunService = game:GetService("RunService")
local ReplicatedStorageService = game:GetService("ReplicatedStorage")

local ConfigFolder: Folder = ReplicatedStorageService:WaitForChild("Config")

if not ConfigFolder or not ConfigFolder:IsA("Folder") then
	error("Please provide config folder on ReplicatedStorage First!")
end

type GameConfigImpl = {
	__index: GameConfigImpl,

	--[[
		Debug your data on console without appear in production
	]]
	debugConsole: (any: any, debugFunc: any) -> (),

	getConfig: (name: string) -> any | nil,
	getConfigInstance: (name: string) -> any | nil,
	setConfig: (name: string, value: any) -> ()
}

type GameConfig = typeof(setmetatable({} :: {}, {} :: GameConfigImpl))

local GameConfig: GameConfigImpl = {} :: GameConfigImpl
GameConfig.__index = GameConfig

function GameConfig.debugConsole(any: any, debugFunc)
	local isDevelopment = RunService:IsStudio()
	local func = debugFunc or print

	if isDevelopment then
		func("[DEVELOPMENT] " .. any)
	end
end

function GameConfig.getConfig(name)
    local config = ConfigFolder:FindFirstChild(name)
	print(config, 'ADAAA?', ConfigFolder)

    if config then
        return config.Value
    end

	return nil
end

function GameConfig.getConfigInstance(name)
	return ConfigFolder[name]
end

function GameConfig.setConfig(name, value)
    local config = GameConfig.getConfig(name)
    if config then
        config.Value = value
	else
		warn("The config " .. name .. " is not found. Please create the config " .. name .. " first!")
    end
end

return GameConfig
