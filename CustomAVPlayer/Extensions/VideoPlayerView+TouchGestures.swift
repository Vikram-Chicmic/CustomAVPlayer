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
    
    /// add pinch getsture to videoContainer
    func setPinchToZoomGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchedView))
        self.videoContainer.isUserInteractionEnabled = true
        self.videoContainer.addGestureRecognizer(pinchGesture)
    }
    
    /// add double tap and single tap gesture to videoContainer
    func addTapGesturesToVideoContainer() {
        // initializer and assign UITapGestureRecognizer to video container
        // doubleTapGesture - for video seek (forward or backward)
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(seekVideoOnDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        
        // singleTapGesture - for show/hide player controls
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(videoContainerTapped))
        singleTapGesture.require(toFail: doubleTapGesture)
        singleTapGesture.numberOfTapsRequired = 1
        
        self.videoContainer.addGestureRecognizer(singleTapGesture)
        self.videoContainer.addGestureRecognizer(doubleTapGesture)
    }
    
    // show hide controls
    func showHideControls() {
        
        if !controlsLocked {
            
            if avPlayerLayer.player?.currentItem?.currentTime() != avPlayerLayer.player?.currentItem?.duration {
                setView(view: backwardButton)
                setView(view: forwardButton)
            }
            
            setView(view: playPauseButton)
            
            if resetZoomButton.isHidden {
                setView(view: closePlayerButton)
            }
            
            setView(view: muteButton)
            
            setView(view: sliderTimeContainer)
            
            setView(view: lockButton)
            
        } else {
            setView(view: lockButton)
        }
    }
    
    func hideControls() {
        setView(view: backwardButton)
        setView(view: forwardButton)
        setView(view: playPauseButton)
        setView(view: closePlayerButton)
        setView(view: muteButton)
        setView(view: sliderTimeContainer)
    }
    
    // MARK: - gesture actions
    
    @objc
    func seekVideoOnDoubleTap(touch: UITapGestureRecognizer) {
        // seek video based on double tap gestures
        // ------------
        // double tap on left side will seek avplayer back 5 seconds.
        // ------------
        // double tap on right size will seek avplayer forward 5 seconds.
        if resetZoomButton.isHidden && !controlsLocked
            && avPlayerLayer.player?.currentItem?.currentTime() != avPlayerLayer.player?.currentItem?.duration {
            
            // get touch location
            let touchPoint = touch.location(in: self.view)
            
            // we have to get the position based on x-axis
            // get the mid position of frame with x-axis
            let viewMid = view.frame.midX
            
            // forward
            if touchPoint.x > viewMid {
                forwardButton.sendActions(for: .touchUpInside)
            }
            // back
            if touchPoint.x < viewMid {
                backwardButton.sendActions(for: .touchUpInside)
            }
        }
    }
    
    @objc
    func videoContainerTapped(touch: UITapGestureRecognizer) {
        
        // on tap of videoContainer, check value of controlsHidden
        // -----------------
        // if true cancel workItemControl and call showHideControls()
        // this will set the isHidden property of all the controls to true.
        // else set the controlsHidden value to !controlsHidden, to get true of false
        // -----------------
        // for false value call showHideControls()
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
    
    // MARK: - slider
    
    @objc
    func playbackSliderValueChanged(_ playbackSlider: UISlider, event: UISlider.State) {
        
//        if slider.isTracking() && workItemControls != nil {
//
//            workItemControls?.cancel()
//            workItemControls = nil
//        }
        
        let seconds: Int64 = Int64(slider.value)
        let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
        
        avPlayerLayer.player?.seek(to: targetTime)
        
//        if !slider.isTracking() {
//            controlsHidden = true
//        }
    }
    @objc
    func sliderValueDidChange() {
        let value = slider.value
        avPlayerLayer.player?.seek(to: CMTime(seconds: Double(value), preferredTimescale: .zero))
    }
    
    // MARK: - zoom in out
    
    @objc
    func pinchedView(sender: UIPinchGestureRecognizer) {
        guard let view = sender.view else { return }
        
        // do not function when controls are locked
        if !controlsLocked {
            if sender.scale > 0.75 && sender.scale < 4.0 {
                closePlayerButton.isHidden = true
                resetZoomButton.isHidden = false
                view.transform = CGAffineTransformScale(
                    CGAffineTransformIdentity, sender.scale, sender.scale
                )
            }
            
            // bounce back when sender's state is ended and sender's scale is less than 1
            if sender.state == .ended && sender.scale < 1 {
                resetZoomButton.isHidden = true
                closePlayerButton.isHidden = controlsHidden && self.playPauseButton.isHidden
                view.transform = CGAffineTransformScale(
                    CGAffineTransformIdentity, 1, 1
                )
            }
        }
    }
}
