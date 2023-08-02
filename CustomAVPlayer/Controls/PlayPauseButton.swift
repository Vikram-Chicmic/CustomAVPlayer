//
//  PlayPauseButton.swift
//  CustomAVPlayer
//
//  Created by Chicmic on 25/07/23.
//

import UIKit
import AVFoundation

public class PlayPauseButton: UIButton {
    
    var currentIcon: UIImage? {
        didSet {
            self.setImage(currentIcon?.withTintColor(iconColor), for: .normal)
        }
    }
    
    @IBInspectable
    public var iconPlay: UIImage = UIImage(systemName: "play.fill")!
    
    @IBInspectable
    public var iconPause: UIImage = UIImage(systemName: "pause.fill")! {
        didSet {
            currentIcon = iconPause
        }
    }
    
    @IBInspectable
    public var iconReplay: UIImage = UIImage(systemName: "goforward")!
    
    @IBInspectable
    public var iconColor: UIColor = .white {
        didSet {
            self.tintColor = iconColor
        }
    }
    
    @IBInspectable
    public var buttonHeight: CGFloat = 74 {
        didSet {
            self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        }
    }
    
    @IBInspectable
    public var buttonWidth: CGFloat = 74 {
        didSet {
            self.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        }
    }
    
    // MARK: - initializers
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        Helper.setupButtonView(button: self, icon: iconPause, color: iconColor, height: buttonHeight, width: buttonWidth)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Helper.setupButtonView(button: self, icon: iconPause, color: iconColor, height: buttonHeight, width: buttonWidth)
    }
}
