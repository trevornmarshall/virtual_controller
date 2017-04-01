-- Joystick class that creates a simple joystick
-- Nob inside of cirular container that can only go as far as
-- the edge of the circular container

-- Here is an example of a property table with some explanations
-- local propsTable = {
-- 	nToCRatio = 0.5,	-- This is the ratio of the nob's radius to the container's radius
-- 	radius = 50, 		-- This is the radius of the container
-- 	x = 100,			-- The x-coordinate of center of joystick
-- 	y = 100,			-- y-coordinate of center of joystick
-- 	restingXValue = 0,	-- The x value to be sent from getXYValues when joystick is at center
-- 	restingYValue = 0,	-- The y value to be sent from getXYValues when joystick is at center
-- 	scaleX = 100,		-- Difference between Max and Min x-values. This would go from -50 to 50
-- 	scaleY = 100,		-- Same as scaleX but for y
-- 	touchHandler = {
-- 		onTouch = function(self, x, y)
-- 			-- Use x and y values to do something
-- 		end
-- 	}
-- }

-- Class table variable to hold all class variables and methods
local JSCreator = {}

-- function to create joystick from factory
function JSCreator:createFromProperties(props)
	
	local JS = {}
	
	-- These are the fields that we need values for
	JS.nToCRatio = props.nToCRatio
	JS.r = props.radius
	JS.x = props.x
	JS.y = props.y
	JS.restingXValue = props.restingXValue
	JS.restingYValue = props.restingYValue
	JS.scaleX = props.rangeX / JS.r
	JS.scaleY = props.rangeY / JS.r

	-- This is an optional touch handler so that the joystick will 
	-- call its onTouch method with x and y values as parameters
	JS.touchHandler = props.touchHandler

	JS.display = displayJS
	JS.getXYValues = getXYValues
	JS.getRestingXYValues = getRestingXYValues

	return JS
end
-- Function to return x and y coordinates relative to joystick center and adjusted by the given scale
function getXYValues(self)
	local coords = {}

	local x = self.nob.x - self.x
	coords.x = x * self.scaleX + self.restingXValue

	local y = self.nob.y - self.y
	coords.y = y * self.scaleY + self.restingYValue

	return coords
end

function getRestingXYValues(self)
	return {x = self.restingXValue, y = self.restingYValue}
end

-- function to display the joystick on screen
function displayJS(self, sceneGroup)
	self.container = display.newCircle( sceneGroup, self.x, self.y, self.r )
	self.container:setFillColor(0, 0, 0, 0)
	self.container.strokeWidth = 5
	self.container:setStrokeColor(1, 1, 1, 0.2)

	self.nob = display.newCircle( sceneGroup, self.x, self.y, self.r * self.nToCRatio )
	self.nob:setFillColor(1, 1, 1, 0.2)
	self.nob.strokeWidth = 5
	self.nob:setStrokeColor(1, 1, 1, 0.5)
	self.nob.JS = self
	self.nob:addEventListener("touch", onNobTouch)
end

--***** Helper Methods
-- checks the boundary to make sure nob is inside bounds
local function checkBoundary(nob, nobX, nobY)
	local JS = nob.JS
	local x = nobX - JS.x
	local y = nobY - JS.y

	-- get the radius of the circle that would have center at JS.x, JS.y 
	-- and contain the point nobX, nobY in its edge
	local x2 = x * x
	local y2 = y * y
	local r2 = x2 + y2
	local r = r2 ^ 0.5

	if(r > JS.r) then
		-- Scale the points down by ratio of JS.r to radius we just calculated
		-- then slide them back relative to JS.x, JS.y
		local scale = JS.r / r
		return {x = JS.x + (scale * x), y = JS.y + (scale * y)}
	else 
		-- Inside of boundary so just return input values
		return {x = nobX, y = nobY}
	end
end

-- function to handle touch events on nob of JS
function onNobTouch(event)
	local nob = event.target
	local phase = event.phase

	if("began" == phase) then
		display.currentStage:setFocus(nob, event.id)
		nob.touchOffsetX = event.x - nob.x
		nob.touchOffsetY = event.y - nob.y
		nob.eventID = event.id
		
	elseif(event.id ~= nob.eventID) then
		-- This isn't our event to worry about
		return false
	end

	-- If we are still here, then this is our event id and we handle event
	if("moved" == phase) then
		local position = checkBoundary(nob, event.x - nob.touchOffsetX, event.y - nob.touchOffsetY)
		nob.x = position.x
		nob.y = position.y
		
		if(nob.JS.touchHandler) then
			local pos = nob.JS:getXYValues()
			nob.JS.touchHandler:onTouch(pos.x, pos.y)
		end
	elseif("ended" == phase or "cancelled" == phase) then
		transition.to(nob, {x = nob.JS.x, y = nob.JS.y, time = 100})
		display.currentStage:setFocus(nob, nil)
		nob.eventID = nil

		if(nob.JS.touchHandler) then
			local pos = nob.JS:getRestingXYValues()
			nob.JS.touchHandler:onTouch(pos.x, pos.y)
		end
	end

	return true
end

-- When we require this file, return our Class Table
return JSCreator