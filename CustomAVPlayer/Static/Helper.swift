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
    
    static func setBackgroundImage(name: String, button: UIButton, iconColor: UIColor) {
        let image = UIImage(systemName: name)
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = iconColor
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.contentMode = .scaleAspectFill
//        button.contentHorizontalAlignment = .fill
//        button.contentVerticalAlignment = .fill
    }
}
