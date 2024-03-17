--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    TakeTurnState file.

    This is probably where most of the work will be done for this homework assignment.
]]

TakeTurnState = Class{__includes = BaseState}

function TakeTurnState:init(battleState)
    self.battleState = battleState
    self.playerPokemon = self.battleState.player.party.pokemon[1]
    self.opponentPokemon = self.battleState.opponent.party.pokemon[1]

    self.playerSprite = self.battleState.playerSprite
    self.opponentSprite = self.battleState.opponentSprite

    -- figure out which pokemon is faster, as they get to attack first
    if self.playerPokemon.speed > self.opponentPokemon.speed then
        self.firstPokemon = self.playerPokemon
        self.secondPokemon = self.opponentPokemon
        self.firstSprite = self.playerSprite
        self.secondSprite = self.opponentSprite
        self.firstBar = self.battleState.playerHealthBar
        self.secondBar = self.battleState.opponentHealthBar
    else
        self.firstPokemon = self.opponentPokemon
        self.secondPokemon = self.playerPokemon
        self.firstSprite = self.opponentSprite
        self.secondSprite = self.playerSprite
        self.firstBar = self.battleState.opponentHealthBar
        self.secondBar = self.battleState.playerHealthBar
    end
end

function TakeTurnState:enter(params)
    self:attack(self.firstPokemon, self.secondPokemon, self.firstSprite, self.secondSprite, self.firstBar, self.secondBar,

    function()

        -- remove the message
        gStateStack:pop()

        -- check to see whether the player or enemy died
        if self:checkDeaths() then
            gStateStack:pop()
            return
        end

        self:attack(self.secondPokemon, self.firstPokemon, self.secondSprite, self.firstSprite, self.secondBar, self.firstBar,
    
        function()

            -- remove the message
            gStateStack:pop()

            -- check to see whether the player or enemy died
            if self:checkDeaths() then 
                gStateStack:pop()
                return
            end

            -- remove the last attack state from the stack
            gStateStack:pop()

            -- DEBUG: This is a test menu that I will print. It will print "Hello World" and "This is a Menu".
            -- ELIMINATE LATER.
            -- IT WORKS, but it's being printed from the 2nd turn and onwards.
            --gStateStack:push(LevelUpMenuState(self.battleState))

            -- This prints the menu with the options "Fight" and "Run" during combat from the 2nd turn and onwards.
            -- REACTIVATE LATER.
            gStateStack:push(BattleMenuState(self.battleState))
        end)
    end)
end

function TakeTurnState:attack(attacker, defender, attackerSprite, defenderSprite, attackerkBar, defenderBar, onEnd)
    
    -- first, push a message saying who's attacking, then flash the attacker
    -- this message is not allowed to take input at first, so it stays on the stack
    -- during the animation
    gStateStack:push(BattleMessageState(attacker.name .. ' attacks ' .. defender.name .. '!',
        function() end, false))

    -- pause for half a second, then play attack animation
    Timer.after(0.5, function()
        
        -- attack sound
        gSounds['powerup']:stop()
        gSounds['powerup']:play()

        -- blink the attacker sprite three times (turn on and off blinking 6 times)
        Timer.every(0.1, function()
            attackerSprite.blinking = not attackerSprite.blinking
        end)
        :limit(6)
        :finish(function()
            
            -- after finishing the blink, play a hit sound and flash the opacity of
            -- the defender a few times
            gSounds['hit']:stop()
            gSounds['hit']:play()

            Timer.every(0.1, function()
                defenderSprite.opacity = defenderSprite.opacity == 64/255 and 1 or 64/255
            end)
            :limit(6)
            :finish(function()
                
                -- shrink the defender's health bar over half a second, doing at least 1 dmg
                local dmg = math.max(1, attacker.attack - defender.defense)
                
                Timer.tween(0.5, {
                    [defenderBar] = {value = defender.currentHP - dmg}
                })
                :finish(function()
                    defender.currentHP = defender.currentHP - dmg
                    onEnd()
                end)
            end)
        end)
    end)
end

function TakeTurnState:checkDeaths()
    if self.playerPokemon.currentHP <= 0 then
        self:faint()
        return true
    elseif self.opponentPokemon.currentHP <= 0 then
        self:victory()
        return true
    end

    return false
end

--[[
    This function is called when you get a Game Over (if your pokemon faints). It will drop the player's sprite down
    below the window, and then push a State to the stack with a Game Over message saying "You fainted!".
]]
function TakeTurnState:faint()

    -- drop player sprite down below the window
    Timer.tween(0.2, {
        [self.playerSprite] = {y = VIRTUAL_HEIGHT}
    })
    :finish(function()
        
        -- when finished, push a loss message
        gStateStack:push(BattleMessageState('You fainted!',
    
        function()

            -- fade in black
            gStateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()
                
                -- restore player pokemon to full health
                self.playerPokemon.currentHP = self.playerPokemon.HP

                -- resume field music
                gSounds['battle-music']:stop()
                gSounds['field-music']:play()
                
                -- pop off the battle state and back into the field
                gStateStack:pop()
                gStateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1, function() 
                    gStateStack:push(DialogueState('Your Pokemon has been fully restored; try again!'))
                end))
            end))
        end))
    end)
end

--[[
    This function is called when you win a battle. It will drop the enemy's sprite down below the window, and then push
    a State to the stack with a Victory message saying "Victory!".

    This is where I'll put most of the work and most of the code.

    To render a message that should wait until the user presses "Enter" to go to the next message, I'll have to put a
    snippet like this:
        gStateStack:push(BattleMessageState('First Message',

        function()

            gStateStack:push(BattleMessageState('Second Message',

            function()

    The "function()" snippet will for the user to press "Enter" to go to the next message. I will have to insert
    EVERYTHING in the code that comes after the first message inside of the "function()" snippet so that everything
    after the first message is executed ONLY AFTER PRESSING "Enter". Then, I want EVERYTHING that should be executed
    after the second message to be inside of the "function()" snippet that comes after the second message, and so on.

    Now, let me try printing “Hello World” ONLY after gaining experience. Then, you need to press “Enter” during the
    “Hello World 2” screen to go back to the Overworld. I GOT IT! After obtaining EXP, I got the “Hello World!” message,
    and it’s waiting for me to press Enter!

    Now, let me try printing “Hello World” ONLY after leveling up. I will make the player wait until the player hits
    "Enter" to go from the “Hello World” to the Overworld after leveling up.

    What I could do  is to create a boolean, which will be activated each time that you level up, and which will be
    deactivated after you go back to the overworld. This boolean will say something like “print Stat Increases”. That
    way, the statsLevelUp() function would only be called only if the player levels up. That is, it wouldn't be printed
    right at the beginning of the game, nor it would be printed for an enemy. Also, since I will deactivate it right
    after returning to the overworld, I won’t print the stats for the enemy pokemon at the start of the next random
    encounter. That is, I would only print the stat increases for the player pokemon, and ONLY right after they level
    up.

    To print the stat increases from the global variables from statLevelUp() when you level up, I will execute a
    function that would look like this:
        gStateStack:push(BattleMessageState('PRINT STAT INCREASES HERE. That is, Global HP increase is' +
        globalHPIncrease + ‘ and so on and so forth’,
            function()
            printStatIncrease = false

           self:fadeOutWhite()
        end))
    First, I will try to print in the console the initial values of the stats of the player pokemon BEFORE leveling up
    by using the “self.playerPokemon.name_of_the_stat” notation.

    Next, I will try to add the initial stat and the stat increase in the dialogue box, as well as showing the resulting
    stat after leveling up.

    I need to store somewhere the stat BEFORE leveling up, and then print that variable with that starting stat on the
    dialog box. I could also add a “,” to separate each stat being increased. So, before calling the levelUp() function,
    I will use the self.playerPokemon.name_of_the_stat to store the initial stats for the player Pokemon BEFORE leveling
    up.

    Then,, while printing the resulting stats, I will print the initial stat and the stat increase this way:
        "Stat = Starting stat + stat increase"

    Afterwards, I need to print the sum of the starting stat plus the stat increase. However, I DON'T EVEN NEED TO MAKE
    A CALCULATION. I don't need to use the "+" sign. Where is the value of the stat after leveling up of the player
    pokemon being stored?. In self.playerPokemon.name_of_the_stat AFTER calling the levelUp() function! So, I will use
    the self.playerPokemon.name_of_the_stat notation to print the resulting stats for the player Pokemon as the sum
    of the initial stat and the stat increase, without actually even needing to make a calculation. That is,
    I will use the following notation:
        Stat: initial_stat + stat_increase = self.playerPokemon.name_of_the_stat
]]
function TakeTurnState:victory()

    -- drop enemy sprite down below the window
    Timer.tween(0.2, {
        [self.opponentSprite] = {y = VIRTUAL_HEIGHT}
    })
    :finish(function()
        -- play victory music
        gSounds['battle-music']:stop()

        gSounds['victory-music']:setLooping(true)
        gSounds['victory-music']:play()

        -- DEBUG: Remove the last state from the stack.
        -- The good thing is that, by leaving this, the game won't hard-locked, and I'll be able to transition into the
        -- Overworld. The bad thing is that, before printing "Victory", I will be back to the Overworld.
        --gStateStack:pop()

        -- -- DEBUG: This should print "Hello World!" before printing "Victory!". It should wait for the user to hit
        -- -- "Enter" before going to the "Victory!" message. THIS DIDN'T WORK.
        --gStateStack:push(BattleMessageState('Hello World!', function() end))

        -- IF I Don't put this, I WILL GET A "Hello World" message while transitioning to the overworld, and the
        -- overworld music will play in the background while the game is hard-locked. This is not supposed to happen.
        -- -- DEBUG: This should remove the "Hello World!" message so that, later, the user will print "Victory!"
        --gStateStack:pop()

        -- when finished, push a victory message
        gStateStack:push(BattleMessageState('Victory!',

        -- DEBUG: This function should print "Hello World!" before printing "You've earned EXP". It should wait for the
        -- user to hit "Enter" before going to the "You've earned EXP" message. IT WORKED.
        function()

            gStateStack:push(BattleMessageState('Hello World!',

            function()

                ---- sum all IVs and multiply by level to get exp amount.
                ---- This is is the total EXP that you will get. THIS EXP WON'T BE GIVEN TO THE PLAYER YET!
                ---- REACTIVATE LATER
                --local exp = (self.opponentPokemon.HPIV + self.opponentPokemon.attackIV +
                --        self.opponentPokemon.defenseIV + self.opponentPokemon.speedIV) * self.opponentPokemon.level

                -- DEBUG: I will give a ton of EXP to the player after each battle to make the player level up quickly.
                -- ELIMINATE LATER.
                local exp = 300

                gStateStack:push(BattleMessageState('You earned ' .. tostring(exp) .. ' experience points!',
                        function() end, false))

                -- DEBUG: This will print a menu saying "Hello World" before the "Level Up" message
                -- (Source: Copilot).
                -- BUG: The "Hello World" message is printed after receiving the experience points, but the game hard-locks
                -- on the Battle Results screen with an empty text box, whiel the overworld music plays in the background.
                -- This is supposed to transition the game from the Battle Screen into the Overworld. IT DIDN'T WORK.
                -- (Source: Copilot).
                -- gStateStack:push(BattleMessageState('Hello World', function() self:fadeOutWhite() end, false))
                -- -- pop exp message off
                --gStateStack:pop()

                -- Tweening animation showing the EXP bar filling up with EXP (like in modern Pokemon Games)
                Timer.after(1.5, function()
                    gSounds['exp']:play()

                    -- animate the exp filling up.
                    -- THIS IS THE CALCULATION THAT GIVES THE POKEMON THE EXP! The exp given will be the one calculated in
                    -- the snippet above ("local exp").
                    Timer.tween(0.5, {
                        [self.battleState.playerExpBar] = {value = math.min(self.playerPokemon.currentExp + exp, self.playerPokemon.expToLevel)}
                    })
                         :finish(function()

                        -- pop exp message off
                        gStateStack:pop()

                        self.playerPokemon.currentExp = self.playerPokemon.currentExp + exp

                        -- level up if we've gone over the needed amount.
                        -- This is probably where I will have to put most of the work, since the homework only requires
                        -- me to execute some code when the player levels up.
                        if self.playerPokemon.currentExp > self.playerPokemon.expToLevel then

                            gSounds['levelup']:play()

                            -- set our exp to whatever the overlap is
                            self.playerPokemon.currentExp = self.playerPokemon.currentExp - self.playerPokemon.expToLevel

                            -- Right before calling the levelUp() function, I will activate a Boolean to print the stat
                            -- increases in the console. This is for DEBUGGING PURPOSES for the time being.
                            printStatIncrease = true

                            -- DEBUG: This will print the current stats for the Player Pokemon BEFORE leveling up.
                            print("These are the stats for the Player Pokemon BEFORE leveling up:")
                            print("HP: " .. self.playerPokemon.HP .. " Attack: " .. self.playerPokemon.attack .. " Defense: " .. self.playerPokemon.defense .. " Speed: " .. self.playerPokemon.speed)

                            -- This will store the initial stats for the Player Pokemon BEFORE leveling up.
                            -- I will use these to calculate the resulting stats after leveling up.
                            local initialHP = self.playerPokemon.HP
                            local initialAttack = self.playerPokemon.attack
                            local initialDefense = self.playerPokemon.defense
                            local initialSpeed = self.playerPokemon.speed

                            -- This calls the levelUp() function from src/Pokemon.lua, which is the back-end that handles
                            -- how many points are allocated into each stat when you level up.
                            self.playerPokemon:levelUp()

                            -- Probably this is where I'll need to type a snippet that gets the stats from the levelUp()
                            -- function, and then displays them in a message in the front-end in the Battle Results screen.


                            -- This prints the message "Level Up!", and then, automatically, sends you to the overworld.
                            gStateStack:push(BattleMessageState('Congratulations! Level Up!',

                                    function()

                                            -- DEBUG: This should print "Hello World" after printing "Level Up". It
                                            -- should wait for the user to hit "Enter" before going to the Overworld. IT
                                            -- WORKED.
                                            --gStateStack:push(BattleMessageState('Hello World after leveling up',

                                            -- Menu that will show the Stat Increases. This won't be printed yet. I'm
                                            -- just declaring the menu and its text here (source: Copilot).
                                            local statsMenu = Menu {
                                                x = 10,
                                                y = 10,
                                                width = 200,
                                                height = 200,
                                                items = {
                                                    { text = "HP: " .. initialHP .. ' + ' .. globalHPIncrease .. ' = ' .. self.playerPokemon.HP, onSelect = function() end },
                                                    { text = "Attack: " .. initialAttack .. ' + ' .. globalAttackIncrease .. ' = ' .. self.playerPokemon.attack, onSelect = function() end },
                                                    { text = "Defense: " .. initialDefense .. ' + ' .. globalDefenseIncrease .. ' = ' .. self.playerPokemon.defense, onSelect = function() end },
                                                    { text = "Speed: " .. initialSpeed .. ' + ' .. globalSpeedIncrease .. ' = ' .. self.playerPokemon.speed, onSelect = function() end }
                                                }
                                            }

                                            -- This will print each stat increase from Global Variables, and I will
                                            -- try to add all the stats and show the resulting stat after leveling up.
                                            --gStateStack:push(BattleMessageState("HP: " .. self.playerPokemon.HP .. ' + ' .. globalHPIncrease .. ' = ' .. (self.playerPokemon.HP + globalHPIncrease) .. " Attack: " .. globalAttackIncrease .. " Defense: " .. globalDefenseIncrease .. " Speed: " .. globalSpeedIncrease,
                                            -- This was supposed to render the menu, BUT DIDNT WORK.
                                            --gStateStack:push(BattleMessageState(statsMenu,
                                            --gStateStack:push(BattleMessageState("HP: " .. initialHP .. ' + ' .. globalHPIncrease .. ' = ' .. self.playerPokemon.HP .. ", Attack: " .. initialAttack .. ' + ' .. globalAttackIncrease .. ' = ' .. self.playerPokemon.attack .. ", Defense: " .. initialDefense .. ' + ' .. globalDefenseIncrease .. ' = ' .. self.playerPokemon.defense .. ", Speed: " .. initialSpeed .. ' + ' .. globalSpeedIncrease .. ' = ' .. self.playerPokemon.speed,

                                            -- This prints my Custom Menu.
                                            -- BUGGY: If I press Enter during this menu, my Pokemon will attack again,
                                            -- and I will earn experience one more time. I will never go back to the
                                            -- overworld!
                                            --gStateStack:push(LevelUpMenuState(self.battleState,

                                            -- This inserts the previously declared menu, and inserts it into a new
                                            -- instance of the LevelUpMenuState{} class. This way, I'll create the Menu
                                            -- that will print all the stat increases.
                                            gStateStack:push(LevelUpMenuState(statsMenu,
                                            function()

                                                -- This will deactivate the Boolean that prints the stat increases in
                                                -- the console so that it doesn't print the enemy's stats on the next
                                                -- random encounter.
                                                printStatIncrease = false

                                                -- This should fade the screen to white and return the player to the
                                                -- overworld.
                                                self:fadeOutWhite()

                                            end))
                                            -- End of the DEBUG "Hello World" message that shows up after the "Lvl Up"
                                            -- message.


                                    end))

                            -- This executes if the player didn't level up at the end of a battle.
                            -- This should fade the screen to white and return the player to the overworld.
                        else


                            -- This prints “Hello World” ONLY after gaining EXP. Then, you need to press “Enter” during
                            -- this new “Hello World” screen to go back to the Overworld. IT WORKED
                            gStateStack:push(BattleMessageState('Hello World 2!',

                            function()
                                self:fadeOutWhite()

                            end))   -- End of the "Hello World" message that shows up after the "EXP" message.


                        end -- End of the snippet where I'll have to put most of the work.

                    end)
                end)    -- End of the Tweening EXP animation

            end)) -- DEBUG: End of the "Hello World" message
        end))
    end)
end

function TakeTurnState:fadeOutWhite()
    -- fade in
    gStateStack:push(FadeInState({
        r = 1, g = 1, b = 1
    }, 1, 
    function()

        -- resume field music
        -- This stops the Battle music
        gSounds['victory-music']:stop()

        -- This plays the Overworld music
        gSounds['field-music']:play()
        
        -- pop off the battle state
        -- This eliminates the Battle Screen from the Stack when the fadeOutWhite() function was called.
        gStateStack:pop()

        -- This inserts a new State to the Stack by using the FadeOutState() function.
        gStateStack:push(FadeOutState({
            r = 1, g = 1, b = 1
        }, 1, function() end))
    end))
end