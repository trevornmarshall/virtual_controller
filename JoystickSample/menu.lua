
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoTimerBasedExample()
	composer.gotoScene("timerbasedexample")
end

local function gotoEventHandlerExample()
	composer.gotoScene("eventhandlerexample")
end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

	local title = display.newText(sceneGroup, "Virtual Controller Example", display.contentCenterX, 200, native.systemFont, 44)

	local timerExampleButton = display.newText(sceneGroup, "Timer Based Example", display.contentCenterX, 810, native.systemFont, 44)
	timerExampleButton:setFillColor(0.5, 0.5, 1, 1)

	local eventHandlerButton = display.newText(sceneGroup, "Event Handler Example", display.contentCenterX, 920, native.systemFont, 44)
	eventHandlerButton:setFillColor(0.5, 0.5, 1, 1)

	timerExampleButton:addEventListener("tap", gotoTimerBasedExample)
	eventHandlerButton:addEventListener("tap", gotoEventHandlerExample)
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
