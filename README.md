# pokemon-game-50
This is my submission for my "Pokemon" homework assignment from Harvard's CS50's Introduction to Game Development course. This submission was done by Eduardo Salinas.

## Notes

### Bing AI's Chat disclaimer

I, Eduardo Salinas, generated the references for this homework assignment in APA format in the "References" section of this README file using Bing AI's chat from bing.com. Upon generating draft language, I reviewed, edited, and revised the language to my own liking, and I take ultimate responsibility for the content of this text. I did not use an app to generate this citation other than Bing's AI web app. I copied the text from Bing's chat, pasted it on a text editor, and then edited it.

### Bug: can't run away from battle
Sometimes, when the player tries to run away from a battle, the game will crash. This bug was already present in the game's original source code from the course's repo, and I couldn't fix it.

### Use of GitHub Copilot
I'm paying for GitHub Copilot's Individual Subscription, which generated some of my code. I will add all the instructions that I gave to Copilot that generated my code in the "References" section of this README file.

### Code generated by GitHub Copilot
I saved all the code generated by the Copilot Chat that I used in my project in a file called "copilot-chat-and-prompts.txt". All the Copilot code that I used that's being cited on my references can be found in that .txt file. 


## References 

1. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 10). "/explain Explain what this snippet does. I'm making a game in Lua and Love2D which is a clone of Pokemon. This snippet handles the leveling up of the Pokemon (the player) when they earn enough experience points. Well, tell me in more detail how this snippet works." Attached `TakeTurnState.lua` and `main.lua` files. Accessed on March 10th, 2024.

2. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 12). "The snippet that I'm selecting is like the front-end of a menu that shows up when you level up in this Pokemon-like game. Well, below the `self.playerPokemon:levelUp()` snippet, create a new menu that prints a message that says 'Hello World'. To do that, it seems that you'll have to insert the message into the State Stack. To do that, it seems that you'll have to use a snippet like the following: `gStateStack:push(MessageState('Hello World'))`. I don't know if that specific snippet will work, but I think it needs to be in around that format." Attached `TakeTurnState.lua` and `Pokemon.lua` files. Accessed on March 12th, 2024.

3. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 12). "/fix With my current iteration of the code, the message 'Hello World' is printed after the screen that says that you've earned experience points. HOWEVER, the game gets hard-locked after I hit Enter after the screen that says 'Hello World' shows up. Please, make the game be playable once again after you hit Enter on 'Hello World'. That is, the player should exit the 'Battle Scene' and go back to the overworld." Attached `TakeTurnState.lua` and `Pokemon.lua` files. Accessed on March 12th, 2024.

4. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 13). "/explain what does the `onFadeComplete()` function do? Also, is it a Love2D function, or is it a custom function created for this source code?" Highlighted line 23 from the `FadeOutState.lua` file. Attached `FadeOutState.lua` file. Accessed on March 13th, 2024.

5. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 13). "Can you pinpoint the file in the project where the `onFadeComplete()` function was first declared?" Attached `FadeOutState.lua` file. Accessed on March 13th, 2024.

6. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 13). "/explain Please explain what the `init()` function of the `FadeOutState()` function does. Also, I think I get it: 'onFadeComplete' is just a parameter created specifically for the `init()` function of the `FadeOutState()` function in `FadeOutState.lua`? That is, it's just a variable that only exists as a parameter for the `init()` function of the `FadeOutState()` function?" Highlighted lines 23-37 from the `FadeOutState.lua` file. Attached `FadeOutState.lua` file. Accessed on March 13th, 2024.

7. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 13). "/explain Thanks, now please, tell me more about what the `gStateStack()` function does. Also, can you pinpoint the first file in which the `gStateStack()` was initially created?" Highlighted lines 46-77 from the `TakeTurnState.lua` file. Attached `TakeTurnState.lua` file. Accessed on March 13th, 2024.

8. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 14). "/explain What does this function do? Explain in detail how this function works." Highlighted lines 11-22 from the `BattleMessageState.lua` file. Attached `BattleMessageState.lua` file. Accessed on March 14th, 2024.

9. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 16). "Edit the line of code that says `gStateStack:push(BattleMessageState("HP: " .. self.playerPokemon.HP .. ' + ' .. globalHPIncrease .. ' = ' .. (self.playerPokemon.HP + globalHPIncrease) .. " Attack: " .. globalAttackIncrease .. " Defense: " .. globalDefenseIncrease .. " Speed: " .. globalSpeedIncrease, ". Modify it so that it takes the initial stats (such as `self.playerPokemon.HP`) BEFORE the `levelUp()` function is called. The reason for this is that, after the `levelUp()` function is called, the initial stat (like `self.playerPokemon.HP`) will have increased, and I want that stat BEFORE the increase. Then, after you store in a variable the initial value of that starting stat, insert it into the line of code that shows the stat increases in `self.playerPokemon.name_of_stat`. That way, all the stats will be correctly added and calculated, and will print properly on the game. As it is, the starting stat is adding the stat increase twice, since the stat increase is already added to the initial stat after the `levelUp()` function is called. So, fix this." Highlighted lines 320-346 from the `TakeTurnState.lua` file. Accessed on March 16th, 2024.

10. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 16). "Modify the selected snippet so that it displays all that text on a menu. To create a menu, you need to create an instance of the `Menu{}` class. Here's the `init()` function of the `Menu{}` class: `function Menu:init(def) self.panel = Panel(def.x, def.y, def.width, def.height) self.selection = Selection { items = def.items, x = def.x, y = def.y, width = def.width, height = def.height } end`. So, using these pieces of data, create a menu within the `gStateStack:push()` function." Highlighted line 385 from the `TakeTurnState.lua` file. Attached `TakeTurnState.lua` and `Menu.lua` files. Accessed on March 16th, 2024.

11. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 16). "The cod that you gave me didn't work. Just when I was about to display the menu, the game didn't render the menu, and the game got hard-locked in the battle screen. Please, take this code that I'm highlighting as a reference, since the '--remove the last attack state from the stack' snippet of 2 lines shows a menu that is similar to the menu that I want to display." Highlighted lines 41-73 from the `TakeTurnState.lua` file. Attached `TakeTurnState.lua`, `Menu.lua`, and `BattleMenuState.lua` files. Accessed on March 16th, 2024.

12. - GitHub's Copilot Chat. (2024, March 17). "/explain Explain how the `Menu{}` class works, and tell me how the `BattleMenuState{}` class uses the `Menu{}` class. Here's the code for the `Menu{}` class: `Menu = Class{} function Menu:init(def) self.panel = Panel(def.x, def.y, def.width, def.height) self.selection = Selection { items = def.items, x = def.x, y = def.y, width = def.width, height = def.height } end`." Highlighted lines 9-67 from the `BattleMenuState.lua` file. Attached `Menu.lua` and `BattleMenuState.lua` files. Accessed on March 17th, 2024.

13. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 17). "Edit the following menu so that, no matter which item is selected, the function that will be executed when 'onSelect' is the one in the highlighted snippet: `local statsMenu = Menu { x = 10, y = 10, width = 200, height = 200, items = { { text = 'HP: ' .. initialHP .. ' + ' .. globalHPIncrease .. ' = ' .. self.playerPokemon.HP, onSelect = function() end }, { text = 'Attack: ' .. initialAttack .. ' + ' .. globalAttackIncrease .. ' = ' .. self.playerPokemon.attack, onSelect = function() end }, { text = 'Defense: ' .. initialDefense .. ' + ' .. globalDefenseIncrease .. ' = ' .. self.playerPokemon.defense, onSelect = function() end }, { text = 'Speed: ' .. initialSpeed .. ' + ' .. globalSpeedIncrease .. ' = ' .. self.playerPokemon.speed, onSelect = function() end } } }`." Highlighted lines 78-105 from the `LevelUpMenuState.lua` file. Attached `LevelUpMenuState.lua` file. Accessed on March 17th, 2024.

14. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 17). "What you said works, but isn't there a more efficient way of executing the same function for any of the items selected? I mean, you're repeating the same chunk of code for the function for each item." Attached `LevelUpMenuState.lua` file. Accessed on March 17th, 2024.

15. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 19). "Tell me what this entire file does." Attached `Selection.lua` file. Accessed on March 19th, 2024.

16. - GitHub's Copilot Chat in PyCharm: Professional Edition. (2024, March 19). "Hold on, did you say that the `render()` function renders the cursor right next to the item? Tell me the exact snippet in the highlighted code that renders the hand icon for the cursor." Highlighted lines 90-107 from the `Selection.lua` file. Accessed on March 19th, 2024.