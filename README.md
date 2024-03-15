# Swifile

Swifile App is a simple SwiftUI application for managing files and folders on your device. 

## Overview

Swifile App provides a user-friendly interface to browse, search, and manage files and folders on your device. It allows you to toggle file size visibility, sort files by various criteria, and perform actions such as opening, deleting, and sharing files.

## Features

- Browse files and folders in a directory
- Toggle file size visibility
- Sort files by name, Alphabetical, size, or modification date
- Search files by name
- Delete files and folders

- Planned future updates:
  - File sharing
  - File modifications
  - Sharing files
  - Recycling bin
  - Open files in external applications
  - **Class Dump** (Generate Objective-C headers from Mach-O files)

## Installation

Just obtain a release from either Releases page or [lebao3105](https://github.com/lebao3105)'s repo: [https://lebao3105.github.io/repo](https://lebao3105.github.io/repo).

Requires these to build from source:

* macOS with recent Xcode installation
* [HomeBrew](https://brew.sh)
* [Theos](https://theos.dev)

Your phone: iOS 15+ with TrollStore.

Clone this repository. Run [ipabuild.sh](ipabuild.sh) and you will get a tipa after that.

> Set the `SYSROOT` environment variable to your preferred SDK, `ARCHS` to either `arm64`, `arm64e` or both first!

> IPA builds are not working (no root permission for the helper right now)

Send the file to your phone (on macOS use AirDrop), install with TrollStore.

Or you can setup Theos and run:

* `make package` to make a deb
* `make do` to make a deb and install it onto your phone
* `make` to build the project

> The root helper by default will have both arm64 and arm64e Mach-O in it. Modify the `ARCHS` variable as said above to change this.

> You will need to setup root user password on your phone first.

> Open Filza -> open Zsh or Bash (or whatever commands that don't accept stdin - Standard Input on no argument run), run `passwd root`. Do what it tells you (be aware of the current keyboard region). Ignore any warnings if any, only care about errors.

> If you want to use the deb file, find the lastest one in packages/ after building, fire it to your phone, open with whatever app you want.

Look at Theos documentation for useful environment variables and options (you will need them).

Profit!

### Use with SparkCode (Swifty)

SparkCode by SparkleChan is a way to build, make, run Swift projects (and ObjC later).

This app is originally made in SparkCode by SparkleChan!

Currently as this is not confirmed to work with SparkCode yet, as the new C++ helper came along with support for them in SparkCode, also new features, also nobody try it yet (as far as we know).

## Usage

- Upon launching the app, you will see a box asking you to enter a directory path you want to go.
- Use the sorting options in the navigation bar to sort files.
- Use the search bar to search for files by name.
- Tap on a folder to navigate into it and view its contents.
- Swipe on any list cell to view its available options.
- [![Make a new binary build](https://github.com/speedyfriend67/Swifile-FileManager/actions/workflows/Release.yml/badge.svg)](https://github.com/speedyfriend67/Swifile-FileManager/actions/workflows/Release.yml)

## Screenshots

![IMG_8261](https://github.com/speedyfriend67/Swifile-FileManager/assets/82425907/8d25a2e3-9e33-4476-9001-fee0cd7bd671)

More screenshots required.

## Author & Helpers

Originally Made by [speedyfriend67](https://github.com/speedyfriend67)

TIPA build script made with the help of [Geranium](https://github.com/c22dev/Geranium)

Thanks to [AppinstalleriOS](https://github.com/AppInstalleriOSGH) and [lebao3105](https://github.com/lebao3105) for many great contributions!

Thanks to [TigiSoftware](https://www.tigisoftware.com/default/) for their [Filza](https://www.tigisoftware.com/default/?page_id=78) - also ideas for this app!

Thanks to [Dekotas](https://x.com/dekotastm?s=21) for [SparkCode](https://chariz.com/get/sparkcode).

## License

This project is licensed under the [MIT License](LICENSE).
