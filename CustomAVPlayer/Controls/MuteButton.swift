//
//  PlayPauseButton.swift
//  CustomAVPlayer
//
//  Created by Chicmic on 25/07/23.
//

import UIKit
import AVFoundation

public class MuteButton: UIButton {
    
    public var iconColor: UIColor = .white
    
    var avPlayer: AVPlayer? {
        didSet {
            setup()
        }
    }
    
    public var muteButtonImage: MuteButtonImage = .speakerSlash
    public var unmuteButtonImage: UnmuteButtonImage = .speaker
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
    
    public func setup() {
        self.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        setIconSize()
        updateUI()
    }
    
    private func setIconSize() {
        self.heightAnchor.constraint(equalToConstant: size.rawValue).isActive = true
        self.widthAnchor.constraint(equalToConstant: size.rawValue).isActive = true
    }
    
    private func updateStatus() {
        avPlayer?.isMuted.toggle()
        updateUI()
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.updateStatus()
    }
    
    private func updateUI() {
        guard let muted = avPlayer?.isMuted else { return }
        Helper.setBackgroundImage(name: muted ? muteButtonImage.rawValue : unmuteButtonImage.rawValue, button: self, iconColor: iconColor, size: size.rawValue)
    }
}
