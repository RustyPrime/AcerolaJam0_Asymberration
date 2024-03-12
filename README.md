# Asymberration

## Description
Fight your way through a limitless amount of aberrations while solving a series of mini-challanges.
In the 2 person LAN-Multiplayer mode the adversary must strategically place enemies in your way and stop you from reaching your goal.

The player that is hosting the game will be the player on the ground.

## Controls
### Ground Player / Host
W, A, S, D to move

Mouse to look around

Left-Click to shoot

E or F to interact

Shift to run

ESC to release mouse

Left or right click to capture mouse

And an unspecified way to invert gravity

### Overview Player
Hold left click to drag and drop enemies from the bottom right corner into the building

## Creation
Entry for Acerola's Jam 0 

Read more here: https://itch.io/jam/acerola-jam-0

## Theme
Aberration

ab·er·ra·tion

/ˌabəˈrāSH(ə)n/

a departure from what is normal, usual, or expected, typically one that is unwelcome. 

## Software used to make this game
- Godot Engine 4.2.1
- Cyclops Level Builder Plugin for Godot
- VS Code
- Blender
- Audacity
- https://sfxr.me
- Gimp
- Github & Fork
- XMind
- Paint
- Pixelate Shader from https://godotshaders.com/shader/pixelate/
- Notepad++

## Concept
![Concept Art](https://github.com/RustyPrime/AcerolaGameJam0_Aberration_Asymmetric/blob/main/.docs/conceptArt.png)
Early concept art, illustrating that Player 1 gets to move around in some building while Player 2 has an overview of that space and able to drop in aberrations for the ground player to fight.

## Play via Internet
Due to the time constrain i wasn't able to be build a fully fleshed out dedicated server (which would also allow web-users to use the multiplayer), however apart from playing in a LAN with the windows version you could also play together remotely using a service like Hamachi.

The host has to disable their windows firewall though (or more appropriately allow the selected port, e.g. 27015).

## Fun Fact
The shotgun spray is not actually fully random. It is more likely that the pellets will launch towards the center than to spread out. 

This is done by rotating the right vector around the forward vector by a random angle which has a uniform chance (every degree is equally likely). Then a random distance is calculated that determines the spread distance. To achieve the less randomness there is a 80% chance for the random distance to be rerolled into something smaller when the first roll was deamed to high.

This can be seen here: [Calculating the angle](https://github.com/RustyPrime/AcerolaJam0_Asymberration/blob/main/Scripts/Player1.gd#L115-L116)

here: [Calculating the spread](https://github.com/RustyPrime/AcerolaJam0_Asymberration/blob/main/Scripts/Player1.gd#L132-L137)

and here: [Applying both to the shot](https://github.com/RustyPrime/AcerolaJam0_Asymberration/blob/main/Scripts/Player1.gd#L266-L271)


## HARD MODE
While designed for 2 players, it is technically possible for more than 2 players to join a host, each additional player gets their own overview and can spawn aberrations separatly, quickly overrunning the ground player/host.

However errors/crashes might occur, as this is actually a bug but left in on purpose for some shenanigans.

## Known issues
- Sometimes overview player can not see what they spawned or the ground player is desyncing (workaround: both players need to restart the game)
