//
//  PlayPauseButton.swift
//  CustomAVPlayer
//
//  Created by Chicmic on 25/07/23.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

public class LockControlsButton: UIButton {
    
    public var iconColor: UIColor = .white
    
    var avPlayer: AVPlayer? {
        didSet {
            setup()
        }
    }
    public var lockButton: LockControlsImage = .lock
    public var size: ButtonSize = .small {
        didSet {
            setIconSize()
        }
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setIconSize() {
        self.heightAnchor.constraint(equalToConstant: size.rawValue).isActive = true
        self.widthAnchor.constraint(equalToConstant: size.rawValue).isActive = true
    }
    
    private func updateStatus() {
        updateUI()
    }
    
    public func setup() {
        self.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        setIconSize()
        updateUI()
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.updateStatus()
    }
    
    private func updateUI() {
        Helper.setBackgroundImage(name: lockButton.rawValue, button: self, iconColor: iconColor, size: size.rawValue)
    }
}
