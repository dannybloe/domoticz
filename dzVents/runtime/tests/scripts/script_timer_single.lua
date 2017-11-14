local min = 'minute'
return {
	active = true,
	on = {
		['timer'] = {'every ' .. min}
	},
	execute = function(domoticz, timer, triggerInfo)
		if (timer.isTimer) then
			domoticz.notify('Me', timer.triggerRule .. ' ' .. triggerInfo.type .. ' ' .. triggerInfo.trigger)
		end
		return 'script_timer_table'
	end
}
