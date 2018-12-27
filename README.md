# H.O.G.G.I.T. Framework

## Installation
##### This is for people who want to use the framework in their own missions
1. Get a copy of hoggit_framework-release-*-*-*.lua from http://framework.hoggitworld.com
2. in your mission add a trigger with action "DO SCRIPT FILE, click "OPEN" in the resulting dialog, and point it to the file you just downloaded.
3. the HOGGIT global is now available to scripts loaded after this.  Check http://framework.hoggitworld.com and click "Documentation" for available functions.

## Development
##### This is for people who want to make changes or additions to the framework.
1. Check out the framework from git into a folder called HOGGIT at the location you wish to keep your DCS scripts (usually Saved Games\DCS\Scripts).
2. Copy hoggit_config.lua.example to <YOUR GAME INSTALL>/Scripts/hoggit_config.lua (NOT your Saved Games!) and change the values there to match your saved folder configuration.  Do not include "HOGGIT" in the option for script_base, we just want a way that doesn't require desanitizing the lfs module to tell DCS where our Saved Games\DCS\Scripts folder is.   If you look at hoggit.lua you can see the framework expects to be in a folder called HOGGIT under where you define your script_base.
3. Add a trigger for DO SCRIPT in your miz with the following code: 
    ```
    dofile([[Scripts\hoggit_config.lua]])
    dofile(HOGGIT.script_base .. [[\HOGGIT\hoggit.lua]])
    ```
4.  The Hoggit Framework is now in your lua environment and available to any scripts loaded after this point!  Any changes you make to the checked out source will now be reflected when you reload your mission.
