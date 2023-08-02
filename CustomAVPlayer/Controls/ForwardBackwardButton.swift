//
//  PlayPauseButton.swift
//  CustomAVPlayer
//
//  Created by Chicmic on 25/07/23.
//

import UIKit
import AVFoundation

public class ForwardBackwardButton: UIButton {
    
    @IBInspectable
    private var seekTime: Double = 5.0
    
    var buffer: Double {
        return isForward ? self.seekTime : -(self.seekTime)
    }
    
    @IBInspectable
    public var isForward: Bool = true
    
    @IBInspectable
    public var icon: UIImage = UIImage(systemName: "goforward.5")! {
        didSet {
            self.setImage(icon.withTintColor(iconColor), for: .normal)
        }
    }
    
    @IBInspectable
    public var iconColor: UIColor = .white {
        didSet {
            self.tintColor = iconColor
        }
    }
    
    @IBInspectable
    public var buttonHeight: CGFloat = 24 {
        didSet {
            self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        }
    }
    
    @IBInspectable
    public var buttonWidth: CGFloat = 24 {
        didSet {
            self.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        }
    }
    
    // MARK: - initializers
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        Helper.setupButtonView(button: self, icon: icon, color: iconColor, height: buttonHeight, width: buttonWidth)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Helper.setupButtonView(button: self, icon: icon, color: iconColor, height: buttonHeight, width: buttonWidth)
    }
}
