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
Due to the time constrain i wasn't able to be build a fully fleshed out dedicated server (which would allow web-users to use the multiplayer), however you can play together remotely using a service like Hamachi.

The host has to disable their windows firewall though.

## HARD MODE
While designed for 2 players, it is technically possible for more than 2 players to join a host, each additional player gets their own overview and can spawn aberrations separatly, quickly overrunning the ground player/host.

However errors/crashes might occur, as this is actually a bug but left in on purpose for some shenanigans.


## Known issues
- Sometimes overview player can not see what they spawned or the ground player is desyncing (workaround: both players restart the game)