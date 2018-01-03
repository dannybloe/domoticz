local socket = require("socket");

local testLastUpdate = function(dz, trigger, expectedDifference)
	local now = dz.time.secondsSinceMidnight
	local lastUpdate = trigger.lastUpdate.secondsSinceMidnight
	local diff = (now - lastUpdate)
	print('current: ' .. now .. ', lastUpdate: ' .. lastUpdate .. ', diff: ' .. diff .. ', expected: ' .. expectedDifference)

	if ( diff ~= expectedDifference) then
		print('Difference is: ' .. tostring(diff) .. ', expected to be: ' .. tostring(expectedDifference))
		return false
	end
	print('lastUpdate is as expected')
	return true
end

return {
	active = true,
	on = {
		devices = {
			'vdScriptStart',
			'vdScriptEnd',
		},
		variables = { 'var' }
	},
	execute = function(dz, item)

		local var = dz.variables('var')

		if (item.name == 'vdScriptStart') then
			if (not testLastUpdate(dz, var, 2)) then
				-- oops
				return
			end
			var.set('Zork is a dork').afterSec(2)
			dz.devices('vdScriptEnd').switchOn().afterSec(4)
		end

		if (item.isVariable) then
			local res = testLastUpdate(dz, item, 4)
			if (res) then
				dz.devices('vdScriptOK').switchOn()
			end
		end
	end
}
