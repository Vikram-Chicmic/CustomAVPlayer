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
    public var iconColor: UIColor = .systemBackground
    private var avPlayer: AVPlayer?
    public var forwardButton: ForwardButtonImage = .forwardButton
    public var backwardButton: BackwardButtonImage = .backwardButton
    public var buffer: Double = 2.0
    public var isForward: Bool = true {
        didSet {
            if isForward {
                setBackgroundImage(name: forwardButton.rawValue)
            } else {
                setBackgroundImage(name: backwardButton.rawValue)
            }
        }
    }
    private var kvoRateContext = 0
    private var showButton: Bool {
        return avPlayer?.currentTime() != avPlayer?.currentItem?.duration
    }
    private func addObservers() {
        avPlayer?.addObserver(self, forKeyPath: ControlConstants.rate, options: .new, context: &kvoRateContext)
    }
    private var size: ButtonSize = .medium {
        didSet {
            setIconSize(size: size.rawValue)
        }
    }
    
    init(player: AVPlayer) {
        super.init(frame: .zero)
        self.avPlayer = player
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setIconSize(size: Int) {
        self.frame.size = CGSize(width: size, height: size)
    }
    private func updateStatus() {
        if self.isForward {
            avPlayer?.pause()
            skipForward()
            avPlayer?.play()
        } else {
            avPlayer?.pause()
            skipBackward()
            avPlayer?.play()
        }
    }
    
    func skipForward() {
        guard let currentTime = avPlayer?.currentTime() else {
            return
        }
        
        if currentTime.seconds + 5.0 <= (avPlayer?.currentItem?.duration.seconds)! {
            let newTime = CMTime(seconds: currentTime.seconds + 5.0, preferredTimescale: currentTime.timescale)
            avPlayer?.seek(to: newTime)
        } else {
            avPlayer?.seek(to: (avPlayer?.currentItem!.duration)!)
        }
    }
    
    func skipBackward() {
        guard let currentTime = avPlayer?.currentTime() else {
            return
        }
        
        if currentTime.seconds > 5.0 {
            let newTime = CMTime(seconds: currentTime.seconds - 5.0, preferredTimescale: currentTime.timescale)
            avPlayer?.seek(to: newTime)
        } else {
            avPlayer?.seek(to: CMTime.zero)
        }
    }
    
    public func setup() {
        self.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        setIconSize(size: self.size.rawValue)
        addObservers()
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
        self.setBackgroundImage(UIImage(systemName: name), for: .normal)
        self.tintColor = iconColor
    }
    
    private func handleRateChanged() {
        if !showButton {
            self.isHidden = true
        } else {
            self.isHidden = false
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
}
