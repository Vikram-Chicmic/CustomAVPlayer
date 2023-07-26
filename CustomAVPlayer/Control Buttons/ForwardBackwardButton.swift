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

public class ForwardBackwardButton: UIButton {
    public var xCoordinate: Int = 100
    public var yCoordinate: Int = 100
    public var iconColor: UIColor = .white
    public var avPlayer: AVPlayer?
    public var forwardButton: ForwardButtonImage = .forwardButton
    public var backwardButton: BackwardButtonImage = .backwardButton
    public var buffer: Double = 5.0
    public var isForward: Bool = true

    private override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private var size: ButtonSize = .medium {
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
        if self.isForward {
            if Int((avPlayer?.currentItem?.duration.seconds)!) - Int((avPlayer?.currentTime().seconds)!) > Int(self.buffer) {
                avPlayer?.seek(to: CMTime(seconds:(avPlayer?.currentTime().seconds)! + self.buffer, preferredTimescale: 1))
            } else {
                avPlayer?.seek(to: (avPlayer?.currentItem!.duration)!)
            }
        } else {
            if Int((avPlayer?.currentTime().seconds)!) > Int(self.buffer) {
                avPlayer?.seek(to: CMTime(seconds:(avPlayer?.currentTime().seconds)! - self.buffer, preferredTimescale: 1))
            } else {
                avPlayer?.seek(to: CMTime.zero)
            }
        }
    }
    public func setup() {
        self.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        setIconSize(size: ButtonSize.medium.rawValue)
        if self.isForward {
            setBackgroundImage(name: self.forwardButton.rawValue)
        } else {
            setBackgroundImage(name: self.backwardButton.rawValue)
        }
    }
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.updateStatus()
    }
  
    private func setBackgroundImage(name: String) {
        UIGraphicsBeginImageContext(frame.size)
        UIImage(systemName: name)?.withTintColor(iconColor).draw(in: bounds)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        backgroundColor = UIColor(patternImage: image)
    }
}
