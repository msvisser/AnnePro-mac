# AnnePro-mac
MacOS application for controlling AnnePro keyboard over bluetooth

This application is under development and is not yet finished. There are still problems and unimplemented features.
Please create an issue if you encounter a bug, or if you would like to see additional features.

# Screenshots
![Status bar menu](screenshot/annepro-menu.png)

![Lighting window](screenshot/annepro-lighting.png)

![Layout window](screenshot/annepro-layout.png)

# Known problems
- Getting keyboard to connect is all over the place. Sometimes it connects instantly, and sometimes you need to retry a lot.
- Uploading new lighting and layout information will sometimes stop halfway through. Currently the layout code will
  retry until the keyboard has the correct layout, but the lighting will not.
  
These issues are probably related to my inexperiece with the CoreBluetooth library, and creating macOS applications in general.
Please leave a pull request if you know how to fix these issues.
