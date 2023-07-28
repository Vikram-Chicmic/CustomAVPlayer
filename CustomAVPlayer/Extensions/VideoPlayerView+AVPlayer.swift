//
//  VideoPlayerView+AVPlayer.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit
import AVFoundation

// MARK: - Time observer to jump in video



extension VideoPlayerView {
    
    // MARK: - ui setup for av player
    func setAvPlayerLayer() {
        avPlayerLayer.frame = CGRect(origin: .zero, size: self.view.bounds.size)
        
        if !videoTitle.isEmpty {
            videoTitleLabel.isHidden = false
            videoTitleLabel.text = videoTitle
        }
        
        self.videoContainer.layer.addSublayer(avPlayerLayer)
        
        addControlsToSubview()
        setControlConstraints()
    }
    
    func addControlsToSubview() {
        self.view.addSubview(playPauseButton)
        self.view.addSubview(backwardButton)
        self.view.addSubview(forwardButton)
        self.view.addSubview(muteButton)
        self.view.addSubview(lockControls)
    }
    
    func setControlConstraints() {
        playPauseButton.center = view.center
        
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
        backwardButton.size = backwardButton.size
        backwardButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -48).isActive = true
        backwardButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.size = forwardButton.size
        forwardButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 38).isActive = true
        forwardButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.size = muteButton.size
        muteButton.topAnchor.constraint(equalTo: closePlayerButton.topAnchor, constant: 0).isActive = true
        muteButton.bottomAnchor.constraint(equalTo: closePlayerButton.bottomAnchor, constant: 0).isActive = true
        muteButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24).isActive = true
        
        lockControls.translatesAutoresizingMaskIntoConstraints = false
        lockControls.size = lockControls.size
        lockControls.topAnchor.constraint(equalTo: closePlayerButton.topAnchor, constant: 0).isActive = true
        lockControls.bottomAnchor.constraint(equalTo: closePlayerButton.bottomAnchor, constant: 0).isActive = true
        lockControls.trailingAnchor.constraint(equalTo: muteButton.leadingAnchor, constant: -24).isActive = true
    }
    
    func startAvPlayer() {
        avPlayerLayer.player = AVPlayer(url: url)
        
        let interval = CMTime(value: 1, timescale: 1)
        avPlayerLayer.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            self.timeLabels.setCurrentTime(value: Helper.getTimeString(seconds: seconds))
            if !self.slider.isTracking() {
                self.slider.setValue(Float(seconds), animated: true)
            }
        })
        
        let seconds = CMTimeGetSeconds(avPlayerLayer.player?.currentItem?.asset.duration ?? CMTime(seconds: .zero, preferredTimescale: .zero))
        timeLabels.setDuration(value: Helper.getTimeString(seconds: seconds))
        slider.maximumValue = Float(seconds)
        
        playPauseButton.avPlayer = avPlayerLayer.player
        forwardButton.avPlayer = avPlayerLayer.player
        forwardButton.isForward = true
        backwardButton.avPlayer = avPlayerLayer.player
        backwardButton.isForward = false
        muteButton.avPlayer = avPlayerLayer.player
        lockControls.avPlayer = avPlayerLayer.player
        
        avPlayerLayer.player = avPlayerLayer.player
        
        slider.addTarget(self, action: #selector(self.playbackSliderValueChanged),for: .valueChanged)
        
        setPinchToZoomGesture()
        
        avPlayerLayer.player?.play()
    }
    

    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider, event: UISlider.State)
        {
            print(slider.value)
            avPlayerLayer.player?.pause()
            
            let seconds : Int64 = Int64(slider.value)
            let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            
            avPlayerLayer.player?.seek(to: targetTime)
            
            if slider.isTracking() {
                        // If the slider is being touched, pause the video
                avPlayerLayer.player?.pause()
                    } else {
                        // If the slider is not being touched, resume the video
                        avPlayerLayer.player?.play()
                    }
        }
    
    // MARK: - slider gestures
    @objc func sliderValueDidChange() {
        let value = slider.value
        avPlayerLayer.player?.seek(to: CMTime(seconds: Double(value), preferredTimescale: .zero))
    }
    
    // MARK: - av player ui interactions
    func setPinchToZoomGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchedView))
        self.videoContainer.isUserInteractionEnabled = true
        self.videoContainer.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: - target methods
    @objc func pinchedView(sender: UIPinchGestureRecognizer) {
        guard let view = sender.view else { return }
        
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
            closePlayerButton.isHidden = false
            view.transform = CGAffineTransformScale(
                CGAffineTransformIdentity, 1, 1
            )
        }
    }
}
