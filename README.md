# people in space

<p align="center">
  <a href="https://github.com/fork-my-spoons/people-in-space.spoon/issues">
    <img alt="GitHub issues" src="https://img.shields.io/github/issues/fork-my-spoons/people-in-space.spoon"/></a>
  <a href="https://github.com/fork-my-spoons/people-in-space.spoon/releases">
    <img alt="GitHub all releases" src="https://img.shields.io/github/downloads/fork-my-spoons/people-in-space.spoon/total"/></a>
</p>

Shows number of people currently in space:

<p align="center">
  <img src="https://github.com/fork-my-spoons/people-in-space.spoon/raw/master/screenshots/screenshot.png"/>
</p>

# Installation

 - install [Hammerspoon](http://www.hammerspoon.org/) - a powerfull automation tool for OS X
   - Manually:

      Download the [latest release], and drag Hammerspoon.app from your Downloads folder to Applications.
   - Homebrew:

      ```brew install hammerspoon --cask```

 - download [people-in-space.spoon](https://github.com/fork-my-spoons/people-in-space.spoon/releases/download/v1.0/people-in-space.spoon.zip), unzip and double click on a .spoon file. It will be installed under `~/.hammerspoon/Spoons` folder.
 
 - open ~/.hammerspoon/init.lua and add the following snippet, adding your parameters:

```lua
-- people in space
hs.loadSpoon('people-in-space')
spoon['people-in-space']:start()
```

This app uses icons, to properly display them, install a [feather-font](https://github.com/AT-UI/feather-font) by [downloading](https://github.com/AT-UI/feather-font/raw/master/src/fonts/feather.ttf) this .ttf font and installing it.
