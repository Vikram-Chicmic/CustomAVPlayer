//
//  VideoPlayerView.swift
//  CustomAVPlayer
//
//  Created by Himanshu on 7/25/23.
//

import UIKit
import AVFoundation

public class VideoPlayerView: UIViewController {

    // MARK: - properties
    /// required values
    var url: URL
    var videoTitle: String
    
    /// instace for av player layer
    let avPlayerLayer = AVPlayerLayer()
    /// instace for custom slider
    public let slider = CustomSlider(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    public let playPauseButton = PlayPauseButton()
    public let forwardButton = ForwardBackwardButton()
    public let backwardButton = ForwardBackwardButton()
    public let muteButton = MuteButton()
    
    /// colors
    public var playerTint: UIColor?
    public var textColor: UIColor = .white
    public var iconColor: UIColor = .white
    
    /// font
    public var textFont: UIFont = .systemFont(ofSize: 14)
    
    /// hide/show
    var timerViewIsHidden: Bool = false
    
    /// slider
    public var sliderPosition: SliderPosition = .defaultPosition
    
    // MARK: - outlets
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var resetZoomButton: UIButton!
    
    @IBOutlet weak var closePlayerButton: UIButton!
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        startAvPlayer()
    }
    
    public override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        setAvPlayerLayer()
        setColors()
        if let playerTint {
            setPlayerTint(color: playerTint)
        }
        setTextFont()
    }

    public init(url: URL, title: String = "") {
        self.url = url
        self.videoTitle = title
        super.init(nibName: "VideoPlayerView", bundle: Bundle(for: VideoPlayerView.self))
        self.modalPresentationStyle = .fullScreen
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ib actions
    @IBAction func resetZoomTapped(_ sender: UIButton) {
        self.videoContainer.transform = CGAffineTransformScale(
            CGAffineTransformIdentity, 1, 1
        )
        resetZoomButton.isHidden = true
        closePlayerButton.isHidden = false
    }
 
    @IBAction func closePlayerTapped(_ sender: UIButton) {
        avPlayerLayer.player = nil
        self.dismiss(animated: true)
    }
    
}
