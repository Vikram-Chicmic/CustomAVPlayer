//
//  VideoPlayerView+IBActions.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 8/4/23.
//

import Foundation
import UIKit
import AVKit

extension VideoPlayerView {
    // MARK: - IB Actions

    @IBAction func resetZoomTapped(_ sender: UIButton) {
        self.videoContainer.transform = CGAffineTransformScale(
            CGAffineTransformIdentity, 1, 1
        )
        zoomButton.isHidden = true
        closeButton.isHidden = controlsHidden && self.playPauseButton.isHidden
    }

    @IBAction func closePlayerTapped(_ sender: UIButton) {
        avPlayerLayer.player?.replaceCurrentItem(with: nil)
    }

    @IBAction func lockButtonTapped(_ sender: UIButton) {
        if controlsLocked {
            controlsLocked = false
            controlsHidden = false
            // Reset
            self.showHideControls()
            self.controlsHidden = true
        } else {
            controlsLocked = true
            controlsHidden = true
            hideControls()
        }
        lockButton.setImage(controlsLocked ? lockIcon : unlockIcon, for: .normal)
    }

    @IBAction func muteButtonTapped(_ sender: Any) {
        avPlayerLayer.player?.isMuted.toggle()
        guard let muted = avPlayerLayer.player?.isMuted else { return }
        muteButton.setImage(muted ? muteIcon : unmuteIcon, for: .normal)
    }

    @IBAction func playPauseButtonTapped(_ sender: Any) {
        let player = avPlayerLayer.player

        if player?.timeControlStatus == .playing {
            player?.pause()
        } else {
            if player?.currentItem?.currentTime() == player?.currentItem?.duration {
                player?.seek(to: CMTime.zero)
                if !controlsDisabled {
                    forwardButton.isHidden = false
                    backwardButton.isHidden = false
                }
            }
            player?.play()
        }
    }

    @IBAction func forwardButtonTapped(_ sender: Any) {
        seekVideo(button: forwardButton, rotationStartFrom: 0, rotationEndTo: 2 * .pi, seek: seekTime)
    }

    @IBAction func backwardButtonTapped(_ sender: Any) {
        seekVideo(button: backwardButton, rotationStartFrom: 2 * .pi, rotationEndTo: 0, seek: -(seekTime))
    }
}
