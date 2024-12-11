# FBP - What is this

I have been developing a Flow Based Programming system called Thunc that leverages the sokol-luajit engine I have been working on here. However, I think it would be beneficial to have fbp modules as part of sokol-luajit.

## What this means

The reason for this implementation is that while creating rbuilder, I realized it will be necessary to have some critical development systems. These being:
- An editor/configuration system of some sort
- A build system (this is what rbuilder was being created for)
- Asset packaging system
- Multiple project management sturctures

Now this will be added in a slightly different way. And this document tries to outline the way this will be done, and the features it will bring. 

Note: This will not be my full Thunc engine, it will be core components of it. If you want fancy modules, you will need to build them yourself :)  However, I will try to provide examples and how to do it.

## The Router
The master of executing FBP modules the router is essentially like a normal network router that directs module traffic to/from other modules. 

Many modules of the exact same type can be instanced (think like a dll but without the proc sharing). The router is responsible for:
- Debugging a runtime (since the traffic is what actually makes a program work)
- Loading and Unloading modules (along with configuring them)
- Starting and Stopping all the modules on startup and shutdown respectively
- Handling the builtin editor and system management - this via html server built into the router

From the Router you will be able to start editing a scene, develop scripting (via node like module systmes - think blueprints in Unreal), preview and test an application as well as create releases and debug versions.

## A FBP Module 
These can be small or big and everything inbetween. The initial set of modules are like the dll's currently in the bin folder for sokol. These will instead become exe's that run as standalone processes (sometimes more than one). 

Each module has a common standard interface. The best way to understand the interface, is that it is almost identical to the TCP network interface with some additions. There is a src address, a dest address, ports, header data types and some time stamp related information. In addition to this is a module identifier (like a guid) and some required information for the interface to consume the packet of data.

The module can be interrogated and respond with the commands it supports. It does _not_ publish how those commands are used, that is up to the user. If the data is malformed, the interface will notify the router of an error relating to this. 

Currently there is no encryption, but this can be esily added if needed. 

A module is most recommended to be made as a self-containing software system. An example would be the sokol-gfx system. Data is sent to the sokol-gfx module, it processes that data and then displays it. All very simple IO black box system engineering styled.

## Making an application
Initially, creating applications via sokol-luajit was going to be a standard linear software development process. For example, you take the cube_sapp sample expand it with the scripts and ffi modules you want to use, use rbuilder to create a working exe and package, and thats it. 

This would be a very manual process. Including some of the setup and compartmentalization of the project and its dependencies. After trialing a number of ideas, I decided there are some unique capabilities of this system that should be leveraged:
1. The router/main exe you run _can_ also be the editor and the builder. Via modules and scripts.
2. There is technically no compilation process. There is kind of a packager that puts all the bytecode together and then creates and exe, but there is no need for msvc, gcc, clang or any other development tools to make and output. This means the build process should be _really_ simple. 
3. With a builtin-html server (in the router) the editor can be in a html browser. Now before you moan, and go "oh god not a html 3d editor" - no, not that. Since the router can use sokol gfx to render. Thus, you can have both. The html editor for things like node construction of systems and setting paramers, but also the real sokol runtime to see what your application runs like on the device you are using. This also means you can technically develop on Android and IOS without a development kit also.
4. Its lightweight. The whole system right now, in X86_64 is less than 18MB _total_. Thats a complete cross platform development system. That is kinda crazy. Which brings with it many many small platform targets that could be added (mostly arm systems).

While talking to a friend about this, I realized this is going to be a little different and so, it needs to have a little bit of a different process. 

### New Project 
A new tool called pmaster (project master - yeah Im not great with names) is the starting point for any application. You run this tool, fill out some basic info and shazzam, a new project will be created in the folder you want and the html editor will appear as will the sokol-gfx window. 

### Editing
This is mostly TBD but heres how the design goes:
- Configure the project to how you want: what modules to use, and various other project options (lots really)
- Add your assets
- Create Scenes, generate game flow (this will be via nodes) and more. 
- Write Script - if you need to. Add lua scripts, make your own modules.. 
- Build, Run, Test, Debug 
- Deploy! To the platform of your choice.

I cant quite state this clearly enough, this will be a little weird at first. There are no compile steps, there are very very few build steps (some resource conversion and packing) and thats it. Most builds will be the sizes of the modules you use plus your scripts plus your assets. If thats 20MB.. then thats what the output package will roughly be. There is very very little bloat in this system. 

### Extensions
Making modules will be part of building an application. You may not need any and just write lua and use the defaul sokol modules - which there will be quite a few - if you have a sokol lib request its fairly easy to add.

FFI will be available for non-web targets - although I am looking into how this may actually work in wasm which would be my preference.

C++ modules will be available and any other languages that provice CDECL name mangling. This will work with both FFI and the compiler/packager I use. 

The html editor will be completely modifiable. CSS/JS/HTML will be available for you to make your own editor to use how you like for your projects. Note: You change it and break it - you fix it :) 

There will be limited to no support for custom modified editors. However if people want to help each other then thats fine. And it is possible external changes may come into the default editor as time goes on.

## Development
This is a long and relatively slow journey. I full expect the majority of this to take a few months to get to a base level of "general usage". I will work hard to get it functional as early as possible, but cannot make any guarantees, since there is always life getting in the way making development time a limited commodity for me :)

