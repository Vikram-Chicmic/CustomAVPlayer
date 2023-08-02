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
        
        avPlayerLayer.player?.addObserver(self, forKeyPath: ConstantString.timeControlStatus, options: [.old, .new], context: nil)
        
        // add av player to videoContainer view
        // this is necessary for pinch to zoom video gesture.
        self.videoContainer.layer.addSublayer(avPlayerLayer)
        
        setUpBottomView()
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
        
        // value changed target for slider
        slider.addTarget(self, action: #selector(self.playbackSliderValueChanged), for: .valueChanged)
        
        setPinchToZoomGesture()

        // play
        avPlayerLayer.player?.play()
    }
    
    // MARK: av player observers
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        let player = avPlayerLayer.player
        
        if player?.rate != 0 && player?.error == nil {
            playPauseButton.currentIcon = playPauseButton.iconPause
        } else if player?.currentItem?.currentTime() == player?.currentItem?.duration {
            forwardButton.isHidden = true
            backwardButton.isHidden = true
            playPauseButton.currentIcon = playPauseButton.iconReplay
        } else {
            playPauseButton.currentIcon = playPauseButton.iconPlay
        }
    }
}
