local scriptPath = _G.globalvariables['script_path']
package.path    = package.path .. ';' .. scriptPath .. '?.lua'

local utils = require('Utils')

local function TimedCommand(domoticz, name, value, mode)
	local valueValue = value
	local afterValue, forValue, randomValue, silentValue, repeatValue, delayValue
	local _for, _after, _within, _rpt, _silent, _between

	local constructCommand = function()

		local command = {} -- array of command parts

		table.insert(command, valueValue)

		if (randomValue ~= nil) then
			table.insert(command, 'RANDOM ' .. tostring(randomValue) .. ' SECONDS')
		end

		if (afterValue ~= nil) then
			table.insert(command, 'AFTER ' .. tostring(afterValue) .. ' SECONDS')
		end

		if (forValue ~= nil) then
			table.insert(command, 'FOR ' .. tostring(forValue) .. ' SECONDS')
		end

		if (mode == 'updatedevice' or mode == 'variable') then
			if (silentValue == false or silentValue == nil) then
				table.insert(command, 'TRIGGER')
			end
		else
			if (silentValue == true) then
				table.insert(command, 'NOTRIGGER')
			end
		end

		if (repeatValue ~= nil) then
			table.insert(command, 'REPEAT ' .. tostring(repeatValue))
		end

		if (delayValue ~= nil) then
			table.insert(command, 'INTERVAL ' .. tostring(delayValue) .. ' SECONDS')
		end


		local sCommand = table.concat(command, " ")

		utils.log('Constructed timed-command: ' .. sCommand, utils.LOG_DEBUG)

		return sCommand

	end

	-- get a reference to the latest entry in the commandArray so we can
	-- keep modifying it here.
	local latest, command, sValue = domoticz.sendCommand(name, constructCommand())

	local function factory()

		local res = {}

		if (afterValue == nil and randomValue == nil) then
			res.afterSec = _after(1)
			res.afterMin = _after(60)
			res.afterHour = _after(3600)
			res.withinSec = _within(1)
			res.withinMin = _within(60)
			res.withinHour = _within(3600)
		end

		if (forValue == nil and mode ~= 'variable' and mode ~= 'updatedevice' ) then
			res.forSec = _for(1)
			res.forMin = _for(60)
			res.forHour = _for(3600)
		end

		if (silentValue == nil) then
			res.silent = _silent
		end

		if (repeatValue == nil and mode ~= 'variable' and mode ~= 'updatedevice') then
			res.rpt = _rpt
		end

		if (delayValue == nil and mode ~= 'variable' and mode ~= 'updatedevice') then
			res.secBetweenRepeat = _between(1)
			res.minBetweenRepeat = _between(60)
			res.hourBetweenRepeat = _between(3600)
		end

		res._latest = latest

		return res
	end

	_checkValue = function(value, msg)
		if (value == nil) then utils.log(msg, utils.LOG_ERROR) end
	end

	_after = function(factor)
		return function(value)
			_checkValue(value, "No value given for 'afterXXX' command")
			afterValue = value * factor
			latest[command] = constructCommand()
			return factory()
		end
	end

	_within = function(factor)
		return function(value)
			_checkValue(value, "No value given for 'withinXXX' command")
			randomValue = value * factor
			latest[command] = constructCommand()
			return factory()
		end
	end

	_for = function(factor)
		return function(value)
			_checkValue(value, "No value given for 'forXXX' command")
			forValue = value * factor
			latest[command] = constructCommand()
			return factory()
		end
	end

	_silent = function()
		silentValue = true;
		latest[command] = constructCommand()
		return factory()
	end

	_rpt = function(amount)
		_checkValue(value, "No value given for 'rpt' command")
		repeatValue = amount + 1 -- add one due to a bug in domoticz
		latest[command] = constructCommand()
		return factory()
	end

	_between = function(factor)
		_checkValue(value, "No value given for 'xxxBetweenRepeat' command")
		return function(value)
			delayValue = value * factor
			latest[command] = constructCommand()
			return factory()
		end
	end

	return factory()

end

return TimedCommand