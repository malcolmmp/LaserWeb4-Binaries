# LaserWeb4-Binaries

This is a **work in progress** repo for building complete LaserWeb4 binaries.

Successfully tested on Windows 10, MacOS 11.7, and Fedora Linux with Nodejs 20.
Yarn is required as all npm support has been removed in these branches.

# Build Instructions

Check out LaserWeb4, LaserWeb4-Binaries, and lw.comm-server as sibling directories in the parent folder of your choice, e.g. 'lwdev'.

```
mkdir lwdev
cd lwdev
git clone -b ew-integration https://github.com/malcolmmp/LaserWeb4.git
git clone -b electron-builder https://github.com/malcolmmp/LaserWeb4-Binaries.git
git clone -b integration https://github.com/malcolmmp/lw.comm-server.git
```

Build frontend
```
cd LaserWeb4
yarn run installdev
yarn run bundle-dev
```

Setup lw.comm-server
```
cd ..
cd lw.comm-server
yarn install
```

Copy LaserWeb4/dist files to lw.comm-server/app
#TODO Set up platform neutral script for this (yarn module?)

Come back to LaserWeb Binaries and build
```
cd ..
cd LaserWeb4-Binaries
yarn install
yarn rebuild
```

Build for your platform
Windows:
```
yarn make-win
```
Mac:
```
yarn make-mac
```
Linux Appimage x64:
```
yarn make-linux
```

Build artifacts should be compiled to the /out folder. Enjoy!


---

# Installers for LaserWeb4

Windows Users: Download exe from https://github.com/LaserWeb/LaserWeb4-Binaries/releases

Mac Users: Download dmg from https://github.com/LaserWeb/LaserWeb4-Binaries/releases/tag/untagged-4818330b6baa8213d4a7

Linux Users: Download AppImage from https://github.com/LaserWeb/LaserWeb4-Binaries/releases/tag/untagged-4818330b6baa8213d4a7

# Documentation

Head over to [https://laserweb.yurl.ch/](https://laserweb.yurl.ch/)
