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
    let slider = CustomSlider(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    
    /// colors
    public var playerTint: UIColor?
    public var textColor: UIColor = .white
    public var iconColor: UIColor = .white
    public var thumbColor: UIColor = .white
    public var sliderProgressTint: UIColor = .white
    
    /// font
    public var textFont: UIFont = .systemFont(ofSize: 14)
    
    /// hide/show
    var timerViewIsHidden: Bool = false
    
    /// slider
    public var sliderPosition: SliderPosition = .defaultPosition
    
    // MARK: - outlets
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var resetZoomButton: UIButton!
    
    @IBOutlet weak var timeStackView: UIStackView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setAvPlayerLayer()
        
        setColors()
        
        if let playerTint {
            setPlayerTint(color: playerTint)
        }
        
        setTextFont()
        
        timerViewShowHide()
    }

    public init(url: URL, title: String = "") {
        self.url = url
        self.videoTitle = title
        super.init(nibName: "VideoPlayerView", bundle: Bundle(for: VideoPlayerView.self))
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - orientation
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            avPlayerLayer.frame = CGRect(origin: .zero, size: size)
        } else {
            avPlayerLayer.frame = CGRect(origin: .zero, size: size)
        }
    }
    
    // MARK: - ib actions
    @IBAction func resetZoomTapped(_ sender: UIButton) {
        self.videoContainer.transform = CGAffineTransformScale(
            CGAffineTransformIdentity, 1, 1
        )
        resetZoomButton.isHidden = true
    }
    
}
