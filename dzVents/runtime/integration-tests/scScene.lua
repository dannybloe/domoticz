return {
	active = true,
	on = {
		scenes = {
			'scScene'
		}
	},
	execute = function(dz, scene)

		if (not scene.name == 'sceneSwitch1') then
			dz.log('scScene: Test scene event: FAILED', dz.LOG_ERROR)
			dz.devices('scSceneResults').updateText('FAILED')
		else
			dz.log('scScene: Test scene event: OK')
			dz.devices('scSceneResults').updateText('SUCCEEDED')
		end

	end
}