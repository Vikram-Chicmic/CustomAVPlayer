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

public class MuteButton: UIButton {
    public var iconColor: UIColor = .systemBackground
    public var avPlayer: AVPlayer?
    public var muteButtonImage: MuteButtonImage = .speakerSlashFill
    public var unmuteButtonImage: UnmuteButtonImage = .speakerFill

    private var size: ButtonSize = .medium {
        didSet {
            setIconSize(size: size.rawValue)
        }
    }
    private func setIconSize(size: Int) {
        self.frame.size = CGSize(width: size, height: size)
    }
    private func updateStatus() {
        avPlayer?.isMuted.toggle()
        updateUI()
    }
    public func setup() {
        self.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        setIconSize(size: self.size.rawValue)
        updateUI()
    }
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.updateStatus()
    }
    private func updateUI() {
        if avPlayer?.isMuted == true {
            self.setBackgroundImage(name: self.muteButtonImage.rawValue)
        } else {
            self.setBackgroundImage(name: self.unmuteButtonImage.rawValue)
        }
    }
    private func setBackgroundImage(name: String) {
        self.setBackgroundImage(UIImage(systemName: name), for: .normal)
        self.tintColor = iconColor
    }
}
