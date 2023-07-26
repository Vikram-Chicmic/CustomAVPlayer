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
    public var xCoordinate: Int = 100
    public var yCoordinate: Int = 300
    public var iconColor: UIColor = .white
    public var avPlayer: AVPlayer?
    public var muteButtonImage: MuteButtonImage = .speakerSlashFill
    public var unmuteButtonImage: UnmuteButtonImage = .speakerFill

    private override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    public var size: ButtonSize = .medium {
        didSet {
            switch size {
            case .small:
                setIconSize(size: ButtonSize.small.rawValue)
            case .medium:
                setIconSize(size: ButtonSize.medium.rawValue)
            case .large:
                setIconSize(size: ButtonSize.large.rawValue)
            }
        }
    }
    private func setIconSize(size: Int) {
        self.frame = CGRect(x: self.xCoordinate,
                            y: self.yCoordinate,
                            width: size,
                            height: size)
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
        UIGraphicsBeginImageContext(frame.size)
        UIImage(systemName: name)?.withTintColor(iconColor).draw(in: bounds)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: image)
    }
}
