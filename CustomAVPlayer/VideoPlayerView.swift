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
    
    /// colors
    public var playerTint: UIColor?
    public var textColor: UIColor = .white
    public var iconColor: UIColor = .white
    
    var isSliderDragged = false
    
    /// font
    public var textFont: UIFont = .systemFont(ofSize: 14)
    
    /// hide/show
    var timerViewIsHidden: Bool = false
    
    /// slider
    public var sliderPosition: SliderPosition = .defaultPosition
    
    // MARK: - outlets
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var resetZoomButton: UIButton!
    
    
    @IBOutlet weak var videoTitleLabel: UILabel!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setAvPlayerLayer()
        setColors()
        if let playerTint {
            setPlayerTint(color: playerTint)
        }
        setTextFont()
        setUpBottomView()

    }
    
    func setUpBottomView() {
        let customStackView = CustomStackView()
               // Add the custom view to the view controller's view
               view.addSubview(customStackView)
               // Set constraints for the custom view to fill the width of the screen
               customStackView.translatesAutoresizingMaskIntoConstraints = false
               NSLayoutConstraint.activate([
                   customStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   customStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   customStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
               ])

               // Create two sample views and add them to the customStackView
               let view1 = setUpTimeLabel()
               view1.frame.size.height = 50
    
               view1.frame.size.width = view.bounds.width
               customStackView.addFirstView(view1)

               let view2 = slider
                view2.frame.size.height = 50
                view2.frame.size.width = view.bounds.width
               customStackView.addSecondView(view2)
        
//        customStackView.hideBottomView()
        //  M
//        customStackView.reverseViewsInVerticalStack()
    }
    let customLabelsView = TimeLabelView()
    
    func setUpTimeLabel() -> UIView {
        customLabelsView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 40)
        return customLabelsView
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
