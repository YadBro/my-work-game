-- SERVICES
local ReplicatedStorageService = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- MODULES
local ModulesFolder = ReplicatedStorageService:WaitForChild("Modules")
local GameConfigModule = require(ModulesFolder:FindFirstChild("GameConfigModule"))

local Heartbeat = RunService.Heartbeat

type TimerImpl = {
	__index: TimerImpl,
	WaitDelay: (
		second: number,
		onWaitHandler: (currentWaitTime: number) -> ()?,
		onBreakConditionHandler: (currentWaitTime: number) -> (boolean)?)
	-> (),
	GetIsRunning: () -> boolean,
	GetCalculateSpeedRunTime: (startTime: number?) -> {
		Text: string,
		Text_Human_Readable: string,
		total_seconds: number,
	},
}

type Timer = typeof(setmetatable({} :: {}, {} :: TimerImpl))

local Timer: TimerImpl = {} :: TimerImpl
Timer.__index = Timer

function Timer.WaitDelay(second: number, onWaitHandler: (currentWaitTime: number) -> (), onBreakConditionHandler: (currentWaitTime: number) -> (boolean)?): ()
	local delayTime = 0

	while delayTime <= second do
		delayTime += Heartbeat:Wait()
		local countdownTime = (second + 1) - math.ceil(delayTime)
		if onWaitHandler then
			onWaitHandler(countdownTime)
		end
		
		if onBreakConditionHandler then
			local breakCondition = onBreakConditionHandler(countdownTime)
			if breakCondition then
				break
			end
		end
	end
end

function Timer.GetCalculateSpeedRunTime(startTime: number?)
	local start_time = GameConfigModule.getConfig('StartSpeedRunTime')

	if startTime and typeof(startTime) == 'number' then
		start_time = startTime
	end

	if start_time then
		local finish_time = os.time()

		local total_seconds = finish_time - start_time
		local hours = math.floor(total_seconds / 3600)
		local minutes = math.floor((total_seconds % 3600) / 60)
		local seconds = total_seconds % 60

		local format_current_speed_run_time = string.format("%02d:%02d:%02d", hours, minutes, seconds)
		local format_readable_human = string.format("%02dh %02dm %02ds", hours, minutes, seconds)

		return {
			Text = format_current_speed_run_time,
			Text_Human_Readable = format_readable_human,
			total_seconds = total_seconds
		}
	else
		return {
			Text = '00:00:00',
			Text_Human_Readable = "0h 0m 0s",
			total_seconds = 0
		}
	end
end

return Timer