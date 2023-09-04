//
//  VideoPlayerView+TouchGestures.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/31/23.
//

import Foundation
import UIKit
import AVFoundation

extension VideoPlayerView {
    
    // MARK: - Gestures for videoContainer
    
    /// Set pinch to zoom getsture to videoContainer
    func setPinchToZoomGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchedView))
        self.videoContainer.isUserInteractionEnabled = true
        self.videoContainer.addGestureRecognizer(pinchGesture)
    }
    
    @objc
    func pinchedView(sender: UIPinchGestureRecognizer) {
        guard let view = sender.view else { return }

        // Do not function when controls are locked
        if !controlsDisabled && !controlsLocked {
            if sender.scale > 0.75 && sender.scale < 4.0 {
                closeButton.isHidden = true
                zoomButton.isHidden = false
                view.transform = CGAffineTransformScale(
                    CGAffineTransformIdentity, sender.scale, sender.scale
                )
            }
            // Bounce back when sender's state is ended and sender's scale is less than 1
            if sender.state == .ended && sender.scale < 1 {
                zoomButton.isHidden = true
                closeButton.isHidden = controlsHidden && self.playPauseButton.isHidden
                view.transform = CGAffineTransformScale(
                    CGAffineTransformIdentity, 1, 1
                )
            }
        }
    }
    
    /// Add double tap and single tap gesture to videoContainer
    func addTapGesturesToVideoContainer() {
        let longTapGestures = UILongPressGestureRecognizer(target: self, action: #selector(pauseOnLongPress))
        // Initializer and assign UITapGestureRecognizer to video container
        // doubleTapGesture - for video seek (forward or backward)
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(seekVideoOnDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        
        // singleTapGesture - for show/hide player controls
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(videoContainerTapped))
        singleTapGesture.require(toFail: doubleTapGesture)
        singleTapGesture.numberOfTapsRequired = 1
        
        self.videoContainer.addGestureRecognizer(singleTapGesture)
        self.videoContainer.addGestureRecognizer(doubleTapGesture)
        self.videoContainer.addGestureRecognizer(longTapGestures)
    }
    
    @objc
    func pauseOnLongPress(touch: UILongPressGestureRecognizer) {
        if touch.state == .began {
            avPlayerLayer.player?.pause()
        } else {
            avPlayerLayer.player?.play()
        }
    }
    
    @objc
    func seekVideoOnDoubleTap(touch: UITapGestureRecognizer) {
        // Seek video based on double tap gestures
        // ------------
        // Double tap on left side will seek avplayer back 5 seconds.
        // ------------
        // Double tap on right size will seek avplayer forward 5 seconds.
        if !controlsDisabled && zoomButton.isHidden && !controlsLocked
            && avPlayerLayer.player?.currentItem?.currentTime() != avPlayerLayer.player?.currentItem?.duration {
            
            // Get touch location
            let touchPoint = touch.location(in: self)
            
            // We have to get the position based on x-axis
            // Get the mid position of frame with x-axis
            let viewMid = self.frame.midX
            
            // Forward
            if touchPoint.x > viewMid {
                forwardButton.sendActions(for: .touchUpInside)
            }
            // Back
            if touchPoint.x < viewMid {
                backwardButton.sendActions(for: .touchUpInside)
            }
        }
    }
    
    @objc
    func videoContainerTapped(touch: UITapGestureRecognizer) {
        // On tap of videoContainer, check value of controlsHidden
        // -----------------
        // If true cancel workItemControl and call showHideControls()
        // this will set the isHidden property of all the controls to true.
        // else set the controlsHidden value to !controlsHidden, to get true of false
        // -----------------
        // For false value call showHideControls()
        // and set the controlHidden to true.
                
        if controlsHidden && !lockButton.isHidden {
            workItemControls?.cancel()
            self.showHideControls()
        } else {
            controlsHidden = !controlsHidden
        }
        if !controlsHidden {
            self.showHideControls()
            self.controlsHidden = true
        }
    }
}
