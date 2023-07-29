# This is first public release of 'Prepare to Drop'! 

The idea of this project was for me to create a project with VR mechanics that was more or less what's expected in "shooter" VR games but set within the Halo universe. Therefore, the CC0 nature of this project. 

This is essentially a simple intro of a proof of concept game and to show possibilities within even the comparatively fledgling VR scene of the tiny 52 MB game engine. The catch is that it's entirely focused on Quest 2 hardware. So PCVR users may be confused as to the lack of effects and other such shortcuts. There's a some explanations in some of the autoloads and a cool feature where most of them don’t! 

## Regarding the legality of it all:
To use the music and sound effects, you'll have to source them yourselves but it's very easy to find but what isn't usually easy is the legal info. 
For a full simple "what you can do" statement from the owners themselves is [here.](https://www.xbox.com/en-US/developers/rules). The gist is that you can use in game but if you explicitly say

```
"Halo 2 & Halo 3: ODST © Microsoft Corporation. "Prepare to Drop" was created under Microsoft's "Game Content Usage Rules" using assets from Halo 2 & Halo 3:ODST, and it is not endorsed by or affiliated with Microsoft."
```

and also not making any cash from this (opposite, for me) or even promote any commercial venture. Which is perfect because both this project and Godot is a free open source software!


# BEFORE USING:
This project is meant for godot users/learners who have grasp the basics of the engine/programming. However, interest drives curiosity, and this project welcomes all to dip their toe into the game engine. I’m not a professional, and invite all who see the code and think *I can do **way better*** to check out the engine.

The entire project files are included, save for the music and the android folder. Of course, you'll have to download the android export templates. Not all the important info is here so make sure to check out the documentation!

That said, if you are intended to use the Quest device platforms, and do not have or know what an android sdk is, then we got you covered, but it'll take a few moments before you can change the sky color to blue. Follow this link to get started on preparing your phone, laptop, gameboy color, desktop for game development! [Our best friend *Documentation* has more on it](https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html).


## Required items
- A [device](https://www.google.com/search?q=operating+system&oq=operating+system) that can run Godot and allow usb connections. Such examples are Linux, Android, Windows, iOS, and probably a lot more!
- [Godot 4 VR compatible device](https://mbucchia.github.io/OpenXR-Toolkit/FAQ.html#q-what-headset-does-the-openxr-toolkit-work-with)
- [Godot 4](https://godotengine.org/) with working android template (52 Mb download for the base game engine plus the 779.3 MB android export template download within the godot game engine). Template not needed if other devices use other methods of deployment
- [XR Tools plugin and the XR Android OpenXR Loaders](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html)
- Recommended: The 'Free Look Camera' plugin by MarcPhi; an extremely helpful plugin that will help with debugging to save a few hundred headset ‘equipping’  moments. 
- [Android Studio](https://developer.android.com/studio); which allows quest/phone exports and [one-click deploys](https://docs.godotengine.org/en/stable/tutorials/export/one-click_deploy.html#using-one-click-deploy)(1 GB download, plus another 500+ mb for sdk and other proper files)
- These github files
- Personally sourced sounds

[Here’s a 2 min video for getting Quest 2 exports](https://www.youtube.com/watch?v=T0wqWNUsc0g)

 *For Quest 2; You'll just need an android export template ready within Godot 4*


## UPDATING XR TOOLS:
A godsend of a plugin making everything possible. Future releases will more than likely contain more things to add the "tool belt" of possibilities. 
### To update: 
1. backup game folder (NOT the android or .godot folders)
1. download the latest and greatest of the plugin releases
1. go to the game addon files in the systems file manager
1. delete the whole entirity of the xr tools folder
1. grab the proper folder within the 'addons' subfolder 'godot-xr-tools' and
1. copy it over to the addons.

That's it but if the release says it's 'breaking', then you may have to hold off or have to go at the code and make it work. (Also why it's important to exteneded srcs)


# HOW TO USE:
 - to be added
 
 Explore, mess around, try new things!


# ISSUES
## Tons
### If your console no longer outputs text after “Reverse result: 0” or “DEBUGGING OVER USB” OR freezes with no console output; go to the Editor > Editor Settings > go to Network > Debug > Remote Port and +2 the port. Close and your console text comes back, repeat whenever you get an error to save the chance of no input.

