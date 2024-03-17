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
]]

LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(battleState)
    self.battleState = battleState
    
    self.battleMenu = Menu {
        --x = VIRTUAL_WIDTH - 64,
        --y = VIRTUAL_HEIGHT - 64,

        -- DON'T ASSIGN VIRTUAL_WIDTH nor VIRTUAL_HEIGHT!
        x = 10,
        y = 10,

        --width = 64,
        --height = 64,
        width = 200,
        height = 200,

        items = {
            {
                text = 'Hello World!',
                onSelect = function()
                    gStateStack:pop()
                    gStateStack:push(TakeTurnState(self.battleState))
                end
            },
            {
                text = 'This is a Menu!',
                onSelect = function()
                    gSounds['run']:play()
                    
                    -- pop battle menu
                    gStateStack:pop()

                    -- show a message saying they successfully ran, then fade in
                    -- and out back to the field automatically
                    gStateStack:push(BattleMessageState('You fled successfully!',
                        function() end), false)
                    Timer.after(0.5, function()
                        gStateStack:push(FadeInState({
                            r = 1, g = 1, b = 1
                        }, 1,
                        
                        -- pop message and battle state and add a fade to blend in the field
                        function()

                            -- resume field music
                            gSounds['field-music']:play()

                            -- pop message state
                            gStateStack:pop()

                            -- pop battle state
                            gStateStack:pop()

                            gStateStack:push(FadeOutState({
                                r = 1, g = 1, b = 1
                            }, 1, function()
                                -- do nothing after fade out ends
                            end))
                        end))
                    end)
                end
            }
        }
    }
end

function LevelUpMenuState:update(dt)
    self.battleMenu:update(dt)
end

function LevelUpMenuState:render()
    self.battleMenu:render()
end