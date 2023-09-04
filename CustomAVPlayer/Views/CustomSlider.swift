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
        
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1.5)
        }
        
        return true
    }
    
    // Tracks when drag event ends on slider
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        isSliding = false
        super.endTracking(touch, with: event)

        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
        }
    }
    
    // MARK: - Getter/Setter
    
    /// Getter method for isSlider
    /// - Returns: a bool value
    func isTracking() -> Bool {
        return isSliding
    }
}
