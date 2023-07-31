//
//  VideoPlayerView.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit
import AVFoundation

public class VideoPlayerView: UIViewController {
    
    // MARK: - outlets
    
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var resetZoomButton: UIButton!
    @IBOutlet weak var closePlayerButton: UIButton!
    @IBOutlet weak var videoTitleLabel: UILabel!

    // MARK: - properties
    
    /// required values
    var url: URL
    var videoTitle: String
    
    // MARK: - views
    
    /// instace for av player layer
    let avPlayerLayer = AVPlayerLayer()
    /// instace for custom slider
    public let slider = CustomSlider()
    public let timeLabels = TimeLabels()
    /// container for slider and timeLabels
    let sliderTimeContainer = SliderTimeLabelView()
    
    // MARK: - player buttons
    
    /// control buttons
    public let playPauseButton = PlayPauseButton()
    public let forwardButton = ForwardBackwardButton()
    public let backwardButton = ForwardBackwardButton()
    public let muteButton = MuteButton()
    public var lockControlsButton = UIButton()
    
    // MARK: - check booleans
    
    /// lock controls
    var controlsLocked = false
    /// hide controls
    var controlsHidden: Bool = false {
        didSet {
            // use did set to hide controls after 5 seconds
            if self.controlsHidden {
                workItemControls = DispatchWorkItem {
                    self.showHideControls()
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: workItemControls!)
            }
        }
    }
    
    // MARK: - player properties
    
    /// colors
    public var playerTint: UIColor?
    public var textColor: UIColor = .white
    public var iconColor: UIColor = .white
    /// font
    public var textFont: UIFont = .systemFont(ofSize: 14)
    /// hide/show
    var timerViewIsHidden: Bool = false
    /// slider position
    var sliderPosition: SliderPosition = .defaultPosition
    
    // MARK: - dispatch item
    
    /// dispatch work item to hide view controls
    var workItemControls: DispatchWorkItem?
    
    // MARK: - initializers
    
    /// Parameterized initializer to instantiate VideoPlayerview xib, and assign value of url and title of video,
    /// - Parameters:
    ///   - url: url of the media item.
    ///   - title: title(optional) of media item.
    public init(url: URL, title: String = "") {
        self.url = url
        self.videoTitle = title
        super.init(nibName: ConstantString.videoPlayerView, bundle: Bundle(for: VideoPlayerView.self))
        self.modalPresentationStyle = .fullScreen
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError(ConstantString.fatalErrorLoadingNib)
    }
    
    // MARK: - lifecycle methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        // add tap gestures to video container
        addTapGesturesToVideoContainer()
        
        // start av player with given media url.
        startAvPlayer()
        
        // set up lock controls button
        setLockControlsButton()
        
        // hide the controls
        // this will trigger the didSet property and the controls will be
        // hidden after 5 seconds, if no videoContainer is not tapped.
        controlsHidden = true
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set up av player layer and color, tint, or font
        setAvPlayerLayer()
        setColors()
        if let playerTint {
            setPlayerTint(color: playerTint)
        }
        setTextFont()
    }
    
    // MARK: - ib actions
    
    @IBAction func resetZoomTapped(_ sender: UIButton) {
        self.videoContainer.transform = CGAffineTransformScale(
            CGAffineTransformIdentity, 1, 1
        )
        resetZoomButton.isHidden = true
        closePlayerButton.isHidden = controlsHidden && self.playPauseButton.isHidden
    }
 
    @IBAction func closePlayerTapped(_ sender: UIButton) {
        avPlayerLayer.player?.replaceCurrentItem(with: nil)
        self.dismiss(animated: true)
    }
    
}
