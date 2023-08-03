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
    
    func removeButtonTitles() {
        self.zoomButton.setTitle("", for: .normal)
        self.closeButton.setTitle("", for: .normal)
        self.muteButton.setTitle("", for: .normal)
        self.lockButton.setTitle("", for: .normal)
        self.forwardButton.setTitle("", for: .normal)
        self.backwardButton.setTitle("", for: .normal)
        self.playPauseButton.setTitle("", for: .normal)
    }
    
    func seekVideo(button: UIButton, rotationStartFrom: CGFloat, rotationEndTo: CGFloat, seek: CGFloat) {
        let avPlayer = avPlayerLayer.player

        Helper.animateButton(button: button, rotationStartFrom: rotationStartFrom, rotationEndTo: rotationEndTo)

        if Double((avPlayer?.currentItem?.duration.seconds)!) - Double((avPlayer?.currentTime().seconds)!) > seekTime {
            avPlayer?.seek(to: CMTime(seconds: (avPlayer?.currentTime().seconds)! + seek, preferredTimescale: 1))
        } else {
            avPlayer?.seek(to: (avPlayer?.currentItem!.duration)!)
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            button.isHidden = self.controlsHidden && self.playPauseButton.isHidden
        }
    }
}
