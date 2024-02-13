# Swifile

Swifile App is a simple SwiftUI application for managing files and folders on your device.

## Overview

Swifile App provides a user-friendly interface to browse, search, and manage files and folders on your device. It allows you to toggle file size visibility, sort files by various criteria, and perform actions such as opening, deleting, and sharing files.

## Features

- Browse files and folders in a directory
- Toggle file size visibility
- Sort files by name, size, or modification date
- Search files by name
- Delete files and folders
------------------------------------------------------
- Planned future updates:
  - File sharing
  - File modifications
  - Uploading files
  - Recycling bin
  - Open files in external applications
  - Share files with other apps

## Installation

Requires:

* macOS with recent Xcode installations
* [HomeBrew](https://brew.sh)
* [Theos](https://theos.dev)

Your phone: iOS 15+ with TrollStore.

Clone this repository. Run [ipabuild.sh](ipabuild.sh) and you will get a tipa after that.

Send the file to your phone (probably on macOS just use AirDrop), install with TrollStore.

Or you can setup Theos and run:

* `make package` to make a deb
* `make do` to make a deb and install it onto your phone
* `make` to build the project

> You will need to setup root user password on your phone first.

> Open Filza -> open Zsh or Bash (or whatever commands that don't accept stdin - Standard Input on no argument run), run `passwd root`. Do what it tells you (be aware of the current keyboard region). Ignore any warnings if any, only care about errors.

> If you want to use the deb file, find the lastest one in packages/ after building, fire it to your phone, open with whatever app you want.

Look at Theos documentation for useful environment variables and options (you will need them).

Profit!

### Use with Swifty

Swifty by SparkleChan is a way to build, make, run Swift projects (and ObjC later).

This app is originally made in Swifty!

Currently as this was made to be a Xcode project, no support made for Swifty for now.

Also with tests we confirmed that this project has problem building with Swifty, and seems the fault is the compiler: Swift. The latest on Procursus is 5.7.x. More tests required.

## Usage

- Upon launching the app, you will see a box asking you to enter a directory path you want to go.
- Use the sorting options in the navigation bar to sort files.
- Use the search bar to search for files by name.
- Tap on a folder to navigate into it and view its contents.
- Tap on a file to perform actions such as opening or deleting it.

## Future Updates

- **File Sharing**: Share files with other apps or users.
- **File Modifications**: Edit and modify files directly within the app.
- **Uploading Files**: Upload files from external sources to the app.
- **Recycling Bin**: Implement a recycling bin feature for deleted files.

## Screenshots

![IMG_7514](https://github.com/speedyfriend67/Swifile-FileManager/assets/82425907/3e4658fa-75a2-4bbd-9efa-6573342c9130)


## Author & Helpers

Made by [speedyfriend67](https://github.com/speedyfriend67)

TIPA build script made with the help of [Geranium](https://github.com/c22dev/Geranium)

Thanks to [AppinstalleriOS](https://github.com/AppInstalleriOSGH) and [lebao3105](https://github.com/lebao3105) for many great contributions!

Thanks to TigiSoftware for their Filza - also ideas for this app!

## License

This project is licensed under the [MIT License](LICENSE).
