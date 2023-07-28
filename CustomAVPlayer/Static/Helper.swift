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
        button.imageView?.contentMode = .scaleAspectFill
        button.imageEdgeInsets = UIEdgeInsets(top: size, left: size, bottom: size, right: size)
    }
}
