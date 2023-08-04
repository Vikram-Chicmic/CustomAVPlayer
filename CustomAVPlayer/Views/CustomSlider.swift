//
//  CustomSlider.swift
//  IbDesignableDemo
//
//  Created by ChicMic on 31/07/23.
//

import UIKit

class CustomSlider: UISlider {
    
    // MARK: - Properties
    
    private var isSliding = false
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSlider()
    }
    
    // MARK: - Methods
    
    // Set Slider
    private func setupSlider() {
        updateSliderLayout()
    }
    
    private func updateSliderLayout() {
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    // MARK: - Events
    
    // Tracks when drag event starts
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        isSliding = true
        
        let point = touch.location(in: self)
        let percentage = Float(point.x / self.frame.width)
        let range = maximumValue - minimumValue
        let value = minimumValue + range * percentage
        
        setValue(value, animated: true)
        sendActions(for: .valueChanged)
//        setThumbImage(image: thumbImage ?? UIImage(), state: thumbState ?? .normal,width: thumbWidth*0.5, height: thumbHeight*0.5, color: thumbColor.withAlphaComponent(0.7))
        return true
    }
    
    // Tracks when drag event ends on slider
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isSliding = false
        super.endTracking(touch, with: event)
//        setThumbImage(image: thumbImage ?? UIImage(), state: thumbState ?? .normal,width: thumbWidth, height: thumbHeight, color: thumbColor)
    }
    
    // MARK: - Getter/Setter
    
    /// Getter method for isSlider
    /// - Returns: a bool value
    func isTracking() -> Bool {
        return isSliding
    }
}
