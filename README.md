# Godot GPU Terrain editor
This is a very early version of my terrain editor for Godot. Consider this broken alpha software :)
Note that you need to have a current master build of Godot to use this. It requires features that have been merged but are planned to be part of the Godot 3.1 release.

The load and save function work on a folder. Saving results in the height map and splat map being saved as png files in the selected folder. Load will attempt to load those.

I did attempt to also load/save the textures being used but had lots of problems with this especially with normal maps. That said, it would be better to save the location of the files. 

Once you create a terrain and have saved that terrain, you can copy the contents of the addons/terrain folder into your own Godot project and add the Terrain-render.tscn scene as a subscene to your project.
Then assign the heightmap and splatmap textures to the terrain.

In a similar fashion you can assign the textures you wish to use for the terrain types. There are 5 terrain types and each have 3 textures you can assign:
- a diffuse texture for the color
- a normal map 
- a PBR map (red = metallic, green = roughness, blue and alpha are reserved)

Note that at this point in time you don't see the terrain until you start your project. I hope to resolve that in due time.

License
-------
The source code held within is released under an MIT license.

Note that various images found within the textures folder are copyright by their respective authors. Please visit HDRIHaven and Textures.com for further details. 

About this repository
---------------------
This repository was created by and is maintained by Bastiaan Olij a.k.a. Mux213

You can follow me on twitter for regular updates here:
https://twitter.com/mux213

Videos about my work with Godot including tutorials on working with Godot can by found on my youtube page:
https://www.youtube.com/channel/UCrbLJYzJjDf2p-vJC011lYw
