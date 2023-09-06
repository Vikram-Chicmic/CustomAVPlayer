# ios-custom-video-player

Welcome to the Custom Video Player Framework!

## Table of Contents
- [Features]
- [Customizations]
- [Installation]
- [Usage]
- [Demo]

## Features
* Storyboard Integration: Customize player components directly from Interface Builder.

* Customization: Tailor the player's appearance to match your app's design.

* Reel Feature: Implement a scrollable "Reel" functionality for dynamic content browsing.

* Video Playback: Play video files from local storage or online sources.

* Fullscreen Mode: Switch between fullscreen and normal modes with a single tap.

* Playback Controls: Standard playback controls, including play, pause, forward, lock , hide controls,rewind, and seek.

* Custom Events: Trigger custom events and actions during video playback.

* Device Compatibility: Supports a wide range of iOS devices.

* Responsive Support: Timely updates and assistance.

## Customizations
* Use Reel Feature  (enable reel view)

* ControlsDisabled (to hide controls)

* Change property like size, color , image , hide/unhide for each control :
     * Zoom icon     
     * Close icon
     * Mute icon
     * Unmute icon
     * Lock icon
     * Unlock icon
     * Play icon
     * Pause icon
     * Backward icon
     * Forward icon
     * Slider 
     * Slider Thumb
     * Time Labels

* Edit Seek Time for forward backward button
* Gesture Controls:
     * Single Tap play/pause and mute/unmute for Reel view
     * Double Tap forward and backward for normal player view
     * Touch and Hold to pause for reel view
     * Interaction enable/disable for player

## Installation

You can install the framework using [CocoaPods](https://cocoapods.org/)

### CocoaPods

```ruby
# Add this to your Podfile
 pod 'CustomAVPlayer', :git => 'https://github.com/Vikram-Chicmic/ios-video-player.git', :branch => 'feature/reel-functions'
```


## Usage

Here's how you can use the Custom Video Player Framework in your project:
1. Create a view through storyboard
2. Set its constraints
4. Add class to the view to 'VideoPlayerView'

     ![Screenshot 2023-09-04 at 6 44 06 PM](https://github.com/Vikram-Chicmic/ios-video-player/assets/130149285/4edb74b6-a6e2-4104-8d50-62856c44b069)
5. Customize the controls as per your requirement through property inspector.
6. Set Target to CustomAVPlayer.
7. Create outlet of the view in ViewController.
8.  Import the framework:

```swift
import CustomAVPlayer
```
7. Call the method for normal player with this line of code where videoURL take url as a parameter in normal URL format:
   ```swift
      // for normal video player
        avPlayerView.startAvPlayer(videoURL: URL(string: videoUrl)!)
   ```
   and for Reel View use this line of code where urlStrings accept the Url array in string format: 
   ```swift
   // for reel view
        avPlayerView.startReelView(urlStrings: urlStrings)
   ```
   ![Screenshot 2023-09-04 at 7 06 45 PM](https://github.com/Vikram-Chicmic/ios-video-player/assets/130149285/a1ca71cf-377a-4321-b5ec-884f43a352e0)
8. For Reel View choose the tap functionality you want:
   ```swift
   // for play-pause function on tap
   avPlayerView.tapFunctionForReel = .playPause
   ```
   ```swift
   // for play-pause function on tap
    avPlayerView.tapFunctionForReel = .muteUnmute
   ```

## Demo
### Normal Player
<img src="https://github.com/Vikram-Chicmic/ios-video-player/assets/130149285/62f5c952-e50f-4546-b1db-93bd780ead61" width="300">
<br><br><br>
<img src="https://github.com/Vikram-Chicmic/ios-video-player/assets/130149285/f2988495-65b8-432c-bfd5-6a10dcaeeb33" width="300">


### Reel View
https://github.com/Vikram-Chicmic/ios-video-player/assets/130149285/7955bc29-ee56-4e16-9627-454ae195c365




     
