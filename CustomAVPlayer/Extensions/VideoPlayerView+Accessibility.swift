//
//  VideoPlayerView+Accessibility.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit

extension VideoPlayerView {
    
    // MARK: - change color
    
    func setPlayerTint(color: UIColor?) {
        zoomButton.imageView?.tintColor = color
        closeButton.imageView?.tintColor = color
        
        playPauseButton.imageView?.tintColor = color
        forwardButton.imageView?.tintColor = color
        backwardButton.imageView?.tintColor = color
        muteButton.imageView?.tintColor = color
        lockButton.imageView?.tintColor = color
        
        timeLabels.currentTime.textColor = color
        timeLabels.duration.textColor = color
    }
}
