-- Button factory class that creates a simple button
-- Just a simple circle with a letter inside of it

local ButtonCreator = {}

-- Function to return the button from the button factory
function ButtonCreator:createFromProperties(props)
	local Button = {}

	Button.text = props.text
	Button.r = props.radius
	Button.x = props.x
	Button.y = props.y

	Button.eventHandler = props.eventHandler
	
	Button.display = displayButton

	return Button
end

-- Function to display the button on screen
function displayButton(self, sceneGroup)
	self.button = display.newCircle(sceneGroup, self.x, self.y, self.r)
	self.button:setFillColor(1, 1, 1, 0.2)
	self.button.strokeWidth = 5
	self.button:setStrokeColor(1, 1, 1, 0.5)
	self.button.buttonParent = self
	self.button:addEventListener("touch", onbuttonTouch)
end

-- function to handle touch events on button
function onbuttonTouch(event)
	local button = event.target
	local phase = event.phase

	if("began" == phase) then
		display.currentStage:setFocus(button, event.id)
		button.eventID = event.id
		button.buttonParent.eventHandler:handleButtonDown()
		if(button.buttonParent.eventHandler) then
			
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
		
		if(button.buttonParent.eventHandler) then
			button.buttonParent.eventHandler:handleButtonUp()
		end
	end

	return true
end

-- When we require this file, return our Class Table
return ButtonCreator