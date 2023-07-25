//
//  CustomSeekBar.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 25/07/23.
//

import Foundation

import UIKit

protocol VideoPlayerProgressBarDelegate: AnyObject {
    func didTapProgressBar(at percentage: Float)
}

class VideoPlayerProgressBar: UIView {
    weak var delegate: VideoPlayerProgressBarDelegate?

    private var progressView: UIView = UIView()
    
    // Customizable properties
    var progressBarColor: UIColor = .blue {
        didSet {
            progressView.backgroundColor = progressBarColor
        }
    }
    
    var progressBarHeight: CGFloat = 8 {
        didSet {
            updateProgressBarHeight()
        }
    }

    // Current progress (percentage value between 0 and 1)
    var progress: Float = 0 {
        didSet {
            updateProgress()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressBar()
        addTapGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupProgressBar()
        addTapGestureRecognizer()
    }

    private func setupProgressBar() {
        progressView.backgroundColor = progressBarColor
        addSubview(progressView)
        updateProgressBarHeight()
    }
    
    private func updateProgressBarHeight() {
        progressView.frame.size.height = progressBarHeight
        progressView.layer.cornerRadius = progressBarHeight / 2
    }

    private func updateProgress() {
        let progressWidth = bounds.width * CGFloat(progress)
        progressView.frame.size.width = progressWidth
    }

    private func addTapGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.addGestureRecognizer(tapGesture)
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let tapPoint = gesture.location(in: self)
        let percentage = Float(tapPoint.x / bounds.width)
        delegate?.didTapProgressBar(at: percentage)
    }
}


// MARK: - How to use
class VideoPlayerViewController: UIViewController, VideoPlayerProgressBarDelegate {
    var videoPlayerProgressBar: VideoPlayerProgressBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVideoPlayerProgressBar()
    }

    private func setupVideoPlayerProgressBar() {
        videoPlayerProgressBar = VideoPlayerProgressBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 40))
        videoPlayerProgressBar.delegate = self
        videoPlayerProgressBar.progressBarColor = .green
        videoPlayerProgressBar.progressBarHeight = 10
        view.addSubview(videoPlayerProgressBar)
    }

    // Implement the delegate method to handle tap events
    func didTapProgressBar(at percentage: Float) {
        // Update the video playback timeline based on the percentage value
//        let newPositionInSeconds = videoDurationInSeconds * percentage
//        videoPlayer.seek(to: newPositionInSeconds)
    }
}

