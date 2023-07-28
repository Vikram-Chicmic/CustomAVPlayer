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
    public let slider = CustomSlider()
    public let timeLabels = TimeLabels()
    
    let sliderTimeContainer = SliderTimeLabelView()
    
    public let playPauseButton = PlayPauseButton()
    public let forwardButton = ForwardBackwardButton()
    public let backwardButton = ForwardBackwardButton()
    public let muteButton = MuteButton()
    public let lockControls = LockControlsButton()
    
    /// colors
    public var playerTint: UIColor?
    public var textColor: UIColor = .white
    public var iconColor: UIColor = .white
    
    private var controlsHidden: Bool = true {
        didSet {
            self.showHideControls()
            if !controlsHidden {
                DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                    if !self.controlsHidden {
                        self.controlsHidden = true
                        self.showHideControls()
                    }
                }
            }
        }
    }
    
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
    
    public init(url: URL, title: String = "") {
        self.url = url
        self.videoTitle = title
        super.init(nibName: "VideoPlayerView", bundle: Bundle(for: VideoPlayerView.self))
        self.modalPresentationStyle = .fullScreen
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(seekVideoOnDoubleTap))
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(videoContainerTapped))
        
        doubleTapGesture.numberOfTapsRequired = 2
        singleTapGesture.require(toFail: doubleTapGesture)
        
        singleTapGesture.numberOfTapsRequired = 1
        
        self.videoContainer.addGestureRecognizer(singleTapGesture)
        self.videoContainer.addGestureRecognizer(doubleTapGesture)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        startAvPlayer()
        controlsHidden = false
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setAvPlayerLayer()
        
        setColors()
        if let playerTint {
            setPlayerTint(color: playerTint)
        }
        setTextFont()
    }
    
    @objc
    func seekVideoOnDoubleTap(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        let player = avPlayerLayer.player
        if touchPoint.x > 550 {
            Helper.animateSeekButtons(button: forwardButton, rotationStart: 0, rotationCompletion: 2 * .pi)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                self.forwardButton.isHidden = self.controlsHidden
            }
            player?.seek(to: CMTime(seconds: (player?.currentTime().seconds)! + forwardButton.buffer, preferredTimescale: 1))
        }
        
        if touchPoint.x < 300 {
            Helper.animateSeekButtons(button: backwardButton, rotationStart: 2 * .pi, rotationCompletion: 0)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                self.backwardButton.isHidden = self.controlsHidden
            }
            player?.seek(to: CMTime(seconds: (player?.currentTime().seconds)! - forwardButton.buffer, preferredTimescale: 1))
        }
    }
    
    @objc
    func videoContainerTapped(touch: UITapGestureRecognizer) {
        controlsHidden = !controlsHidden
    }
    
    func showHideControls() {
        setView(view: playPauseButton)
        setView(view: backwardButton)
        setView(view: forwardButton)
        
        setView(view: closePlayerButton)
        setView(view: muteButton)
        setView(view: lockControls)
        
        setView(view: sliderTimeContainer)
    }
    
    func setView(view: UIView) {
        UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve) {
            view.isHidden = self.controlsHidden
        }
    }
    
    func setUpBottomView() {
        sliderTimeContainer.addFirstView(timeLabels)
        sliderTimeContainer.addSecondView(slider)
        
        self.view.addSubview(sliderTimeContainer)
        sliderTimeContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderTimeContainer.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            sliderTimeContainer.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            sliderTimeContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
        ])
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
        avPlayerLayer.player?.replaceCurrentItem(with: nil)
        self.dismiss(animated: true)
    }
    
}
