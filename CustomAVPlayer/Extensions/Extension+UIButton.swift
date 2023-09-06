//
//  Extension+UIButton.swift
//  CustomAVPlayer
//
//  Created by Nitin on 8/4/23.
//

import UIKit

extension UIButton {
    
    /// Method to set button size
    /// - Parameter size: CGFloat value for button size
    func setButtonSize(size: CGFloat) {
        let cgSize = CGSize(width: size, height: size)
        self.frame.size = cgSize
    }
}
