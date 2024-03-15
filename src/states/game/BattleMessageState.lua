--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

BattleMessageState = Class{__includes = BaseState}


--[[    BattleMessageState's init() function.

    The BattleMessageState is a simple state used to display a message to the player
    in the middle of a battle. It's used to display messages like "Player has fainted!"
    or "Player has used an item!" or "Player has gained experience!" etc.

    The message is passed in as a parameter to the state, as well as a callback function
    to be called once this message is popped. This is useful for things like gaining
    experience, where we want to wait for the message to be closed before we actually
    apply the experience gained.

    The canInput parameter is a boolean that determines whether the player can
    interact with the game during this message. This is useful for things like
    "Player has fainted!" where we want to wait for the message to be closed before
    we actually apply the fainting logic.

    The canInput parameter is optional, and defaults to "true" if nothing is passed in.
]]
function BattleMessageState:init(msg, onClose, canInput)

    -- Text message that will be shown in the dialog box
    self.textbox = Textbox(0, VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH, 64, msg, gFonts['medium'])

    -- function to be called once this message is popped.
    -- This will play either the function that was passed as the 2nd parameter, or an empty function
    self.onClose = onClose or function() end

    -- whether we can detect input with this or not; true by default.
    -- This won't let the player to press any keys / buttons while the message is being shown if it's "false".
    self.canInput = canInput

    -- default input to "true" if nothing was passed in.
    -- This will only be "false" if "false" is explicitly passed as the 3rd parameter.
    if self.canInput == nil then self.canInput = true end
end

function BattleMessageState:update(dt)
    if self.canInput then
        self.textbox:update(dt)

        if self.textbox:isClosed() then
            gStateStack:pop()
            self.onClose()
        end
    end
end

function BattleMessageState:render()
    self.textbox:render()
end