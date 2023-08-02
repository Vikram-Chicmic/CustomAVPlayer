//
//  CustomSlider.swift
//  IbDesignableDemo
//
//  Created by ChicMic on 31/07/23.
//

import Foundation
import UIKit

@IBDesignable public class CustomSlider: UISlider {
    private var isSliding = false
    
    // MARK: - SLider height width Properties
    @IBInspectable public var sliderWidth: CGFloat = 200 {
         didSet {
             setNeedsLayout()
         }
     }
    
     @IBInspectable public var sliderHeight: CGFloat = 30 {
         didSet {
             setNeedsLayout()
         }
     }
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: sliderWidth, height: sliderHeight)
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: sliderWidth).isActive = true
        self.heightAnchor.constraint(equalToConstant: sliderHeight).isActive = true
    }

    // MARK: - Set Progress Bar Color
     @IBInspectable public var progressBarColor: UIColor = .white {
         didSet {
             updateProgressBarColor()
         }
     }
    private func updateProgressBarColor() {
        minimumTrackTintColor = progressBarColor
        maximumTrackTintColor = progressBarColor.withAlphaComponent(0.3)
    }
    
    // MARK: - Set Thumb Image
    @IBInspectable public var thumbImage: UIImage? {
        didSet {
            setThumbImage(image: thumbImage ?? UIImage(), state: thumbState ?? .normal,width: thumbWidth, height: thumbHeight, color: thumbColor)
        }
    }
    
    // MARK: - to change thumb state (Currently not using)
    private var thumbState: UIControl.State? = .normal
    @IBInspectable public var barState: UIControl.State  = .normal {
        didSet {
            self.thumbState = barState
        }
    }
    @IBInspectable public var sameForAllState: Bool = true {
        didSet {
            setThumbImageSize()
        }
    }

// MARK: - Set Thumb Color
     @IBInspectable public var thumbColor: UIColor = .white {
         didSet {
             setThumbColor()
         }
     }
    public func setThumbColor() {
        self.thumbTintColor = thumbColor
    }
    
    
    // MARK: - Hide Thumb
    @IBInspectable public var hideThumb: Bool = false {
        didSet {
            hideSliderThumb()
        }
    }
    public func hideSliderThumb() {
        if hideThumb {
            self.setThumbImage(UIImage(), for: .highlighted)
            self.setThumbImage(UIImage(), for: .normal)
        }
    }
    
    
// MARK: - Show and Hide ProgressBar
     @IBInspectable public var hideProgressBar: Bool = false {
         didSet {
             showSlider()
         }
     }
    private func showSlider() {
        self.isHidden = hideProgressBar
    }
    

    // MARK: - Set user Interaction with slider
     @IBInspectable public var interactionEnabled: Bool = true {
         didSet {
             setUserInteraction()
         }
     }
    private func setUserInteraction() {
        self.isUserInteractionEnabled = interactionEnabled
    }
    
    
// MARK: - Set Thumb Image Size
    private var thumbImageHeight: CGFloat? = 20
    private var thumbImageWidth: CGFloat? = 20

    @IBInspectable var thumbHeight: CGFloat = 20 {
        didSet {
            thumbImageHeight = thumbHeight
            setThumbImageSize()
        }
    }
    
    @IBInspectable var thumbWidth: CGFloat = 20 {
        didSet {
            thumbImageWidth = thumbWidth
            setThumbImageSize()
        }
    }
    
    private func setThumbImageSize() {
        guard var resizedImage = thumbImage else { return }
        
             resizedImage = resizeThumbImage(image: resizedImage, to: CGSize(width: thumbImageWidth!, height: thumbImageHeight!))
            // set image color
            let coloredImage = resizedImage.withRenderingMode(.alwaysTemplate)
            UIGraphicsBeginImageContextWithOptions(resizedImage.size, false, coloredImage.scale)
            thumbColor.set()
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
    
    // slider thumb programmatically
    public func setThumbImage(image: UIImage, state: UIControl.State = .normal, width: CGFloat, height: CGFloat, color: UIColor = .white) {
        var resizedImage = image
        resizedImage = resizeThumbImage(image: image, to: CGSize(width: width, height: height))
        
        // set image color
        let coloredImage = resizedImage.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(resizedImage.size, false, coloredImage.scale)
        color.set()
        coloredImage.draw(in: CGRect(origin: .zero, size: resizedImage.size))
        resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? resizedImage
        UIGraphicsEndImageContext()
        
        self.setThumbImage(resizedImage, for: state)
    }
    
    // MARK: - Funciton to resize the image
    private func resizeThumbImage(image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? image
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
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
         isSliding = true
        
         // Jump to the touched position during a single tap
         let point = touch.location(in: self)
         let percentage = Float(point.x / self.frame.width)
         let range = maximumValue - minimumValue
         let value = minimumValue + range * percentage
         setValue(value, animated: true)
         sendActions(for: .valueChanged)
        
        setThumbImage(image: thumbImage ?? UIImage(), state: thumbState ?? .normal,width: thumbWidth*0.5, height: thumbHeight*0.5, color: thumbColor.withAlphaComponent(0.7))
         
         return true
     }
     
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
         isSliding = false
         super.endTracking(touch, with: event)
        setThumbImage(image: thumbImage ?? UIImage(), state: thumbState ?? .normal,width: thumbWidth, height: thumbHeight, color: thumbColor)
        
     }
     
     func isTracking() -> Bool {
         return isSliding
     }
}
