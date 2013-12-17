CheckNetConnectionHUD
=====================

The background automatically detect the network connection , When the network status have changed show HUD.

[![](https://raw.github.com/Coneboy-k/CheckNetConnectionHUD/master/image/19.gif)]

## Requirements
CheckNetConnectionHUD works on any iOS version. Only ARC.

## Adding CheckNetConnectionHUD to your project

Include CheckNetConnectionHUD wherever you need it with `#import "CheckNetConnection.h"`.

### Source files

Alternatively you can directly add the `CheckNetConnection.h`& `CheckNetConnection.h` & `KKHUD.h` & `KKHUD.h` & `Reachability.h` & `Reachability.h` source files to your project.

1. Download the [latest code version](https://github.com/Coneboy-k/CheckNetConnectionHUD/archive/master.zip) or add the repository as a git submodule to your git-tracked project. 
2. Open your project in Xcode, then drag and drop `CheckNetConnection.h`& `CheckNetConnection.h` & `KKHUD.h` & `KKHUD.h` & `Reachability.h` & `Reachability.h` onto your project . Make sure to select Copy items when asked if you extracted the code archive outside of your project. 
3. Include CheckNetConnectionHUD in your `didFinishLaunchingWithOptions`
 `#import "CheckNetConnection.h"`.

## Usage

    	    [[CheckNetConnection sharedCheckNetConnection] netCheck];



## Who use

>图说  http://www.tushuoapp.com/

## Special thanks

[tonymillion / Reachability](https://github.com/tonymillion/Reachabiliy
)
## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE). 

## Change-log

A brief summary of each CheckNetConnection release can be found on the [wiki](https://github.com/Coneboy-k/CheckNetConnection/wiki). 
