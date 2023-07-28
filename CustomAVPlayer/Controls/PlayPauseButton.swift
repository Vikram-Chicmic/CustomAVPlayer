//
//  PlayPauseButton.swift
//  CustomAVPlayer
//
//  Created by Chicmic on 25/07/23.
//

import UIKit
import AVFoundation

public class PlayPauseButton: UIButton {
    
    public var iconColor: UIColor = .white
    
    var avPlayer: AVPlayer? {
        didSet {
            setup()
        }
    }
    
    public var playButtonImage: PlayButtonImage = .playFill
    public var pauseButtonImage: PauseButtonImage = .pauseFill
    public var replayButtonImage: ReplayButtonImage = .goforward
    public var size: ButtonSize = .medium {
        didSet {
            setIconSize()
        }
    }
    
    private var kvoRateContext = 0
    
    private var isPlaying: Bool {
        return avPlayer?.rate != 0 && avPlayer?.error == nil
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
        addObservers()
    }
    
    private func setIconSize() {
        self.frame.size = CGSize(width: size.rawValue, height: size.rawValue)
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
    
    private func updateUI() {
        if isPlaying {
            Helper.setBackgroundImage(name: self.pauseButtonImage.rawValue, button: self, iconColor: iconColor)
        }else if avPlayer?.currentTime() == avPlayer?.currentItem?.duration {
            Helper.setBackgroundImage(name: self.replayButtonImage.rawValue, button: self, iconColor: iconColor)
        } else {
            Helper.setBackgroundImage(name: self.playButtonImage.rawValue, button: self, iconColor: iconColor)
        }
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer) {
        self.updateStatus()
    }
    
    private func addObservers() {
        avPlayer?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        updateUI()
    }
}
