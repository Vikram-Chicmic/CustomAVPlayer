//
//  PlayPauseButton.swift
//  CustomAVPlayer
//
//  Created by Chicmic on 25/07/23.
//

import UIKit
import AVFoundation

public class ForwardBackwardButton: UIButton {
    
    public var iconColor: UIColor = .white
    
    var avPlayer: AVPlayer? {
        didSet {
            setup()
        }
    }
    
    public var forwardButton: ForwardButtonImage = .forwardButton
    public var backwardButton: BackwardButtonImage = .backwardButton
    public var size: ButtonSize = .small {
        didSet {
            setIconSize()
        }
    }
    
    private var kvoRateContext = 0
    public var buffer: Double = 5.0
    
    public var isForward: Bool = true {
        didSet {
            updateUI()
        }
    }
    
    private var showButton: Bool {
        return avPlayer?.currentTime() != avPlayer?.currentItem?.duration
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func setup() {
        self.addTarget(self, action: #selector(handleTapGesture), for: .touchUpInside)
        self.contentMode = .scaleAspectFit
        setIconSize()
        addObservers()
        updateUI()
    }
    
    private func handleRateChanged() {
        self.isHidden = !showButton
    }
    
    private func setIconSize() {
        self.frame.size = CGSize(width: size.rawValue, height: size.rawValue)
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
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.updateStatus()
    }
    
    private func addObservers() {
        avPlayer?.addObserver(self, forKeyPath: ControlConstants.rate, options: .new, context: &kvoRateContext)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        guard let context = context else { return }
        switch context {
        case &kvoRateContext:
            handleRateChanged()
        default:
            break
        }
    }
    
    private func updateUI() {
        Helper.setBackgroundImage(name: isForward ? forwardButton.rawValue : backwardButton.rawValue, button: self, iconColor: iconColor)
    }
}
