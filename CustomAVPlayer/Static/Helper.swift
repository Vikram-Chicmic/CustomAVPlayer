//
//  CommonMethods.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/26/23.
//

import Foundation
import UIKit

class Helper {
    
    static func getTimeString(seconds: Float64) -> String {
        let secondString = String(format: "%02d", Int(seconds) % 60)
        let minutString = String(format: "%02d", Int(seconds) / 60)
        return "\(minutString):\(secondString)"
    }
    
    static func setBackgroundImage(name: String, button: UIButton, iconColor: UIColor, size: Double) {
        let image = UIImage(systemName: name)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = iconColor
        button.imageView?.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    }
    
    static func animateSeekButtons(button: UIButton, rotationStart: CGFloat, rotationCompletion: CGFloat) {
        if button.isHidden {
            button.isHidden = false
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.duration = 0.3
        animation.fromValue = rotationStart
        animation.toValue = rotationCompletion
        button.layer.add(animation, forKey: nil)
    }
}
