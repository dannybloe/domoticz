return {

	setType = function(item, typeName, baseType, trigger)

		item.isHTTPResponse = false
		item.isDevice = false
		item.isScene = false
		item.isGroup = false
		item.isTimer = false
		item.isVariable = false
		item.isSecurity = false
		item.isDomoticzEvent = false
		item.isHardware = false

		item[typeName] = true

		item.baseType = baseType

		item.trigger = trigger
		return item

	end

}