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
    
    public var muteButtonImage: MuteButtonImage = .speakerSlashFill
    public var unmuteButtonImage: UnmuteButtonImage = .speakerFill
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
        var extraWidth = 0.0
        if let muted = avPlayer?.isMuted {
            extraWidth += muted ? 0.0 : 8.0
        }
        self.frame.size = CGSize(width: size.rawValue + extraWidth, height: size.rawValue)
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
        Helper.setBackgroundImage(name: muted ? muteButtonImage.rawValue : unmuteButtonImage.rawValue, button: self, iconColor: iconColor)
        setIconSize()
    }
}
