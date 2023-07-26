//
//  VideoPlayerView+AVPlayer.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit
import AVFoundation

extension VideoPlayerView {
    
    // MARK: - ui setup for av player
    func setAvPlayerLayer() {
        avPlayerLayer.frame = CGRect(origin: .zero, size: self.videoContainer.bounds.size)
        
        if !videoTitle.isEmpty {
            videoTitleLabel.isHidden = false
            videoTitleLabel.text = videoTitle
        }
        
        let player = AVPlayer(url: url)
        
        let interval = CMTime(value: 1, timescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            self.currentTime.text = Helper.getTimeString(seconds: seconds)
            self.slider.setValue(Float(seconds), animated: true)
        })
        
        let seconds = CMTimeGetSeconds(player.currentItem?.asset.duration ?? CMTime(seconds: .zero, preferredTimescale: .zero))
        self.duration.text = Helper.getTimeString(seconds: seconds)
        slider.maximumValue = Float(seconds)
        
        avPlayerLayer.player = player
        
        self.videoContainer.layer.addSublayer(avPlayerLayer)
        
        setSlider(slider: slider)
        
        setPinchToZoomGesture()
        
        avPlayerLayer.player?.play()
    }
    
    // MARK: - slider
    func setSlider(slider: CustomSlider) {
        
        videoContainer.addSubview(slider)
        
//        slider.addTarget(self, action: #selector(self.sliderValueDidChange), for: .valueChanged)
        
        slider.translatesAutoresizingMaskIntoConstraints = false

        switch sliderPosition {
        case .defaultPosition:
            slider.leadingAnchor.constraint(equalTo:timeStackView.leadingAnchor, constant: 0).isActive = true
            slider.trailingAnchor.constraint(equalTo:timeStackView.trailingAnchor, constant: 0).isActive = true
            slider.bottomAnchor.constraint(equalTo:timeStackView.topAnchor, constant: -10).isActive = true
        case .bottomSticked:
            timerViewIsHidden = true
            timerViewShowHide()
            slider.hideSliderThumb()
            slider.leadingAnchor.constraint(equalTo:videoContainer.leadingAnchor, constant: 0).isActive = true
            slider.trailingAnchor.constraint(equalTo:videoContainer.trailingAnchor, constant: 0).isActive = true
            slider.bottomAnchor.constraint(equalTo:videoContainer.bottomAnchor, constant: -10).isActive = true
        case .hidden:
            slider.hideProgressBar = true
            timerViewIsHidden = true
            timerViewShowHide()
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
            resetZoomButton.isHidden = false
            view.transform = CGAffineTransformScale(
                CGAffineTransformIdentity, sender.scale, sender.scale
            )
        }
        
        // bounce back when sender's state is ended and sender's scale is less than 1
        if sender.state == .ended && sender.scale < 1 {
            resetZoomButton.isHidden = true
            view.transform = CGAffineTransformScale(
                CGAffineTransformIdentity, 1, 1
            )
        }
    }
}
