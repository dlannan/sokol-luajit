# srlua and rbuild

## srlua

The srlua tool is based on the original project here:
https://github.com/LuaDist/srlua

The tool is a way to build single runtime executables (for multiple platforms) that bind the lua script and resources together. 

The sokol-luajit project is using srlua in the following way:
- Modified srlua to support luajit library 
- Builds a "luajit" runtime that can embed script object files or plain scripts.
- Collates resources into one or more packages (as per rbuild settings)
- Enabled various modules and features depending on the settings in rbuild

srlua can be used manually like so:
```
glue.exe srlua.exe mystartupscript.lua myprogram.exe
```
The first two commands must be always used. Many scripts can be combined, but the first script is always the initial calling script when 'myprogram.exe' is run. 

Future development of srlua will support:

- [ ] encrypted lua scripts (currently only compressed!)
- [ ] project files (to list hierarchies of scripts etc)
- [ ] resource files (like images, data files etc) to be packed into a zlib styled resource package
- [ ] binding luajit bytecode output files - this should already sort of be possible. 

It is expected that srlua will evolve quite dramatically from its current incarnation

## rbuild

RBuild will be the user level interface to build release packages for a platform
RBuild calls srlua with options to package the binaries needed and the scripts needed for a project.

Eventually RBuild will become of the editor. Its initial development is to design and configure the build process.

