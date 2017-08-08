return {

	baseType = 'device',

	name = 'Text device',

	matches = function (device, adapterManager)
		local res = (device.deviceSubType == 'Text')
		if (not res) then
			adapterManager.addDummyMethod(device, 'updateText')
		end
		return res
	end,

	process = function (device, data, domoticz, utils, adapterManager)

		device['text'] = device.rawData[1] or ''

		device['updateText'] = function (text)
			--?type=command&param=udevice&idx=30&nvalue=0&svalue=hoihoi

			-- use openurl to trigger followup events
			local url = domoticz.settings['Domoticz url'] ..
					'/json.htm?type=command&param=udevice&idx=' ..
					device.id .. '&nvalue=0&svalue=' .. utils.urlEncode(tostring(text))
			domoticz.openURL(url)
		end

	end

}