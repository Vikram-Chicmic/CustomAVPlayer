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
    
    // MARK: - show/hide components
    func timerViewShowHide() {
        timeStackView.isHidden = timerViewIsHidden
    }
    
    // MARK: - change color
    func setPlayerTint(color: UIColor) {
        setIconColor(color: color)
        setTextColor(color: color)
        setSliderColor(color: color)
        setThumbColor(color: color)
    }
    
    func setColors() {
        setIconColor(color: iconColor)
        setTextColor(color: textColor)
        setSliderColor(color: sliderProgressTint)
        setThumbColor(color: thumbColor)
    }
    
    func setIconColor(color: UIColor) {
        resetZoomButton.imageView?.tintColor = color
    }
    
    func setTextColor(color: UIColor) {
        videoTitleLabel.textColor = color
        currentTime.textColor = color
        duration.textColor = color
    }
    
    func setSliderColor(color: UIColor) {
        slider.progressBarColor = color
    }
    
    func setThumbColor(color: UIColor) {
        slider.thumbColor = color
    }
    
    // MARK: - change font
    func setTextFont() {
        videoTitleLabel.font = textFont
        currentTime.font = textFont
        duration.font = textFont
    }
}
