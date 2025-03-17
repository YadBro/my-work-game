-- SERVICES
local RunService = game:GetService("RunService")

local Heartbeat = RunService.Heartbeat

type initDataTimer = {
	_isCountdownCanceled: boolean,
	_isCountdownRunning: boolean
}

type TimerImpl = {
	__index: TimerImpl,
	new: () -> Timer,
	Countdown: (
		self: Timer,
		second: number,
		onWaitHandler: (currentWaitTime: number) -> ()?,
		onBreakConditionHandler: (currentWaitTime: number) -> (boolean)?)
	-> (),
	SetCountdownCanceled: (self: Timer, condition: boolean)-> (),
	SetCountdownRunning: (self: Timer, condition: boolean)-> (),
	GetCountdownStatus: (self: Timer) -> {
		isCountdownCanceled: boolean,
		isCountdownRunning: boolean,
	},
	GetCalculateSpeedRunTime: (startTime: number?) -> {
		Text: string,
		Text_Human_Readable: string,
		total_seconds: number,
	},
}

type Timer = typeof(setmetatable({} :: initDataTimer, {} :: TimerImpl))

local Timer: TimerImpl = {} :: TimerImpl
Timer.__index = Timer

function Timer.new()
	local self = {}
	self._isCountdownCanceled = false
	self._isCountdownRunning = false

	return setmetatable(self, Timer)
end

function Timer:Countdown(second: number, onWaitHandler: (currentWaitTime: number) -> (), onBreakConditionHandler: (currentWaitTime: number) -> (boolean)?): ()
	self:SetCountdownCanceled(false)
	local delayTime = 0

	if not self._isCountdownRunning then
		self:SetCountdownRunning(true)
		while delayTime <= second do
			if self._isCountdownCanceled then
				self:SetCountdownRunning(false)
				break
			end

			delayTime += Heartbeat:Wait()

			local countdownTime = (second + 1) - math.ceil(delayTime)

			if onWaitHandler then
				onWaitHandler(countdownTime)
			end

			if onBreakConditionHandler then
				self:SetCountdownRunning(false)
				local breakCondition = onBreakConditionHandler(countdownTime)
				if breakCondition then
					break
				end
			end
		end
	end

	self:SetCountdownRunning(false)
end

function Timer:SetCountdownCanceled(condition)
	self._isCountdownCanceled = condition
end

function Timer:SetCountdownRunning(condition)
	self._isCountdownRunning = condition
end

function Timer:GetCountdownStatus()
	return {
		isCountdownCanceled = self._isCountdownCanceled,
		isCountdownRunning = self._isCountdownRunning,
	}
end

function Timer.GetCalculateSpeedRunTime(startTime: number)
	local finish_time = os.time()

	local total_seconds = finish_time - startTime
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
end

return Timer