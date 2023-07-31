//
//  VideoPlayerView+AVPlayer.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit
import AVFoundation

extension VideoPlayerView {
    
    // MARK: - ui setup for avplayer
    
    // method to set up av player
    func setAvPlayerLayer() {
        // set av player frame
        avPlayerLayer.frame = CGRect(origin: .zero, size: self.view.bounds.size)
        
        // add title to video if videoTitle is not empty
        if !videoTitle.isEmpty {
            videoTitleLabel.isHidden = false
            videoTitleLabel.text = videoTitle
        }
        
        // add av player to videoContainer view
        // this is necessary for pinch to zoom video gesture.
        self.videoContainer.layer.addSublayer(avPlayerLayer)
        
        addControlsToSubview()
        setControlConstraints()
        setUpBottomView()
    }
    
    // method to add button controls as subviews
    func addControlsToSubview() {
        self.view.addSubview(playPauseButton)
        self.view.addSubview(backwardButton)
        self.view.addSubview(forwardButton)
        self.view.addSubview(muteButton)
        self.view.addSubview(lockControlsButton)
    }
    
    /// show hide view with animation
    func setView(view: UIView) {
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve) {
            view.isHidden = self.controlsHidden
        }
    }
    
    /// set up bottom view which contains
    /// a slider and time labels for video player
    func setUpBottomView() {
        // timeLabels - show video current time and duration
        sliderTimeContainer.addFirstView(timeLabels)
        // slider - slider for video player
        sliderTimeContainer.addSecondView(slider)
        
        self.view.addSubview(sliderTimeContainer)
        sliderTimeContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderTimeContainer.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            sliderTimeContainer.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            sliderTimeContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
    }
    
    /// method to set constrainst for views and controls
    func setControlConstraints() {
        playPauseButton.center = view.center
        
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.size = backwardButton.size
        backwardButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -48).isActive = true
        backwardButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.size = forwardButton.size
        forwardButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 48).isActive = true
        forwardButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.size = muteButton.size
        muteButton.topAnchor.constraint(equalTo: closePlayerButton.topAnchor, constant: 0).isActive = true
        muteButton.bottomAnchor.constraint(equalTo: closePlayerButton.bottomAnchor, constant: 0).isActive = true
        muteButton.trailingAnchor.constraint(equalTo: lockControlsButton.leadingAnchor, constant: -24).isActive = true
    }
    
    /// set lock control button to view
    func setLockControlsButton() {
        Helper.setBackgroundImage(name: LockControlsImage.lock.rawValue, button: lockControlsButton, iconColor: .systemBackground, size: ButtonSize.small.rawValue)
        lockControlsButton.addTarget(self, action: #selector(lockControls), for: .touchUpInside)
    
        lockControlsButton.translatesAutoresizingMaskIntoConstraints = false
        lockControlsButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        lockControlsButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        lockControlsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        lockControlsButton.topAnchor.constraint(equalTo: closePlayerButton.topAnchor).isActive = true
    }
    
    // MARK: - start avplayer
    
    /// method to initialize and start playing video on avplayer
    func startAvPlayer() {
        avPlayerLayer.player = AVPlayer(url: url)
        
        // set durationLabel in labels view
        // and set max value for slider
        let seconds = CMTimeGetSeconds(self.avPlayerLayer.player?.currentItem?.asset.duration ?? CMTime(seconds: .zero, preferredTimescale: .zero))
        slider.maximumValue = Float(seconds)
        self.timeLabels.setDuration(value: Helper.getTimeString(seconds: seconds))
        
        // add interval to update the currentTime label in labels view
        // and update value of slider
        let interval = CMTime(value: 1, timescale: 1)
        avPlayerLayer.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            self.timeLabels.setCurrentTime(value: Helper.getTimeString(seconds: seconds))
            if !self.slider.isTracking() {
                self.slider.setValue(Float(seconds), animated: true)
            }
        })
        
        // initializer required properties for the views
        playPauseButton.avPlayer = avPlayerLayer.player
        forwardButton.avPlayer = avPlayerLayer.player
        forwardButton.isForward = true
        backwardButton.avPlayer = avPlayerLayer.player
        backwardButton.isForward = false
        muteButton.avPlayer = avPlayerLayer.player
        
        // value changed target for slider
        slider.addTarget(self, action: #selector(self.playbackSliderValueChanged), for: .valueChanged)
        
        setPinchToZoomGesture()

        // play
        avPlayerLayer.player?.play()
    }
}
