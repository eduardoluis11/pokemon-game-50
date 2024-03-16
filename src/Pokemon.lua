--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Pokemon = Class{}

function Pokemon:init(def, level)
    self.name = def.name

    self.battleSpriteFront = def.battleSpriteFront
    self.battleSpriteBack = def.battleSpriteBack

    self.baseHP = def.baseHP
    self.baseAttack = def.baseAttack
    self.baseDefense = def.baseDefense
    self.baseSpeed = def.baseSpeed

    self.HPIV = def.HPIV
    self.attackIV = def.attackIV
    self.defenseIV = def.defenseIV
    self.speedIV = def.speedIV

    self.HP = self.baseHP
    self.attack = self.baseAttack
    self.defense = self.baseDefense
    self.speed = self.baseSpeed

    self.level = level
    self.currentExp = 0
    self.expToLevel = self.level * self.level * 5 * 0.75

    self:calculateStats()

    self.currentHP = self.HP
end

function Pokemon:calculateStats()
    for i = 1, self.level do
        self:statsLevelUp()
    end
end

function Pokemon.getRandomDef()
    return POKEMON_DEFS[POKEMON_IDS[math.random(#POKEMON_IDS)]]
end

--[[ Level up function. This increases each of the stats of a Pokemon when you level up. THIS IS AN IMPORTANT PART
    OF THE HOMEWORK ASSIGNMENT, since this is the back-end of what I want to print on the level-up screen. That is,
    this is the back-end to what I want to show in the front-end.


    Takes the IV (individual value) for each stat into consideration and rolls
    the dice 3 times to see if that number is less than or equal to the IV (capped at 5).
    The dice is capped at 6 just so no stat ever increases by 3 each time, but
    higher IVs will on average give higher stat increases per level. Returns all of
    the increases so they can be displayed in the TakeTurnState on level up.

    I will use a boolean / flag to tell the game whether to print the player Pokemon's stat increases. It will be
    initially set to "false" to prevent the statsLevelUp() function from printing the Player Pokemon's stats right at
    the beginning of the game, and to prevent the statsLevelUp() function from printing the enemy Pokemon's stats right
    at the beginning of a random encounter.
]]
function Pokemon:statsLevelUp()

    -- First, we declare the variable that will store the HP increase. It starts as 0.
    local HPIncrease = 0

    -- Then, we roll the dice 3 times to see if that number is less than or equal to the HP IV (capped at 5).
    -- This will sometimes increase the HP by 1.
    for j = 1, 3 do
        if math.random(6) <= self.HPIV then
            self.HP = self.HP + 1
            HPIncrease = HPIncrease + 1
        end
    end

    -- Same as the HP, but with the Attack Points: it starts as 0, but may increase by at least 1 point.
    local attackIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.attackIV then
            self.attack = self.attack + 1
            attackIncrease = attackIncrease + 1
        end
    end

    -- Defense Increase
    local defenseIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.defenseIV then
            self.defense = self.defense + 1
            defenseIncrease = defenseIncrease + 1
        end
    end

    -- Speed Increase
    local speedIncrease = 0

    for j = 1, 3 do
        if math.random(6) <= self.speedIV then
            self.speed = self.speed + 1
            speedIncrease = speedIncrease + 1
        end
    end

    -- DEBUG: This will print each stat increases on the console. I will only print it if the printStatIncrease flag
    -- is true. This way, only the player Pokemon stat increases will be printed on the console, and only when they
    -- level up.
    -- IT'S also printing the stats for the enemy pokemon during every new random encounter, WHICH IS NOT WHAT I WANT.
    if printStatIncrease then
        print("HP: " .. HPIncrease .. " Attack: " .. attackIncrease .. " Defense: " .. defenseIncrease .. " Speed: " .. speedIncrease)
    end

    return HPIncrease, attackIncrease, defenseIncrease, speedIncrease
end

function Pokemon:levelUp()
    self.level = self.level + 1
    self.expToLevel = self.level * self.level * 5 * 0.75

    return self:statsLevelUp()
end