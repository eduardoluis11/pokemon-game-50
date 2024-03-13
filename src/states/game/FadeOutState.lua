--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

FadeOutState = Class{__includes = BaseState}

--[[ FadeOutState's init() function.

The FadeOutState makes the screen to go from a solid color to transparent. It's used to transition from one Screen of
 a State from the Stack to another. That's why the opacity goes from 1 to 0.

The onFadeComplete() function is not a Love2D function. It's a custom-made function. This function is apparently called
 when going from the battle screen to the overworld. By the way, the onFadeComplete() function is not created on this
 file: it's was created on another file somewhere else in the project.

The onFadeComplete variable is just a parameter passed to the FadeOutState's init() function. That parameter is a
function. If the FadeOutState() is called, you need to pass 3 parameters to it. Well, the 3rd parameter will be a
function. Any function. That's what the onFadeComplete parameter is.

The first 2 parameters are a color, and a time (in seconds).

]]
function FadeOutState:init(color, time, onFadeComplete)
    self.opacity = 1
    self.r = color.r
    self.g = color.g
    self.b = color.b
    self.time = time

    Timer.tween(self.time, {
        [self] = {opacity = 0}
    })
    :finish(function()
        gStateStack:pop()
        onFadeComplete()
    end)
end

function FadeOutState:update(dt)

end

function FadeOutState:render()
    love.graphics.setColor(self.r, self.g, self.b, self.opacity)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
end