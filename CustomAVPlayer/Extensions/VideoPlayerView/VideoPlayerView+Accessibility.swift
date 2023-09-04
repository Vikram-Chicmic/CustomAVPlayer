//
//  VideoPlayerView+Accessibility.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit

extension VideoPlayerView {
    
    // MARK: - Color customization
    
    /// Method to set a common color for VideoPlayerView
    /// - Parameter color: UIColor for VideoPlayerView
    func setPlayerTint(color: UIColor?) {
        if let color {
            zoomIconTint = color
            closeIconTint = color
            playPauseIconTint = color
            seekIconTint = color
            muteIconTint = color
            lockIconTint = color
            
            timeLabelsTint = color
        }
    }
}
