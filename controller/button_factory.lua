-- Button factory class that creates a simple button
-- Just a simple circle with a letter inside of it

-- Here is an example of a property table with descriptions
-- local propsTable = {
-- 	text = "A",		-- Text to display on the button.
-- 	radius = 50,	-- radius of the button
-- 	x = 100,		-- the x coordinate of the center of button
-- 	y = 200,		-- the y coordinate
-- 	eventHandler = {	-- The table which has methods to handle the events
-- 		onButtonDown = function(self)
-- 			-- code to handle what happens when the button is pressed
-- 			-- If you want something to repeat when they hold the button down, use timer
-- 		end,
-- 		onButtonUp = function(self)
-- 			-- Code to handle when the button stops being pressed
-- 			-- If you set a timer onButtonDown, maybe end that timer here
-- 		end
-- 	}
-- }

local ButtonCreator = {}

-- Function to return the button from the button factory
function ButtonCreator:createFromProperties(props)
	local Button = {}

	Button.text = props.text
	Button.r = props.radius
	Button.x = props.x
	Button.y = props.y

	-- eventHandler is a table with two event handling methods - onButtonDown
	-- and onButtonUp
	Button.eventHandler = props.eventHandler
	
	Button.display = displayButton

	return Button
end

-- Function to display the button on screen
function displayButton(self, sceneGroup)
	-- Create the circle of the button
	self.button = display.newCircle(sceneGroup, self.x, self.y, self.r)
	self.button:setFillColor(1, 1, 1, 0.2)
	self.button.strokeWidth = 5
	self.button:setStrokeColor(1, 1, 1, 0.5)
	self.button.alpha = 0.5
	self.button.buttonParent = self
	self.button:addEventListener("touch", onbuttonTouch)

	-- Add the text into the middle of the button
	self.buttonText = display.newText(sceneGroup, self.text, self.x, self.y, native.systemFont, self.r)
end

-- function to handle touch events on button
function onbuttonTouch(event)
	local button = event.target
	local phase = event.phase

	if("began" == phase) then
		display.currentStage:setFocus(button, event.id)
		button.eventID = event.id
		button.alpha = 1
		
		if(button.buttonParent.eventHandler) then
			button.buttonParent.eventHandler:onButtonDown()
		end
	elseif(event.id ~= button.eventID) then
		-- This isn't our event to worry about
		return false
	end

	-- If we are still here, then this is our event id and we handle event
	if("moved" == phase) then
		-- This is a button... It can't move. The only reason we do touch is 
		-- for multitouch and press and hold
	elseif("ended" == phase or "cancelled" == phase) then
		display.currentStage:setFocus(button, nil)
		button.eventID = nil
		button.alpha = 0.5
		
		if(button.buttonParent.eventHandler) then
			button.buttonParent.eventHandler:onButtonUp()
		end
	end

	return true
end

-- When we require this file, return our Class Table
return ButtonCreator