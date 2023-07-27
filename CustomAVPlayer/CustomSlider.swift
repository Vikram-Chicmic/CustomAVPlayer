
//
//  CustomSlider.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 25/07/23.
//

import UIKit

public class CustomSlider: UISlider {
    
    private var isSliding = false
    
    // slider width
    private var sliderWidth: CGFloat = 200 {
        didSet {
            updateSliderLayout()
        }
    }
    // slider height
    private var sliderHeight: CGFloat = 30 {
        didSet {
            updateSliderLayout()
        }
    }
    
    // progress tint
    public var progressBarColor: UIColor = .white {
        didSet {
            updateProgressBarColor()
        }
    }
    
    public var thumbColor: UIColor = .white {
        didSet {
            setThumbColor()
        }
    }
    
    // visibility
    public var hideProgressBar: Bool = false {
        didSet {
            showSlider()
        }
    }
    
    // slider interaction
    public var interactionEnabled: Bool = true {
        didSet {
            setUserInteraction()
        }
    }
    
    // override content size
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: sliderWidth, height: sliderHeight)
    }
    
    // initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSlider()
    }
    
    // slider view
    private func setupSlider() {
        updateSliderLayout()
        updateProgressBarColor()
    }
    
    private func updateSliderLayout() {
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    func showSlider() {
        self.isHidden = hideProgressBar
    }
    
    private func updateProgressBarColor() {
        minimumTrackTintColor = progressBarColor
        maximumTrackTintColor = progressBarColor.withAlphaComponent(0.3)
    }
    
    // slider thumb
    public func setThumbImage(image: UIImage, state: UIControl.State = .normal, size: IconSize = .medium, color: UIColor = .white) {
        
        var resizedImage = image
        resizedImage = resizeThumbImage(image: image, to: CGSize(width: size.rawValue, height: size.rawValue))
        
        // set image color
        let coloredImage = resizedImage.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(resizedImage.size, false, coloredImage.scale)
        color.set()
        coloredImage.draw(in: CGRect(origin: .zero, size: resizedImage.size))
        resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? resizedImage
        UIGraphicsEndImageContext()
        
        self.setThumbImage(resizedImage, for: state)
    }
    
    private func resizeThumbImage(image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? image
    }
    
    public func setThumbColor() {
        self.thumbTintColor = thumbColor
    }
    
    public func hideSliderThumb() {
        self.setThumbImage(UIImage(), for: .highlighted)
        self.setThumbImage(UIImage(), for: .normal)
    }
    
    // slider interactions
//    public func enableTapGestureJump() {
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
//        self.addGestureRecognizer(tapGesture)
//    }
    
    private func setUserInteraction() {
        self.isUserInteractionEnabled = interactionEnabled
    }
    
//    @objc func sliderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
//         // calculate the value of the UISlider based on the location of the tap
//         let point = gestureRecognizer.location(in: self)
//         let percentage = Float(point.x / self.frame.width)
//         let range = self.maximumValue - self.minimumValue
//         let value = self.minimumValue + range * percentage
//
//         // set the value of the UISlider to the calculated value
//         self.setValue(value, animated: true)
//     }
    
    
    // MARK: - Function to recognize tap and drag gesture and call function for .valueChanged for seek
//    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//          let point = touch.location(in: self)
//          let percentage = Float(point.x / self.frame.width)
//          let range = self.maximumValue - self.minimumValue
//          let value = self.minimumValue + range * percentage
//          self.setValue(value, animated: true)
//          sendActions(for: .valueChanged)
//          return true
//      }
  
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
         isSliding = true
         
         // Jump to the touched position during a single tap
         let point = touch.location(in: self)
         let percentage = Float(point.x / self.frame.width)
         let range = maximumValue - minimumValue
         let value = minimumValue + range * percentage
         setValue(value, animated: true)
         sendActions(for: .valueChanged)
         
         return true
     }
     
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
         isSliding = false
         super.endTracking(touch, with: event)
     }
     
     func isTracking() -> Bool {
         return isSliding
     }
}
