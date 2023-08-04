//
//  VideoPlayerView+Additional.swift
//  CustomAVPlayer
//
//  Created by Nitin on 8/3/23.
//

import Foundation
import UIKit
import AVKit

extension VideoPlayerView {
    
    /// Method to removet titles from UIButton controls
    func removeButtonTitles() {
        self.zoomButton.setTitle("", for: .normal)
        self.closeButton.setTitle("", for: .normal)
        self.muteButton.setTitle("", for: .normal)
        self.lockButton.setTitle("", for: .normal)
        self.forwardButton.setTitle("", for: .normal)
        self.backwardButton.setTitle("", for: .normal)
        self.playPauseButton.setTitle("", for: .normal)
    }
    
    /// Method to show/hide controls
    func showHideControls() {
        if !controlsLocked {
            if avPlayerLayer.player?.currentItem == nil || (controlsDisabled || avPlayerLayer.player?.currentItem?.currentTime() != avPlayerLayer.player?.currentItem?.duration) {
                setView(view: backwardButton)
                setView(view: forwardButton)
            }
            if playPauseButton.imageView?.image != replayIcon {
                setView(view: playPauseButton)
            }
            if zoomButton.isHidden {
                setView(view: closeButton)
            }
            setView(view: muteButton)
            setView(view: timeLabelsStack)
            setView(view: lockButton)
            setView(view: slider)
        } else {
            setView(view: lockButton)
        }
    }
    
    /// Method to hideControls
    func hideControls() {
        setView(view: backwardButton)
        setView(view: forwardButton)
        setView(view: playPauseButton)
        setView(view: closeButton)
        setView(view: muteButton)
        setView(view: zoomButton)
        setView(view: timeLabelsStack)
        setView(view: slider)
    }
    
    /// Method to show/hide views
    /// - Parameter view: view to hide/show
    func setView(view: UIView) {
        UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
            view.isHidden = self.controlsHidden
        }
    }
    
    /// Method to seek video forward or backward
    /// - Parameters:
    ///   - button: forward or backward button
    ///   - rotationStartFrom: CGFloat value for start of animation for button rotation
    ///   - rotationEndTo: CGFloat value for end of animation for button rotation
    ///   - seek: value representing the seek time of video (forward or backward)
    func seekVideo(button: UIButton, rotationStartFrom: CGFloat, rotationEndTo: CGFloat, seek: CGFloat) {
        let avPlayer = avPlayerLayer.player

        Helper.animateButton(button: button, rotationStartFrom: rotationStartFrom, rotationEndTo: rotationEndTo)
        
        avPlayer?.seek(to: CMTime(seconds: (avPlayer?.currentTime().seconds)! + seek, preferredTimescale: 1))

        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            button.isHidden = self.controlsHidden && self.playPauseButton.isHidden
        }
    }
}
