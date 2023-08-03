//
//  VideoPlayerView.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit
import AVFoundation

extension UIButton {
    func setButtonSize(size: CGFloat) {
        let cgSize = CGSize(width: size, height: size)
        self.frame.size = cgSize
    }
}

@IBDesignable
public class VideoPlayerView: UIView {
    
    // MARK: - Outlets

    @IBOutlet weak var videoContainer: UIView!

    @IBOutlet weak var zoomButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!

    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!

    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var backwardButton: UIButton!

    @IBOutlet weak var slider: CustomSlider!
    
    // MARK: - IB Inspectable
    
    // Globals
    @IBInspectable
    var controlsDisabled: Bool = false {
        didSet {
            if controlsDisabled {
                controlsHidden = true
            }
        }
    }
    @IBInspectable
    var playerTint: UIColor? {
        didSet {
            setPlayerTint(color: playerTint)
        }
    }
    
    // Zoom Button
    @IBInspectable
    var zoomIcon: UIImage = UIImage(systemName: "square.dashed")! {
        didSet {
            self.zoomButton.setImage(self.zoomIcon, for: .normal)
        }
    }
    @IBInspectable
    var zoomIconTint: UIColor = .white {
        didSet {
            self.zoomButton.tintColor = self.zoomIconTint
        }
    }
    @IBInspectable
    var zoomIconSize: CGFloat = 24 {
        didSet {
            zoomButton.setButtonSize(size: zoomIconSize)
        }
    }

    // Close Button
    @IBInspectable
    var closeIcon: UIImage = UIImage(systemName: "xmark")! {
        didSet {
            self.closeButton.setImage(self.closeIcon, for: .normal)
        }
    }
    @IBInspectable
    var closeIconTint: UIColor = .white {
        didSet {
            self.closeButton.tintColor = self.closeIconTint
        }
    }
    @IBInspectable
    var closeIconSize: CGFloat = 24 {
        didSet {
            closeButton.setButtonSize(size: closeIconSize)
        }
    }

    // Mute Button
    @IBInspectable
    var muteVideo: Bool = false
    @IBInspectable
    var muteIcon: UIImage = UIImage(systemName: "speaker.slash")! {
        didSet {
            if muteVideo {
                self.muteButton.setImage(self.muteIcon, for: .normal)
            }
        }
    }
    @IBInspectable
    var unmuteIcon: UIImage = UIImage(systemName: "volume.3")! {
        didSet {
            if !muteVideo {
                self.muteButton.setImage(self.unmuteIcon, for: .normal)
            }
        }
    }
    @IBInspectable
    var muteIconTint: UIColor = .white {
        didSet {
            self.muteButton.tintColor = self.muteIconTint
        }
    }
    @IBInspectable
    var muteIconSize: CGFloat = 24 {
        didSet {
            muteButton.setButtonSize(size: muteIconSize)
        }
    }
    @IBInspectable
    var hideMuteButton: Bool = false {
        didSet {
            self.muteButton.isHidden = hideMuteButton
        }
    }

    // Lock Button
    @IBInspectable
    var controlsLocked: Bool = false
    @IBInspectable
    var lockIcon: UIImage = UIImage(systemName: "lock")! {
        didSet {
            if controlsLocked {
                self.lockButton.setImage(self.lockIcon, for: .normal)
            }
        }
    }
    @IBInspectable
    var unlockIcon: UIImage = UIImage(systemName: "lock.slash")! {
        didSet {
            if !controlsLocked {
                self.lockButton.setImage(self.unlockIcon, for: .normal)
            }
        }
    }
    @IBInspectable
    var lockIconTint: UIColor = .white {
        didSet {
            self.lockButton.tintColor = self.lockIconTint
        }
    }
    @IBInspectable
    var lockIconSize: CGFloat = 24 {
        didSet {
            lockButton.setButtonSize(size: lockIconSize)
        }
    }
    @IBInspectable
    var hideLockButton: Bool = false {
        didSet {
            self.lockButton.isHidden = hideLockButton
        }
    }

    // Play/Pause Button
    var playPauseIcon: UIImage? {
        didSet {
            self.playPauseButton.setImage(self.playPauseIcon, for: .normal)
        }
    }
    @IBInspectable
    var playIcon: UIImage = UIImage(systemName: "play.fill")!
    @IBInspectable
    var pauseIcon: UIImage = UIImage(systemName: "pause.fill")!
    @IBInspectable
    var replayIcon: UIImage = UIImage(systemName: "goforward")!
    @IBInspectable
    var playPauseIconTint: UIColor = .white {
        didSet {
            self.playPauseButton.tintColor = self.playPauseIconTint
        }
    }
    @IBInspectable
    var playPauseIconSize: CGFloat = 54 {
        didSet {
            playPauseButton.setButtonSize(size: playPauseIconSize)
        }
    }

    // Seek Buttons
    @IBInspectable
    var seekTime: Double = 5.0
    @IBInspectable
    var forwardIcon: UIImage = UIImage(systemName: "goforward.5")! {
        didSet {
            self.forwardButton.setImage(self.forwardIcon, for: .normal)
        }
    }
    @IBInspectable
    var backwardIcon: UIImage = UIImage(systemName: "gobackward.5")! {
        didSet {
            self.backwardButton.setImage(self.backwardIcon, for: .normal)
        }
    }
    @IBInspectable
    var seekIconTint: UIColor = .white {
        didSet {
            self.forwardButton.tintColor = self.seekIconTint
            self.backwardButton.tintColor = self.seekIconTint
        }
    }
    @IBInspectable
    var seekIconSize: CGFloat = 24 {
        didSet {
            forwardButton.setButtonSize(size: seekIconSize)
            backwardButton.setButtonSize(size: seekIconSize)
        }
    }
    @IBInspectable
    var hideForwardButton: Bool = false {
        didSet {
            self.forwardButton.isHidden = self.hideForwardButton
        }
    }
    @IBInspectable
    var hideBackwardButton: Bool = false {
        didSet {
            self.backwardButton.isHidden = self.hideBackwardButton
        }
    }

    
    // MARK: - Properties

    // AVPlayerLayer's intance
    let avPlayerLayer = AVPlayerLayer()

    // TimeLabels instance
    let timeLabels = TimeLabels()
    // Container view for TimeLabels and slider
    let sliderTimeContainer = SliderTimeLabelView()

    // Computed property for control button's visibility
    var controlsHidden: Bool = false {
        didSet {
            if controlsDisabled {
                self.showHideControls()
            } else if self.controlsHidden {
                workItemControls = DispatchWorkItem {
                    self.showHideControls()
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: workItemControls!)
            }
        }
    }
    var workItemControls: DispatchWorkItem?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        guard let contentView = loadViewFromNib() else { return }
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        
        // Remove default title from buttons
        removeButtonTitles()
        
        // Add tap gestures to video container
        addTapGesturesToVideoContainer()
    }

    private func loadViewFromNib() -> UIView? {
        let nibName = String(describing: type(of: self))
        print(nibName)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set AVPlayerLayer in view
        setAvPlayerLayer()
    }

    // MARK: - IB Actions

    @IBAction func resetZoomTapped(_ sender: UIButton) {
        self.videoContainer.transform = CGAffineTransformScale(
            CGAffineTransformIdentity, 1, 1
        )
        zoomButton.isHidden = true
        closeButton.isHidden = controlsHidden && self.playPauseButton.isHidden
    }

    @IBAction func closePlayerTapped(_ sender: UIButton) {
        avPlayerLayer.player?.replaceCurrentItem(with: nil)
    }

    @IBAction func lockButtonTapped(_ sender: UIButton) {
        if controlsLocked {
            controlsLocked = false
            controlsHidden = false
            // Reset
            self.showHideControls()
            self.controlsHidden = true
        } else {
            controlsLocked = true
            controlsHidden = true
            hideControls()
        }
        lockButton.setImage(controlsLocked ? lockIcon : unlockIcon, for: .normal)
    }

    @IBAction func muteButtonTapped(_ sender: Any) {
        avPlayerLayer.player?.isMuted.toggle()
        guard let muted = avPlayerLayer.player?.isMuted else { return }
        muteButton.setImage(muted ? muteIcon : unmuteIcon, for: .normal)
    }

    @IBAction func playPauseButtonTapped(_ sender: Any) {
        let player = avPlayerLayer.player

        if player?.timeControlStatus == .playing {
            player?.pause()
        } else {
            if player?.currentItem?.currentTime() == player?.currentItem?.duration {
                player?.seek(to: CMTime.zero)
                forwardButton.isHidden = false
                backwardButton.isHidden = false
            }
            player?.play()
        }
    }

    @IBAction func forwardButtonTapped(_ sender: Any) {
        seekVideo(button: forwardButton, rotationStartFrom: 0, rotationEndTo: 2 * .pi, seek: seekTime)
    }

    @IBAction func backwardButtonTapped(_ sender: Any) {
        seekVideo(button: backwardButton, rotationStartFrom: 2 * .pi, rotationEndTo: 0, seek: -(seekTime))
    }
}
