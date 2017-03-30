-- Controller Class that can be used to create a custom virtual Controller
-- Can create multiple joysticks and multiple buttons and control the layout 
-- as well as the functions performed by any buttons.
-- Can get state of buttons and joystick. 
-- Able to get x, y values from the controller that are based on whatever scale is provided

local Factory = {}

Factory.joystickFactory = require("controller.joystick_factory")
Factory.buttonFactory = require("controller.button_factory")
Factory.objects = {}

-- Method to add joystick to controller
function Factory:addJoystick(name, props)
	self:addObject(name, props, self.joystickFactory)
end

-- method to add a button to the controller
function Factory:addButton(name, props)
	self:addObject(name, props, self.buttonFactory)
end

-- Helper method to do common work between adding a joystick and button
function Factory:addObject(name, props, factory)
	if(self.objects[name] ~= nil) then
		error("Name must be unique from other controller pieces")
	end 

	self.objects[name] = factory:createFromProperties(props)

	return self.objects[name]
end

-- Method to display all the parts of the controller on screen
function Factory:displayController(sceneGroup)
	for key, value in pairs(self.objects) do
		value:display(sceneGroup)
	end
end

return Factory