//
//  VideoPlayerView.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit
import AVFoundation
import Darwin

@IBDesignable
public class VideoPlayerView: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    // normal player
    @IBOutlet weak var videoPlayer: UIView!
    @IBOutlet weak var videoContainer: UIView! // for gesture recognition
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
    
    var videos: [String] = []

 var enableReelView = false
@IBInspectable public var useReelFeature: Bool = false {
        didSet {
            if useReelFeature {
               enableReelView = true
            } else {
               enableReelView = false
            }
        }
    }
    
    
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
            slider.setThumbImage(image: thumbImage, width: thumbWidth, height: thumbHeight, color: thumbTint)
        }
    }
    
    @IBInspectable public var thumbWidth: CGFloat = 20 {
        didSet {
            slider.setThumbImage(image: thumbImage, width: thumbWidth, height: thumbHeight, color: thumbTint, sameForAllState: sameForAllState)
        }
    }
    @IBInspectable public var thumbTint: UIColor = .white {
        didSet {
            slider.thumbTintColor = thumbTint
        }
    }
    @IBInspectable public var thumbImage: UIImage = UIImage(systemName: "circle.fill")! {
        didSet {
            slider.setThumbImage(image: thumbImage, width: thumbWidth, height: thumbHeight, color: thumbTint, sameForAllState: sameForAllState)
        }
    }
    @IBInspectable public var sameForAllState: Bool = true {
        didSet {
            slider.setThumbImage(image: thumbImage, width: thumbWidth, height: thumbHeight, color: thumbTint, sameForAllState: sameForAllState)
           
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
    
    // Gesture Control
    var touchAndHold = true
    @IBInspectable public var touchAndHoldToPause: Bool = true {
        didSet {
            if enableReelView {
                touchAndHold = touchAndHoldToPause
            }
        }
    }
    
    // Reel View tap function
   public enum TapFunctionality {
        case playPause
        case muteUnmute
    }
    
    var showMuteForReelFunc = true
    @IBInspectable public var showMuteForReel: Bool = true {
        didSet {
            showMuteForReelFunc = showMuteForReel
        }
    }
    public var tapFunctionForReel: TapFunctionality = .muteUnmute
    
    
    // Time Labels
    @IBInspectable public var hideTimeLabels: Bool = false {
        didSet {
            self.timeLabelsStack.isHidden = hideTimeLabels
        }
    }
    @IBInspectable public var timeLabelsTint: UIColor = .white {
        didSet {
            self.startTimeLabel.tintColor = timeLabelsTint
            self.endTimeLabel.tintColor = timeLabelsTint
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
            enableReelView = useReelFeature
            super.init(frame: frame)
            commonInit()
        }

        required init?(coder aDecoder: NSCoder) {
            avPlayerLayer = AvPlayerManager.shared.avPlayerLayer
            enableReelView = useReelFeature
            super.init(coder: aDecoder)
            commonInit()
        }
 
    
    
        private func commonInit() {
            let bundle = Bundle(for: type(of: self))
            bundle.loadNibNamed("VideoPlayerView", owner: self, options: nil)
            self.frame = UIScreen.main.bounds
            contentView.frame = self.frame
            let screenSize = self.frame.size
            let safeAreaInsets = UIApplication.shared.windows.first?.safeAreaInsets
            let adjustedHeight = screenSize.height - (safeAreaInsets?.top ?? 0)
        
            
            collectionView.frame.size = CGSize(width: screenSize.width, height: adjustedHeight)
           
            addSubview(contentView)
        }
        
        private func initCollectionView() {
            let nib = UINib(nibName: "ReelCell", bundle: Bundle(for: type(of: self)))
            collectionView.register(nib, forCellWithReuseIdentifier: "reel")
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.bounces = false
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                     collectionView.topAnchor.constraint(equalTo: topAnchor),
                     collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
                     collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
                     collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
                 ])
            
            
            // set paging enabled
            collectionView.isPagingEnabled = true
//            collectionView.pa

            // disable indicators
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            
            // intialize layout for collection view
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            // set collection view layout
            collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Set AVPlayerLayer in view
        if !enableReelView {
            setAvPlayerLayer()
            videoPlayer.isHidden = false
            collectionView.isHidden = true
            
            // Remove default title from buttons
            removeButtonTitles()
            // Add tap gestures to video container
            addTapGesturesToVideoContainer()
            // Set pinch to zoom gesture
            setPinchToZoomGesture()
        }
        else  {
                videoPlayer.isHidden = true
                collectionView.isHidden = false
                initCollectionView()
            }
        }
    public var isMute = false
}
