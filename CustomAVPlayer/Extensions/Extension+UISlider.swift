//
//  Extension+UISlider.swift
//  CustomAVPlayer
//
//  Created by Nitin on 8/4/23.
//

import UIKit

extension UISlider {
    
    /// Method to set slider size
    /// - Parameters:
    ///   - height: height of slider
    ///   - width: width of slider
    func setSliderSize(height: CGFloat, width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    /// Method to set slider color
    /// - Parameter color: color for slider
    func setSliderTint(color: UIColor) {
        self.minimumTrackTintColor = color
        self.maximumTrackTintColor = color.withAlphaComponent(0.3)
    }
    

    
    func setThumbImage(image: UIImage, state: UIControl.State = .normal, width: CGFloat, height: CGFloat, color: UIColor, sameForAllState: Bool = false) {
        var resizedImage = image
        
       
            resizedImage = resizeThumbImage(image: image, to: CGSize(width: width, height: height))
        
        
    
            let coloredImage = resizedImage.withRenderingMode(.alwaysTemplate)
            UIGraphicsBeginImageContextWithOptions(resizedImage.size, false, coloredImage.scale)
            color.set()
            coloredImage.draw(in: CGRect(origin: .zero, size: resizedImage.size))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? resizedImage
            UIGraphicsEndImageContext()
        
        
        self.setThumbImage(resizedImage, for: state)
        
        if sameForAllState {
            let states: [UIControl.State] = [.normal, .disabled, .focused, .highlighted, .selected]
            for state in states {
                self.setThumbImage(resizedImage, for: state)
            }
        }
    }

    
    /// Method to resize thumb image
    /// - Parameters:
    ///   - image: image to resize
    ///   - size: size for resizing
    /// - Returns: a resized UIImage
    func resizeThumbImage(image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? image
    }
    
    
    
    /// Method to hide/show slider
    /// - Parameter hide: bool value to check if thumb is hidden
    func hideSliderThumb(hide: Bool) {
        if hide {
            self.setThumbImage(UIImage(), for: .highlighted)
            self.setThumbImage(UIImage(), for: .normal)
        }
    }
}
