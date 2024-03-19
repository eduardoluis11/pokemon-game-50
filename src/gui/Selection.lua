--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Selection class gives us a list of textual items that link to callbacks;
    this particular implementation only has one dimension of items (vertically),
    but a more robust implementation might include columns as well for a more
    grid-like selection, as seen in many kinds of interfaces and games.

    The Selection class is is the function that renders the hand icon as a cursor for the menus. S, that means that I'll
    need to edit the code of this file, since the hand cursor is being rendered on the Level Up Menu with all the Stat
    Increases. And I DON'T WANT THAT! The hand cursor should NOT be rendered during the Level Up Menu.

    However, the Hand Cursor will be rendered in all Menus. So, just as it is rendered for the Menu that displays the
    "Fight" and "Run" options, it will also be rendered for the Level Up Menu. Therefore, just like the assignment
    suggests, I will create a flag / boolean that detects if the cursor should be rendered or not. I will create a new
    variable called "renderCursor" that will be set to true by default. If I want to render the cursor, I will set it to
    true. If I don't want to render the cursor, I will set it to false. I will set it to false for the Level Up Menu.

    I could temporarily set the "renderCursor" variable to false in the TakeTurnState.lua file right after you Level
    Up. Then, after showing the Level Up Menu, and right before rendering the Overworld, I could turn that boolean
    back to "True".
]]

Selection = Class{}

function Selection:init(def)
    self.items = def.items
    self.x = def.x
    self.y = def.y

    self.height = def.height
    self.width = def.width
    self.font = def.font or gFonts['small']

    self.gapHeight = self.height / #self.items

    self.currentSelection = 1
end


--[[
    This function updates the cursor's position in the menu. I will need to edit this function to render the cursor only
    if the "renderCursor" variable is set to "true". If it is set to "false", the cursor should not be rendered. I will
    set it to "false" for the Level Up Menu.

    In fact, even if the cursor isn't being rendered, this function will play a sound if I press the up or down arrow
    keys. So, I will need to edit this function to play the sound only if the cursor is being rendered. Otherwise,
    in the Level Up Menu, the sound will be played if the player presses the Up or Down arrow keys.

    EDIT LATER.
]]
function Selection:update(dt)
    if love.keyboard.wasPressed('up') then
        if self.currentSelection == 1 then
            self.currentSelection = #self.items
        else
            self.currentSelection = self.currentSelection - 1
        end
        
        gSounds['blip']:stop()
        gSounds['blip']:play()
    elseif love.keyboard.wasPressed('down') then
        if self.currentSelection == #self.items then
            self.currentSelection = 1
        else
            self.currentSelection = self.currentSelection + 1
        end
        
        gSounds['blip']:stop()
        gSounds['blip']:play()
    elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        self.items[self.currentSelection].onSelect()
        
        gSounds['blip']:stop()
        gSounds['blip']:play()
    end
end

--[[
    This function renders the hand icon as a cursor for the menus. So, I will need to edit this function to render the
    cursor only if the "renderCursor" variable is set to "true". If it is set to "false", the cursor should not be
    rendered. I will set it to "false" for the Level Up Menu.


]]
function Selection:render()
    local currentY = self.y

    for i = 1, #self.items do
        local paddedY = currentY + (self.gapHeight / 2) - self.font:getHeight() / 2

        -- draw selection marker if we're at the right index.
        -- That is, this draws the hand icon for the cursor. I NEED TO EDIT THIS FUNCTION TO RENDER THE CURSOR ONLY IF
        -- THE "renderCursor" VARIABLE IS SET TO "TRUE". IF IT IS SET TO "FALSE", THE CURSOR SHOULD NOT BE RENDERED.
        if i == self.currentSelection and renderCursor then
            love.graphics.draw(gTextures['cursor'], self.x - 8, paddedY)
        end

        love.graphics.printf(self.items[i].text, self.x, paddedY, self.width, 'center')

        currentY = currentY + self.gapHeight
    end
end