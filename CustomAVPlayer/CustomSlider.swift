//
//  CustomSlider.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 25/07/23.
//

import UIKit

public enum sliderPOsition {
    case topSticked
    case bottomSticked
    case custom
}

public enum height: CFloat {
    case small = 10
    case medium = 20
    case large = 30
}

public class CustomSlider: UISlider {
    // Customizable properties
    public var sliderWidth: CGFloat = 200 {
        didSet {
            updateSliderLayout()
        }
    }
    
    public var sliderHeight: CGFloat = 30 {
        didSet {
            updateSliderLayout()
        }
    }
    
    // MARK: - Change Progress Bar color
    public var progressBarColor: UIColor = .blue {
        didSet {
            updateProgressBarColor()
        }
    }
    
    // MARK: - Hide Progress Bar
    public var hideProgressBar: Bool = false {
        didSet {
            showSlider()
        }
    }
    func showSlider() {
        self.isHidden = hideProgressBar
    }
    
    
    // Current progress (percentage value between 0 and 1)
    public var progress: Float = 0 {
        didSet {
            updateProgress()
        }
    }
    
    // Timer to update the progress continuously
    private var progressTimer: Timer?
    
    
    // MARK: - Funtion To override contentSize
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: sliderWidth, height: sliderHeight)
    }
    
    
    /// default frame for bottom stick slider
    //    public override init() {
    //        super.init(frame: CGRect(x: 0, y: view.bounds.height - view.bounds.height/10, width: view.bounds.width - 2, height: 30))
    //    }
    
    
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSlider()
    }
    
    private func setupSlider() {
        addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        updateSliderLayout()
        updateProgressBarColor()
    }
    
    private func updateSliderLayout() {
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    //   MARK: - Customize knob
    public func setKnobImage(image: UIImage, state: UIControl.State, size: CGSize? = nil, color: UIColor? = nil) {
        var resizedImage = image
        
        if let size = size {
            resizedImage = resizeImage(image: image, to: size)
        }
        
        if let color = color {
            let coloredImage = resizedImage.withRenderingMode(.alwaysTemplate)
            UIGraphicsBeginImageContextWithOptions(resizedImage.size, false, coloredImage.scale)
            color.set()
            coloredImage.draw(in: CGRect(origin: .zero, size: resizedImage.size))
            resizedImage = UIGraphicsGetImageFromCurrentImageContext() ?? resizedImage
            UIGraphicsEndImageContext()
        }
        
        self.setThumbImage(resizedImage, for: state)
    }
    
    private func resizeImage(image: UIImage, to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? image
    }
    
    
    
    public func hideSliderThumb() {
        self.setThumbImage(UIImage(), for: .highlighted)
        self.setThumbImage(UIImage(), for: .normal)
    }
    
    
    private func updateProgressBarColor() {
        minimumTrackTintColor = progressBarColor
        maximumTrackTintColor = progressBarColor.withAlphaComponent(0.3)
    }
    
    private func updateProgress() {
        value = progress
    }
    
    @objc private func sliderValueChanged() {
        progress = value
    }
    
    
    public var enableTapToJump: Bool = false {
        didSet {
            if enableTapToJump {
                enableTapGestureJump()
            }
        }
    }
    
    
   private func enableTapGestureJump() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    @objc func sliderTapped(_ gestureRecognizer: UITapGestureRecognizer) {
         // Calculate the value of the UISlider based on the location of the tap
         let point = gestureRecognizer.location(in: self)
         let percentage = Float(point.x / self.frame.width)
         let range = self.maximumValue - self.minimumValue
         let value = self.minimumValue + range * percentage

         // Set the value of the UISlider to the calculated value
         self.setValue(value, animated: true)

     }
    
    
    // Method to update the progress continuously
    public func updateProgressContinuously(totalTime: Double, speed: Float? = nil) {
        // Stop any existing timer before starting a new one
        progressTimer?.invalidate()
        // Calculate the interval between progress updates (1 second)
        
        let interval: TimeInterval = 1
        //        let interval: TimeInterval = TimeInterval(1 * (speed ?? 1))
        
        // Calculate the step value to increment progress at each interval
        let stepValue = 1 / totalTime * Double(interval)
        // Start the timer
        progressTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            // Increase the progress
            self.progress += Float(stepValue)
            // Stop the timer when the progress reaches 1 (100%)
            if self.progress >= 1 {
                self.progressTimer?.invalidate()
                self.progress = 1
            }
        }
    }

    // Method to stop the continuous progress updates
    public func stopProgressUpdates() {
        progressTimer?.invalidate()
    }
}
