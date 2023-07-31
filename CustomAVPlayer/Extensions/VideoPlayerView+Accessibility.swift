//
//  VideoPlayerView+Accessibility.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit

extension VideoPlayerView {
    
    // MARK: - change button icon
    
    func setResetZoomIcon(icon: UIImage) {
        resetZoomButton.setImage(icon, for: .normal)
    }
    
    // MARK: - change color
    
    func setPlayerTint(color: UIColor) {
        setIconColor(color: color)
        setTextColor(color: color)
    }
    
    func setColors() {
        setIconColor(color: iconColor)
        setTextColor(color: textColor)
    }
    
    func setIconColor(color: UIColor) {
        resetZoomButton.imageView?.tintColor = color
        closePlayerButton.imageView?.tintColor = color
        playPauseButton.iconColor = color
        forwardButton.iconColor = color
        backwardButton.iconColor = color
        muteButton.iconColor = color
    }
    
    func setTextColor(color: UIColor) {
        videoTitleLabel.textColor = color
        timeLabels.color = color
    }
    
    // MARK: - change font
    
    func setTextFont() {
        videoTitleLabel.font = textFont
        timeLabels.font = textFont
    }
}
