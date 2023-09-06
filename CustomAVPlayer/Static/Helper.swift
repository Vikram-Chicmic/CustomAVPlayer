//
//  CommonMethods.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/26/23.
//

import Foundation
import UIKit

class Helper {
    
    /// Method to get time in mm:ss time format
    /// - Parameter seconds: seconds in float
    /// - Returns: string value
    static func getTimeString(seconds: Float64) -> String {
        let secondString = String(format: ConstantString.numberFormat00, Int(seconds) % 60)
        let minutString = String(format: ConstantString.numberFormat00, Int(seconds) / 60)
        return "\(minutString):\(secondString)"
    }
    
    /// Method to animate seek button
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
