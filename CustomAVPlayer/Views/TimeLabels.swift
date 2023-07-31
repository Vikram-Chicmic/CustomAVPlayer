//
//  TimeLabelView.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 27/07/23.
//

import Foundation
import UIKit

public class TimeLabels: UIStackView {
    
    // MARK: - properties
    private let currentTime: UILabel = UILabel()
    private let duration: UILabel = UILabel()
    
    public var font: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            setFont()
        }
    }
    public var color: UIColor = .white {
        didSet {
            setColor()
        }
    }
    
    // MARK: - initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
        setFont()
        setColor()
    }
    required init(coder: NSCoder) {
        fatalError(ConstantString.fatalErrorLoadingNib)
    }
    
    // MARK: - view setup
    private func setStackView() {
        self.axis = .horizontal
        self.alignment = .fill
        self.distribution = .equalSpacing
        self.addArrangedSubview(currentTime)
        self.addArrangedSubview(duration)
    }

    // MARK: - set text value
    func setCurrentTime(value: String) {
        currentTime.text = value
    }
    
    func setDuration(value: String) {
        duration.text = value
    }
    
    // MARK: - label customizations
    private func setFont() {
        currentTime.font = font
        duration.font = font
    }
    
    private func setColor() {
        currentTime.textColor = color
        duration.textColor = color
    }
    
}
