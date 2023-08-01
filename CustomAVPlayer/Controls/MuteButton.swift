//
//  PlayPauseButton.swift
//  CustomAVPlayer
//
//  Created by Chicmic on 25/07/23.
//

import UIKit
import AVFoundation

@IBDesignable
public class MuteButton: UIButton {
    
    var currentIcon: UIImage? {
        didSet {
            self.setImage(currentIcon?.withTintColor(iconColor), for: .normal)
        }
    }
    
    @IBInspectable
    public var iconMute: UIImage = UIImage(systemName: "speaker.slash")!
    
    @IBInspectable
    public var iconUnmute: UIImage = UIImage(systemName: "speaker")! {
        didSet {
            currentIcon = iconUnmute
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
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - setup
    
    public func setup() {
        self.setTitle("", for: .normal)
        self.currentIcon = iconUnmute
        self.imageView?.tintColor = iconColor
        
        self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
    }
}
