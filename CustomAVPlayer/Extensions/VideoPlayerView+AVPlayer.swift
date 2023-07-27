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
        avPlayerLayer.frame = CGRect(origin: .zero, size: self.videoContainer.bounds.size)
        
        if !videoTitle.isEmpty {
            videoTitleLabel.isHidden = false
            videoTitleLabel.text = videoTitle
        }
        
        let player = AVPlayer(url: url)
        
        let interval = CMTime(value: 1, timescale: 1)
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
//            self.currentTime.text = Helper.getTimeString(seconds: seconds)
            self.slider.setValue(Float(seconds), animated: true)
        })
        
        let seconds = CMTimeGetSeconds(player.currentItem?.asset.duration ?? CMTime(seconds: .zero, preferredTimescale: .zero))
//        self.duration.text = Helper.getTimeString(seconds: seconds)
        slider.maximumValue = Float(seconds)
        
        avPlayerLayer.player = player
        
        self.videoContainer.layer.addSublayer(avPlayerLayer)
        
        setSlider()
        
        setPinchToZoomGesture()
        
        avPlayerLayer.player?.play()
    }
    
    // MARK: - slider
    func setSlider() {
        
        view.addSubview(slider)
       
//        slider.addTarget(self, action: #selector(self.touchUpInsideSlider), for: .)
        slider.addTarget(self, action: #selector(self.playbackSliderValueChanged),for: .valueChanged)
     
        
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        slider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        slider.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
    }
    

    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
        {
            print(slider.value)
            avPlayerLayer.player?.pause()
            let seconds : Int64 = Int64(slider.value)
            let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            
            avPlayerLayer.player?.seek(to: targetTime)
            
            if avPlayerLayer.player?.rate == 0
            {
                print(slider.value)
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
