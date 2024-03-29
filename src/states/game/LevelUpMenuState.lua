--[[
    Level Up Menu State.

    Author: Eduardo Salinas

    This file will create the Menu with all the Stat Increases when you Level Up, in a really similar way in which
    the BattleMenuState{} class renders the "fight" and "run" options.

    REMEMBER THAT I HAD ALREADY CREATED NEW FILES FOR THE ZELDA homework! So, maybe I’ll have to create a new lua file
    for creating a new type of menu, just like Copilot suggested! I could simply copy and paste the BattleMenuState.lua,
    but, instead of “fight” and “run”, I would put ALL of the stat increases!

    I can't change the values for "width" nor "height" if I use VIRTUAL_HEIGHT and VIRTUAL_WIDTH for the x and y
    positions! I need to keep them as 64, 64, because, otherwise, the game will
    get a blue screen error!

    I was able to use another X and Y dimensions for the Level Up Menu other than 64! I needed to eliminate the VIRTUAL
    WIDTH and VIRTUAL HEIGHT constants for the x and y positions. Otherwise, I wouldn’t be able to change the width and
    height of the menu to anything other than 64.

    To make the Level Up Menu disappear after the player hits Enter, I copied and pasted the code from the
    TakeTurnState:fadeOutWhite() function, and I added an extra pop() function to it. This way, the game will go back
    to the overworld after the player hits Enter on the Level Up Menu, as if he had defeated an enemy.

    I simplified the function so that the menu isn't declared here. Instead, all the items and all the text that
    will be printed will be declared on TakeTurnState.lua. Then, I will insert the variable with the menu that
    was declared in TakeTurnState.lua in here to create the menu. So, why am I doing this instead of just directly
    declaring the menu in here? Because the variables with the original stats are only declared in TakeTurnState.lua,
    NOT here. So, if I want to print the original stats, it will be impossible, since this file doesn't have access to
    those values. Only TakeTurnState.lua has the stats before leveling up. That, and some other stats may give me issues
    if I want to access them directly from here. So, I'll take them from TakeTurnState.lua from a variable passed as a
    parameter.

    Next, I will have to re-insert the function that makes the player go back to the overworld after hitting Enter.
]]

LevelUpMenuState = Class{__includes = BaseState}

--function LevelUpMenuState:init(battleState)
function LevelUpMenuState:init(menu)
    self.battleMenu = menu


    --self.battleState = battleState
    --
    --self.battleMenu = Menu {
    --    --x = VIRTUAL_WIDTH - 64,
    --    --y = VIRTUAL_HEIGHT - 64,
    --
    --    -- DON'T ASSIGN VIRTUAL_WIDTH nor VIRTUAL_HEIGHT!
    --    x = 10,
    --    y = 10,
    --
    --    --width = 64,
    --    --height = 64,
    --    width = 200,
    --    height = 200,
    --
    --    -- Text that will be displayed on the menu. This is where the Stat Increases should be printed.
    --    items = {
    --        {
    --            text = 'Hello World!',
    --
    --            -- If the user Presses Enter while the cursor is on this option, the player should go back to the
    --            -- overworld
    --            --onSelect = function()
    --            --    --self:fadeOutWhite()
    --            --    gStateStack:pop()
    --            --    --gStateStack:push(TakeTurnState(self.battleState))
    --            --
    --            --    ---- This should return the player to the overworld, and stop the Victory Music.
    --            --    --gStateStack:push(TakeTurnState:fadeOutWhite())
    --            --end
    --
    --            -- BUGGY: This stops the Victory Music and plays the overworld music, but you're still at the battle
    --            -- Screen.
    --
    --            -- This lets the player to go back to the Overworld after hitting Enter.
    --            onSelect = function()
    --                -- fade in
    --                gStateStack:push(FadeInState({
    --                    r = 1, g = 1, b = 1
    --                }, 1,
    --                function()
    --
    --                    -- resume field music
    --                    -- This stops the Battle music
    --                    gSounds['victory-music']:stop()
    --
    --                    -- This plays the Overworld music
    --                    gSounds['field-music']:play()
    --
    --                    -- pop off the battle state
    --                    -- This eliminates the Battle Screen from the Stack when the fadeOutWhite() function was called.
    --                    gStateStack:pop()
    --
    --                    -- Extra pop() function that I added to make the player go back to the overworld.
    --                    gStateStack:pop()
    --
    --                    -- This inserts a new State to the Stack by using the FadeOutState() function.
    --                    gStateStack:push(FadeOutState({
    --                        r = 1, g = 1, b = 1
    --                    }, 1, function() end))
    --                end))
    --            end -- End of the function that makes the player go back to the overworld after hitting Enter.
    --
    --
    --
    --            --                onSelect = function()
    --            --    gSounds['run']:play()
    --            --
    --            --    -- pop battle menu
    --            --    gStateStack:pop()
    --            --
    --            --    -- show a message saying they successfully ran, then fade in
    --            --    -- and out back to the field automatically
    --            --    gStateStack:push(BattleMessageState('You fled successfully!',
    --            --        function() end), false)
    --            --    Timer.after(0.5, function()
    --            --        gStateStack:push(FadeInState({
    --            --            r = 1, g = 1, b = 1
    --            --        }, 1,
    --            --
    --            --        -- pop message and battle state and add a fade to blend in the field
    --            --        function()
    --            --
    --            --            -- resume field music
    --            --            gSounds['field-music']:play()
    --            --
    --            --            -- pop message state
    --            --            gStateStack:pop()
    --            --
    --            --            -- pop battle state
    --            --            gStateStack:pop()
    --            --
    --            --            gStateStack:push(FadeOutState({
    --            --                r = 1, g = 1, b = 1
    --            --            }, 1, function()
    --            --                -- do nothing after fade out ends
    --            --            end))
    --            --        end))
    --            --    end)
    --            --end
    --        },
    --        {
    --            text = 'This is a Menu!',
    --            onSelect = function()
    --                gSounds['run']:play()
    --
    --                -- pop battle menu
    --                gStateStack:pop()
    --
    --                -- show a message saying they successfully ran, then fade in
    --                -- and out back to the field automatically
    --                gStateStack:push(BattleMessageState('You fled successfully!',
    --                    function() end), false)
    --                Timer.after(0.5, function()
    --                    gStateStack:push(FadeInState({
    --                        r = 1, g = 1, b = 1
    --                    }, 1,
    --
    --                    -- pop message and battle state and add a fade to blend in the field
    --                    function()
    --
    --                        -- resume field music
    --                        gSounds['field-music']:play()
    --
    --                        -- pop message state
    --                        gStateStack:pop()
    --
    --                        -- pop battle state
    --                        gStateStack:pop()
    --
    --                        gStateStack:push(FadeOutState({
    --                            r = 1, g = 1, b = 1
    --                        }, 1, function()
    --                            -- do nothing after fade out ends
    --                        end))
    --                    end))
    --                end)
    --            end
    --        }
    --    }
    --}
end

function LevelUpMenuState:update(dt)
    self.battleMenu:update(dt)
end

function LevelUpMenuState:render()
    self.battleMenu:render()
end