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

public class PlayPauseButton: UIButton {
    public var xCoordinate: Int = 170
    public var yCoordinate: Int = 300
    public var iconColor: UIColor = .white
    public var avPlayer: AVPlayer?
    public var playButtonImage: PlayButtonImage = .playCircle
    public var pauseButtonImage: PauseButtonImage = .pauseCircle
    public var replayButtonImage: ReplayButtonImage = .goforward
    private var kvoRateContext = 0
    private var isPlaying: Bool {
        return avPlayer?.rate != 0 && avPlayer?.error == nil
    }
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
        if isPlaying {
            avPlayer?.pause()
        } else {
            if avPlayer?.currentTime() == avPlayer?.currentItem?.duration {
                avPlayer?.seek(to: CMTime.zero)
            }
            avPlayer?.play()
        }
    }
    public func setup() {
        self.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        setIconSize(size: self.size.rawValue)
        addObservers()
        updateUI()
    }
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.updateStatus()
    }
    private func addObservers() {
        avPlayer?.addObserver(self, forKeyPath: ControlConstants.rate, options: .new, context: &kvoRateContext)
    }
    private func handleRateChanged() {
        updateUI()
    }
    private func updateUI() {
        if isPlaying {
            setBackgroundImage(name: self.pauseButtonImage.rawValue)
        }else if avPlayer?.currentTime() == avPlayer?.currentItem?.duration {
            setBackgroundImage(name: self.replayButtonImage.rawValue)
        } else {
            setBackgroundImage(name: self.playButtonImage.rawValue)
        }
    }
    public override func observeValue(forKeyPath keyPath: String?,
                                      of object: Any?,
                                      change: [NSKeyValueChangeKey: Any]?,
                                      context: UnsafeMutableRawPointer?) {
        guard let context = context else { return }
        switch context {
        case &kvoRateContext:
            handleRateChanged()
        default:
            break
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
