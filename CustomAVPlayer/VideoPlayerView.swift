//
//  VideoPlayerView.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit
import AVFoundation

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
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var timeLabelsStack: UIStackView!
    
    // MARK: - IB Inspectable
    
    // Globals
    @IBInspectable public var controlsDisabled: Bool = false {
        didSet {
            if controlsDisabled {
                controlsHidden = true
            }
        }
    }
    @IBInspectable public var playerTint: UIColor? {
        didSet {
            setPlayerTint(color: playerTint)
        }
    }
    
    // Zoom Button
    @IBInspectable public var zoomIcon: UIImage = UIImage(systemName: "square.dashed")! {
        didSet {
            self.zoomButton.setImage(self.zoomIcon, for: .normal)
        }
    }
    @IBInspectable public var zoomIconTint: UIColor = .white {
        didSet {
            self.zoomButton.tintColor = self.zoomIconTint
        }
    }
    @IBInspectable public var zoomIconSize: CGFloat = 24 {
        didSet {
            zoomButton.setButtonSize(size: zoomIconSize)
        }
    }

    // Close Button
    @IBInspectable public var closeIcon: UIImage = UIImage(systemName: "xmark")! {
        didSet {
            self.closeButton.setImage(self.closeIcon, for: .normal)
        }
    }
    @IBInspectable public var closeIconTint: UIColor = .white {
        didSet {
            self.closeButton.tintColor = self.closeIconTint
        }
    }
    @IBInspectable public var closeIconSize: CGFloat = 24 {
        didSet {
            closeButton.setButtonSize(size: closeIconSize)
        }
    }

    // Mute Button
    @IBInspectable public var muteVideo: Bool = false
    @IBInspectable public var muteIcon: UIImage = UIImage(systemName: "speaker.slash")! {
        didSet {
            if muteVideo {
                self.muteButton.setImage(self.muteIcon, for: .normal)
            }
        }
    }
    @IBInspectable public var unmuteIcon: UIImage = UIImage(systemName: "volume.3")! {
        didSet {
            if !muteVideo {
                self.muteButton.setImage(self.unmuteIcon, for: .normal)
            }
        }
    }
    @IBInspectable public var muteIconTint: UIColor = .white {
        didSet {
            self.muteButton.tintColor = self.muteIconTint
        }
    }
    @IBInspectable public var muteIconSize: CGFloat = 24 {
        didSet {
            muteButton.setButtonSize(size: muteIconSize)
        }
    }
    @IBInspectable public var hideMuteButton: Bool = false {
        didSet {
            self.muteButton.isHidden = hideMuteButton
        }
    }

    // Lock Button
    @IBInspectable public var controlsLocked: Bool = false
    @IBInspectable public var lockIcon: UIImage = UIImage(systemName: "lock")! {
        didSet {
            if controlsLocked {
                self.lockButton.setImage(self.lockIcon, for: .normal)
            }
        }
    }
    @IBInspectable public var unlockIcon: UIImage = UIImage(systemName: "lock.slash")! {
        didSet {
            if !controlsLocked {
                self.lockButton.setImage(self.unlockIcon, for: .normal)
            }
        }
    }
    @IBInspectable public var lockIconTint: UIColor = .white {
        didSet {
            self.lockButton.tintColor = self.lockIconTint
        }
    }
    @IBInspectable public var lockIconSize: CGFloat = 24 {
        didSet {
            lockButton.setButtonSize(size: lockIconSize)
        }
    }
    @IBInspectable public var hideLockButton: Bool = false {
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
    @IBInspectable public var playIcon: UIImage = UIImage(systemName: "play.fill")!
    @IBInspectable public var pauseIcon: UIImage = UIImage(systemName: "pause.fill")!
    @IBInspectable public var replayIcon: UIImage = UIImage(systemName: "goforward")!
    @IBInspectable public var playPauseIconTint: UIColor = .white {
        didSet {
            self.playPauseButton.tintColor = self.playPauseIconTint
        }
    }
    @IBInspectable public var playPauseIconSize: CGFloat = 54 {
        didSet {
            self.playPauseButton.setButtonSize(size: self.playPauseIconSize)
        }
    }

    // Seek Buttons
    @IBInspectable public var seekTime: Double = 5.0
    @IBInspectable public var forwardIcon: UIImage = UIImage(systemName: "goforward.5")! {
        didSet {
            self.forwardButton.setImage(self.forwardIcon, for: .normal)
        }
    }
    @IBInspectable public var backwardIcon: UIImage = UIImage(systemName: "gobackward.5")! {
        didSet {
            self.backwardButton.setImage(self.backwardIcon, for: .normal)
        }
    }
    @IBInspectable public var seekIconTint: UIColor = .white {
        didSet {
            self.forwardButton.tintColor = self.seekIconTint
            self.backwardButton.tintColor = self.seekIconTint
        }
    }
    @IBInspectable public var seekIconSize: CGFloat = 24 {
        didSet {
            forwardButton.setButtonSize(size: seekIconSize)
            backwardButton.setButtonSize(size: seekIconSize)
        }
    }
    @IBInspectable public var hideForwardButton: Bool = false {
        didSet {
            self.forwardButton.isHidden = self.hideForwardButton
        }
    }
    @IBInspectable public var hideBackwardButton: Bool = false {
        didSet {
            self.backwardButton.isHidden = self.hideBackwardButton
        }
    }
    
    // Slider
    @IBInspectable public var sliderWidth: CGFloat = 200 {
        didSet {
            slider.setSliderSize(height: sliderHeight, width: sliderWidth)
        }
    }
    @IBInspectable public var sliderHeight: CGFloat = 30 {
        didSet {
            slider.setSliderSize(height: sliderHeight, width: sliderWidth)
        }
    }
    @IBInspectable public var sliderTint: UIColor = .white {
        didSet {
            slider.setSliderTint(color: sliderTint)
        }
    }
    @IBInspectable public var hideProgressBar: Bool = false {
        didSet {
            self.isHidden = hideProgressBar
        }
    }
    
    // Slider Thumb
    @IBInspectable public var thumbHeight: CGFloat = 20 {
        didSet {
            slider.setThumbImageSize(image: thumbImage ?? UIImage(), height: thumbHeight, width: thumbWidth, sameForAllState: sameForAllState)
        }
    }
    
    @IBInspectable public var thumbWidth: CGFloat = 20 {
        didSet {
            slider.setThumbImageSize(image: thumbImage ?? UIImage(), height: thumbHeight, width: thumbWidth, sameForAllState: sameForAllState)
        }
    }
    @IBInspectable public var thumbTint: UIColor = .white {
        didSet {
            slider.thumbTintColor = thumbTint
        }
    }
    @IBInspectable public var thumbImage: UIImage? {
        didSet {
            slider.setThumbImage(image: thumbImage ?? UIImage(), width: thumbWidth, height: thumbHeight)
        }
    }
    @IBInspectable public var sameForAllState: Bool = true {
        didSet {
            slider.setThumbImageSize(image: thumbImage ?? UIImage(), height: thumbHeight, width: thumbWidth, sameForAllState: sameForAllState)
        }
    }
    @IBInspectable public var hideThumb: Bool = false {
        didSet {
            slider.hideSliderThumb(hide: hideThumb)
        }
    }
    @IBInspectable public var interactionEnabled: Bool = true {
        didSet {
            self.isUserInteractionEnabled = interactionEnabled
        }
    }
    
    // Time Labels
    @IBInspectable public var timeLabelsHidden: Bool = false {
        didSet {
            self.timeLabelsStack.isHidden = timeLabelsHidden
        }
    }
    @IBInspectable public var timeLabelsTint: UIColor = .white {
        didSet {
            self.startTimeLabel.tintColor = timeLabelsTint
            self.endTimeLabel.tintColor = timeLabelsTint
        }
    }
    @IBInspectable public var timeLabelsFont: UIFont = .systemFont(ofSize: 14) {
        didSet {
            self.startTimeLabel.font = timeLabelsFont
            self.endTimeLabel.font = timeLabelsFont
        }
    }

    // MARK: - Properties

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
    
    var avPlayerLayer: AVPlayerLayer
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        avPlayerLayer = AvPlayerManager.shared.avPlayerLayer
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        avPlayerLayer = AvPlayerManager.shared.avPlayerLayer
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
        // Set pinch to zoom gesture
        setPinchToZoomGesture()
    }

    private func loadViewFromNib() -> UIView? {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Set AVPlayerLayer in view
        setAvPlayerLayer()
    }
}
