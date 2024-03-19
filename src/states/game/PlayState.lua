--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayState = Class{__includes = BaseState}


--[[
    PlayState's init function.

    This is called only once, when we first enter the state.
    This is where we should set up the level, the player, and any other variables we need for the level.

    Here, I will declare the Boolean / flag that will tell the game whether to print the player Pokemon's stats. It
    will be initially set to "false" to prevent the statsLevelUp() function from printing the Player Pokemon's stats
    right at the beginning of the game.

    What I could do  is to create a boolean, which will be activated each time that you level up, and which will be
    deactivated after you go back to the overworld. This boolean will say something like “print Stat Increases”. That
    way, the statsLevelUp() function would only be called only if the player levels up. That is, it wouldn't be printed
    right at the beginning of the game, nor it would be printed for an enemy. Also, since I will deactivate it right
    after returning to the overworld, I won’t print the stats for the enemy pokemon at the start of the next random
    encounter. That is, I would only print the stat increases for the player pokemon, and ONLY right after they level
    up.

	Also, notice that the stats are always numbers less than or equal to 3. That is, they must be the stat increases,
	NOT the total stats for each stat (that is, if anoleaf has 7 HP, “7” is never printed on the console. Only “2”,
	“2”, “3”). So, that’s good! The stat increases are being printed! The problem is that, to create the player pokemon
	at the beginning of the game, the game executed the “level up” function like 5 times. Then, when you encounter an
	enemy, the levelUp() function is called like 4 times. That’s why the statLevelUp() function is being called right
	at the beginning of the game, and at the beginning of a random encounter.

    I will also declare the boolean that will determine whether to render the hand cursor for the Menus. It will be
    "true" by default.
]]
function PlayState:init()
    self.level = Level()

    gSounds['field-music']:setLooping(true)
    gSounds['field-music']:play()

    self.dialogueOpened = false

    -- This boolean will tell whether to print the Pokemon's stats or not. It will be initially set to "false".
    printStatIncrease = false

    -- This boolean will determine whether to render the hand cursor for the Menus. It wil be "true" by default.
    renderCursor = true

end

function PlayState:update(dt)
    if not self.dialogueOpened and love.keyboard.wasPressed('p') then
        
        -- heal player pokemon
        gSounds['heal']:play()
        self.level.player.party.pokemon[1].currentHP = self.level.player.party.pokemon[1].HP
        
        -- show a dialogue for it, allowing us to do so again when closed
        gStateStack:push(DialogueState('Your Pokemon has been healed!',
    
        function()
            self.dialogueOpened = false
        end))
    end

    self.level:update(dt)
end

function PlayState:render()
    self.level:render()
end