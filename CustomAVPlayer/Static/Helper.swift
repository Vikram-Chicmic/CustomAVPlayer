//
//  CommonMethods.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/26/23.
//

import Foundation
import UIKit

class Helper {
    
    /// method to get time in mm:ss time format
    /// - Parameter seconds: seconds in float
    /// - Returns: string value
    static func getTimeString(seconds: Float64) -> String {
        let secondString = String(format: ConstantString.numberFormat00, Int(seconds) % 60)
        let minutString = String(format: ConstantString.numberFormat00, Int(seconds) / 60)
        return "\(minutString):\(secondString)"
    }
    
    /// method to set backround image to the button
    /// - Parameters:
    ///   - name: name of image
    ///   - button: button to set image for
    ///   - iconColor: color of the icon
    ///   - size: size in double
    static func setButtonImage(name: String, button: UIButton, iconColor: UIColor, size: Double) {
        let image = UIImage(systemName: name)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = iconColor
        // note: set content mode to .scaleToFill
        // - makes the image occupy available space and fill the view.
        // - using other result in clipping of image or unwanted size.
        button.imageView?.contentMode = .scaleToFill
        button.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    }
    
    /// method to animate seek button
    /// - Parameters:
    ///   - button: forward or backward button
    ///   - rotationStartFrom: start position for animation
    ///   - rotationEndTo: end position for animation
    static func animateButton(button: UIButton, rotationStartFrom: CGFloat, rotationEndTo: CGFloat) {
        // before starting animation make the button visible
        if button.isHidden {
            button.isHidden = false
        }
        let animation = CABasicAnimation(keyPath: ConstantString.transformRotation)
        animation.duration = 0.3
        animation.fromValue = rotationStartFrom
        animation.toValue = rotationEndTo
        button.layer.add(animation, forKey: nil)
    }
}
