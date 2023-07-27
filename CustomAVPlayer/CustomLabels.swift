//
//  CustomLabels.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 27/07/23.
//

import Foundation
import UIKit

public class CustomLabel: UILabel {

    // MARK: - Public Properties
    
    public var fontColor: UIColor = .black {
        didSet {
            textColor = fontColor
        }
    }

    public var fontSize: CGFloat = 17 {
        didSet {
            font = font.withSize(fontSize)
        }
    }

    public var fontStyle: UIFont.TextStyle = .body {
        didSet {
            font = UIFont.preferredFont(forTextStyle: fontStyle)
        }
    }

    // MARK: - Public Methods

    public func showLabel() {
        isHidden = false
    }

    public func hideLabel() {
        isHidden = true
    }

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // Perform any common setup here
    }
}
