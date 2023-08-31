//
//  VideoPlayerView+AVPlayer.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit
import AVFoundation

extension VideoPlayerView {
    
    // MARK: - UI Setup
    
    /// Method to set AVPlayerLayer in videoContainer view
    func setAvPlayerLayer() {
        
        avPlayerLayer.frame = CGRect(origin: .zero, size: self.bounds.size)
        // Add avPlayerLayer to videoContainer view
        self.videoContainer.layer.addSublayer(avPlayerLayer)
        slider.addTarget(self, action: #selector(self.playbackSliderValueChanged), for: .valueChanged)
    }
    
    /// Method to start av player
    /// - Parameter videoURL: a url of the media file to be played
    public func startAvPlayer(videoURL: URL) {
        // Initialize AVPlayer with videoURL
        let player = AVPlayer(url: videoURL)
        avPlayerLayer.player = player
        // Add interval to update startTime
        let interval = CMTime(value: 1, timescale: 1)
        avPlayerLayer.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
            let seconds = CMTimeGetSeconds(progressTime)
            self.startTimeLabel.text = Helper.getTimeString(seconds: seconds)
            if !self.slider.isTracking() {
                self.slider.setValue(Float(seconds), animated: true)
            }
        })

        // Add observer for time control status
        avPlayerLayer.player?.addObserver(self, forKeyPath: ConstantString.timeControlStatus, options: [.old, .new], context: nil)
        
        // Set duration of video to endTime
        let seconds = CMTimeGetSeconds(avPlayerLayer.player?.currentItem?.asset.duration ?? CMTime(seconds: .zero, preferredTimescale: .zero))
        slider.maximumValue = Float(seconds)
        endTimeLabel.text = Helper.getTimeString(seconds: seconds)
        
        avPlayerLayer.player?.play()
    }
    
    public func startReelView(urlStrings: [String]) {
         self.videos = urlStrings
     }
    
    // MARK: Observers
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        
        let player = avPlayerLayer.player
        
        if player?.rate != 0 && player?.error == nil {
            playPauseIcon = pauseIcon
        } else if player?.currentItem?.currentTime() == player?.currentItem?.duration {
            forwardButton.isHidden = true
            backwardButton.isHidden = true
            playPauseButton.isHidden = false
            workItemControls?.cancel()
            playPauseIcon = replayIcon
            
            if controlsDisabled {
                // video replay
                avPlayerLayer.player?.seek(to: .zero)
                avPlayerLayer.player?.play()
            }
        } else {
            playPauseIcon = playIcon
        }
    }
    
    @objc
    func playbackSliderValueChanged(_ playbackSlider: UISlider, event: UISlider.State) {
        let seconds: Int64 = Int64(slider.value)
        let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)

        avPlayerLayer.player?.seek(to: targetTime)
        
        if avPlayerLayer.player?.currentTime() != avPlayerLayer.player?.currentItem?.duration {
            playPauseIcon = playIcon
        }
    }
    
    @objc
    func sliderValueDidChange() {
        let value = slider.value
        avPlayerLayer.player?.seek(to: CMTime(seconds: Double(value), preferredTimescale: .zero))
       
    }
}
