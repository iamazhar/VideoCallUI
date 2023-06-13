# VideoCallUI

A customizable, easy-to-use iOS library to create video call interfaces in your Swift applications.

<div align="center">
    <img src="preview.gif" width="250">
</div>

VideoCallController is a UIViewController subclass that provides a user interface for video calling, designed to be easy to open in full-screen or as a call screen with minimised mode. The controller has a variety of delegate methods for video call events and customisable UI elements.

# Features

- Fullscreen and minimised call UI modes.
- Positioning of the minimised call UI.
- Switching between local and remote video views.
- A collection of handy delegate methods for various call events.
- Animated, hideable call action buttons.
- Customisable button actions.
- Drag to reposition in minimised mode.

# Requirements

iOS 13.0+
Swift 5.1+
UIKit

# Installation

## Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler.

Once you have your Swift package set up, adding VideoCallUI as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/iamazhar/VideoCallUI.git", .upToNextMajor(from: "1.0.0"))
]
```

# Usage

After installing the library, import it wherever you want to use it:

```swift
import VideoCallUI
```
Add the VideoCallController as a child controller to your target controller.

Implement VideoCallControllerDelegate to handle call events:

```swift
extension YourViewController: VideoCallControllerDelegate {
    func didTapBack(videoCallController: VideoCallController) {
        // Handle back button tap
    }
    
    func didTapMainView(videoCallController: VideoCallController) {
        // Handle main view tap
    }
    
    func didTapEndCall(videoCallController: VideoCallController) {
        // Handle end call
    }
    
    func didTapFloatingCallView(videoCallController: VideoCallController) {
        // Handle floating call view tap
    }
    
    func didTapCameraSwitchButton(videoCallController: VideoCallController) {
        // Handle camera switch
    }
    
    func didTapCameraButton(videoCallController: VideoCallController) {
        // Handle camera button tap
    }
    
    func didTapMicButton(videoCallController: VideoCallController) {
        // Handle mic button tap
    }
}
```
And set the controller's delegate:

```swift
videoCallController.delegate = self
```

For more usage examples, please see the Example folder.

# License

VideoCallController is released under the MIT license. See [LICENSE](LICENSE) for details.

# Contribute

I would love for you to contribute to VideoCallController, send me your pull request.

# Let us know

I’d be really happy if you sent me links to your projects where you use our component. Just send an email to azharcodes[at]gmail.com and do let me know if you have any questions or suggestion.
