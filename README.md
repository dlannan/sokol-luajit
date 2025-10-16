# sokol-luajit

Update 16/10/2025

After some trials and tests. The below arch is not going to be very usable. Going to put this into a branch in case I want to redevelop this idea, but there were some major problems:

1. Problems with maintaining two whole systems plus a server remote backend. Not very good for versioning, support and long term consistency. 
2. The web editor view would never be consistent with the application output. This is important for gfx oriented applications or games. 
3. Alot of complexity needed for data sharing and management. Would prefer a simple db than this sort of mess.
4. Web visuals and their libraries are _huge_ resource hogs (both file an mem) and I want this to be a more lightweight system. 

I want an easily extensible system (for developers) but I also need it to be clean and user friendly for people coming into development for the first time. The web view is kinda ok for the second goal, but not really for the first. 

The result. I will be building my own gui layer (yeah, I know) which will be a structured lua format that allows for functionality to be built into the gui elements themselves. Think of it like an SVG format with actions that can be applied to any element. 

Fixed build editor:

to run ```.\bin\win64\luajit.exe .\tools\build\rbuilder\rbuilder.lua```

This can compile a project into an executable package with resources (which will eventually be a resource bundle). This works in another project I have, I will work to get some example build projects working so this can be used as-is. Some of the widgets and tools have been moved into the engine. This will begin to form the basis of the built-in themable GUI. 

Expect incoming updates over the weekend. With maybe a small game as well. 

Update 15/10/2025

Its been a long time. Life gets in the way as usual. I have been using this toolkit for a number of projects so I wanted to update it. I have built a complete fbp system using it (to be shared later) and I have made a luajit based html rendering engine that is coming along nicely (with the same toolkit). 

https://github.com/dlannan/luajit-html-engine/

If you want kind of a preview of what is happening you can see some of the work by running:

```.\bin\win64\luajit.exe .\editor\editor-win64.lua```

Obviously this is for win64 atm. And there might be browser compatibility issuse too. If you use Firefox or similar it should work fine, but dont expect miracles :)

< snip - didnt want this huge diag taking up the readme. See commits to view >

Update 06/05/2025
- Updated Discord link (Thanks DarkSeasonsStudios)
- PR added for MacOS fixes. (Thanks funatsufumiya)

TODO: Some testing on MacOS.

NOTES: Im currently very busy finishing off another project here: 

https://forum.defold.com/t/f18-interceptor-building-my-favorite-old-amiga-game/69851

Once this is complete, I will put most of my time into this project. 

Update 11/12/2024 
- Breaking changes happening. The build system works but Ive decided to change to use an FBP styled system (see FBP readme).
- I hope to have a 'usable' new system in the next couple of weeeks. 

A luajit set of ffi wrappers for the excellent sokol framework,

- [x] Win64 Binaries - samples and remotery working
- [X] Linux64 Binaries - samples and remotery working
- [x] MacOS - x86_64 Binaries - samples and remotery working
- [ ] MacOS - arm64 Binaries - tbd. Working on tests/solves.

-------------------------------------------------------------------------------------------------------------------------------------------------

For all things, Sokol, luajit and sokol-luajit feel free to drop in the Discord

Discord - [https://discord.gg/KMDeFebk](https://discord.gg/Knzpav9nfD)

## Sokol
The repo is based entirely on the brilliant framework here:
https://github.com/floooh/sokol

The sokol api has been built into dll's (this may change in the future) and it is executed in the best (imho) runtime system there is using its amazing ffi module:
https://luajit.org/

sdf exmample 
![alt text](https://github.com/dlannan/sokol-luajit/blob/main/media/2024-10-30_11-48.png "sdf Example")

Some of the source files have been modified to support shared libraries a little better and make the binding of ffi a little easier. There are only small changes, but this is kept in this location - do not use as a source for sokol itself.
https://github.com/dlannan/sokol

The build process builds Win, Linux, Mac OSX, IOS but not Android atm. I need to build a shared library mechansim for this to work well. Thus, the build for it currently fails.

## Luajit Sokol
The only provided main luajit binaries are for win64. 
To run other platforms, please build luajit for your platform and place in the bin/<your platform> directory.
You will also need to modify the paths at the top of the samples lua scripts to match. I will update this to be more friendly in the future (by using ffi.os).

The Wasm part of sokol might not be able to be utilized in this manner. However I do have plans to compile Luajit->wasm and embed sokol generated bytecode. It should be possible, but that is along term goal.

## Examples
I have ported examples from sokol, and will be adding more. These show how the ffi interface can be used.

How to use the example. Open a command window or powershell in the repo folder (Win64 powershell shown below)

```
PS sokol-luajit> cd .\examples\
PS sokol-luajit\examples> .\run_sample.bat cube_sapp
```

Use the run_sample bat file with one of the following parameters:
| Command | Description |
|---------|-------------|
|```cimgui_sapp``` | Imgui Demo example |
|```cube_sapp``` | Simple spinning cube |
|```shadow_sapp``` | Shadowed cube with moving light |
|```shapes_sapp``` | Primitive shapes spinning |
|```triangle_sapp``` | Classic triangle |
|```offscreen_sapp``` | Sphere with render texture torii? spinning on its surface. |
|```nuklear_sapp``` | Nuklear GUI demo |
|```nuklear_png_sapp``` | Nuklear example with images |
|```nuklear_multifont``` | Nuklear examples with multiple fonts and font awesome icons |
|```sdf_sapp``` | SDF from the Sokol samples |
|```remotery_cube```| A spinning cube with Remotery backend. Open /tools/remotery/vis/index.html in your browser. |

Some notes:
- There are a number of objects that must be created as pointers. In ffi the easiest way to do this is to make an array object of size 1 and this way the handle in lua is a pointer and the object access uses the array indexing.
- No performance considerations have been taken into account. These are almost direct 1 to 1 mappings of the sokol C samples to luajit samples. 
- pathing is not yet made friendly (31/10/2024 - It has been improved dramatically. Little more to do.)

Feel free to contribute or post issues/ideas comment. I put this together yesterday, and its very rudimentary atm.

Screenshots:

cimgui example
![alt text](https://github.com/dlannan/sokol-luajit/blob/main/media/cimgui_sapp.png "cimgui Example")

nuklear example
![alt text](https://github.com/dlannan/sokol-luajit/blob/main/media/nuklear_sapp.png "nuklear Example")

offscreen example
![alt text](https://github.com/dlannan/sokol-luajit/blob/main/media/offscreen_sappjpeg.jpeg "offscreen Example")

shadow example
<video src='https://github.com/dlannan/sokol-luajit/blob/main/media/2024-10-07%2011-31-08.mp4' width=180/>

shapes example
<video src='https://github.com/dlannan/sokol-luajit/blob/main/media/2024-10-07%2011-32-21.mp4' width=180/>
