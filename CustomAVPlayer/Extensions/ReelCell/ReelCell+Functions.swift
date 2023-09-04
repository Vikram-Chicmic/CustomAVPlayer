//
//  ReelCell+Functions.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 01/09/23.
//

import Foundation
import UIKit
import AVFoundation

extension ReelCell {
    // MARK: - Toggle Mute
    @objc func toggleMute() {
        if let player = playerLayer.player {
            player.isMuted = !player.isMuted
            muteIcon.setImage(player.isMuted ? videoPlayerView?.muteIcon : videoPlayerView?.unmuteIcon, for: .normal)
            // Update the mute state in the VideoPlayerView
            if let videoPlayerView = videoPlayerView {
                videoPlayerView.isMute = player.isMuted
            }
        }
    }
    
    // MARK - Toggle Play/Pause
    @objc func togglePlayPause() {
        if let player = playerLayer.player {
            if player.rate == 0.0 {
                player.play()
            } else {
                player.pause()
            }
        }
    }


    // MARK: - Pause on Long Press
    @objc func pauseOnLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            playerLayer.player?.pause()
            muteLabel.text = "Paused"
        } else if sender.state == .ended {
            playerLayer.player?.play()
            muteLabel.text = playerLayer.player?.isMuted ?? false ? "Mute" : "Unmute"
        }
    }
    
     // MARK: - Playback Control
     @objc func playerDidFinishPlaying(notification: NSNotification) {
         playerLayer.player?.seek(to: .zero)
         playerLayer.player?.play()
     }
    
    @objc func sliderValueChanged() {
        guard let slider = slider else { return }
        if let duration = playerLayer.player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(slider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            playerLayer.player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
    
    // MARK: - Time Observer
     func addTimeObserver() {
        let interval = CMTime(value: 1, timescale: 1)
         playerLayer.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (progressTime) in
            guard let self = self else { return }
            let seconds = CMTimeGetSeconds(progressTime)
            let duration = CMTimeGetSeconds(self.playerLayer.player?.currentItem?.duration ?? .zero)
            if duration > 0 {
                let progress = Float(seconds / duration)
                self.slider?.setValue(progress, animated: true)
            }
        })
    }
    
    func pauseVideo() {
        playerLayer.player?.pause()
    }

    func playVideo() {
        playerLayer.player?.play()
    }

    func restartVideo() {
        playerLayer.player?.seek(to: .zero)
        playerLayer.player?.play()
    }
    
    func updateMuteState(isMuted: Bool) {
        playerLayer.player?.isMuted = isMuted
    }
    
    // MARK: - Tap Function
    func configureTapFunciton() {
        if videoPlayerView?.tapFunctionForReel == .muteUnmute {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleMute))
            tapGesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(tapGesture)
        } else {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(togglePlayPause))
            tapGesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(tapGesture)
        }
    }
}
