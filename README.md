## About

Welcome to Stellar Highway... the open source repository!

Stellar Highway is a 2D endless runner developed by me (Safwan Murad) and released on the Google Play Store.

Stellar Highway is a passion project that wasn't built to make money, so as a big fan of open source and as a believer in the GPL license, it was only right to release the game open source.

This is the first videogame I created (and the first project I decided to open source) so the codes may not be the cleanest.

## Technical Notes

The game was made using **Godot Engine**.

**Godot Engine** is a free, open-source, cross-platform open source game engine that provides a complete set of tools for 2D and 3D game development. It features an intuitive scene system, a powerful built-in scripting language (GDScript), and a lightweight, flexible workflow—making it easy for developers to build and ship games quickly under the permissive MIT license.

Stellar Highway was written in GDScript even though **Godot** supports coding in GDScript, C# and C++. The game’s codebase is lightweight, so it didn’t require the extra performance benefits of C# or C++.

To talk about the project structure let's talk about Godot's scene system first:
Godot’s scene system is built around reusable building blocks called scenes, each containing nodes arranged in a hierarchy. A scene can represent anything—a character, a UI element, or even an entire level—and scenes can be nested or instanced inside each other to create complex structures.

The structure of the project is simple, it's 2D, all the assets and scripts are in GameFiles, the names of the folders explain what they contain, scenes are used to create different gamemodes, different obstacles, the player and basically everything, the project doesn't use the tiles system, music and soundeffects all use the mp3 format, images use the png format and the project rendering is set to mobile mode.

The structure of the code is simple, every script is attached to a node, some nodes exist just to hold a script important for gameplay, the script's name explains what the script does and no multi threading code was written.

The project screen size has a fixed 1080 pixels on the y axis but the pixels of the x axis can change.

The main Scenes of the project are Intro.tscn, MainMenu.tscn, GameFiles/Modes/EndlessRunnerMode.tscn, GameFiles/Modes/HoleIn-a-WallMode.tscn and GameFiles/Modes/MissilesMode.tscn.

## Technical Requirements

You only need to install **Godot 4.5.1** and you are set (https://godotengine.org/download/archive/4.5.1-stable/).


## The Message

The game's code is under the GPL license, so you are free to do whatever you want with it, but as the game's developer I just want to say:

- If you wanna use my game as a template for your project, **please don't create gambling systems or lootboxes** in your project as microtransactions (I can't stop you if you do it, but please don't).
- If the game's code or assets helped you with your project, a **mention of me or a link to this repository** would be sincerely appreciated.
- Please don't re-release the game without changing anything.
- If you wanna support me, just **download the game from the Google Play Store** lmao.


## Credits

**Initial Commit:**

Character Physics: by marmitoTH (Lucas Rodrigues)  
https://github.com/marmitoTH/Godot-Sonic-Physics

Missile Explosion Animation: by @nyk_nck  
https://nyknck.itch.io/explosion

Game Design: by Safwan Murad  
Music: by Safwan Murad  
Basically Everything Else: by Safwan Murad
Trailer: by Safwan Murad


## Final Words

Thank you for checking out the Stellar Highway open source repository!

Don't forget to download the game if you haven't!
