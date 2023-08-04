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
    
    /// Method to set image for slider thumb
    /// - Parameters:
    ///   - image: UIImage for slider thumb
    ///   - state: state of slider
    ///   - width: thumb width
    ///   - height: thumb height
    ///   - color: color for thumb
    func setThumbImage(image: UIImage, state: UIControl.State = .normal, width: CGFloat, height: CGFloat, color: UIColor = .white) {
        var resizedImage = image
        resizedImage = resizeThumbImage(image: image, to: CGSize(width: width, height: height))
        
        let coloredImage = resizedImage.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(resizedImage.size, false, coloredImage.scale)
        color.set()
        coloredImage.draw(in: CGRect(origin: .zero, size: resizedImage.size))
        resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? resizedImage
        UIGraphicsEndImageContext()
        
        self.setThumbImage(resizedImage, for: state)
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
    
    /// Method to set size of thumb image
    /// - Parameters:
    ///   - image: image for thumb
    ///   - height: height of thumb image
    ///   - width: width of thumb image
    ///   - sameForAllState: state of thumb
    func setThumbImageSize(image: UIImage, height: CGFloat, width: CGFloat, sameForAllState: Bool) {
        var resizedImage = image
        
        resizedImage = resizeThumbImage(image: resizedImage, to: CGSize(width: height, height: width))
        // set image color
        let coloredImage = resizedImage.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(resizedImage.size, false, coloredImage.scale)
        self.thumbTintColor?.set()
        coloredImage.draw(in: CGRect(origin: .zero, size: resizedImage.size))
        resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? resizedImage
        UIGraphicsEndImageContext()
        self.setThumbImage(resizedImage, for: state)
        if sameForAllState {
            self.setThumbImage(resizedImage, for: .normal)
            self.setThumbImage(resizedImage, for: .disabled)
            self.setThumbImage(resizedImage, for: .focused)
            self.setThumbImage(resizedImage, for: .highlighted)
            self.setThumbImage(resizedImage, for: .selected)
            
        }
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
