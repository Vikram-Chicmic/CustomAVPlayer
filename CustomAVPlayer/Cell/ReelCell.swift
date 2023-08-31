import UIKit
import AVFoundation

class ReelCell: UICollectionViewCell {
    // Video player properties
    let playerLayer: AVPlayerLayer = AVPlayerLayer()
    var player: AVPlayer?
    var timeObserver: Any?

    // Slider and UI elements
    let sliderContainer = UIView()
    var slider: CustomSlider?
    let muteLabel = UILabel()

    // Track mute state
    var isMuted: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set up the player layer
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)

        // Add tap gesture recognizer for mute/unmute
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleMute))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)

        // Add long press gesture recognizer for pause
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pauseOnLongPress))
        self.addGestureRecognizer(longPressGesture)

        // Add mute label for testing purposes
        configureMuteLabel()
        playerLayer.player?.play()
    }
    override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.configureSlider()
        }
        }

    // MARK: - Slider Configuration
    private func configureSlider() {
        guard let slider = slider else { return }
        sliderContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sliderContainer)
        // Add slider to container view
        slider.translatesAutoresizingMaskIntoConstraints = false
        sliderContainer.addSubview(slider)
        slider.isUserInteractionEnabled = true
        slider.hideSliderThumb(hide: true)
        slider.addTarget(self, action: #selector(playbackSliderValueChanged(_:event:)), for: .valueChanged)
        // Set slider constraints
        NSLayoutConstraint.activate([
            sliderContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sliderContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sliderContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            sliderContainer.heightAnchor.constraint(equalToConstant: 50),
            slider.leadingAnchor.constraint(equalTo: sliderContainer.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: sliderContainer.trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: sliderContainer.bottomAnchor)
        ])
    }

    // MARK: - Mute Label Configuration
    private func configureMuteLabel() {
        muteLabel.text = "Mute"
        muteLabel.textColor = .white
        muteLabel.font = UIFont.systemFont(ofSize: 20)
        muteLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(muteLabel)

        NSLayoutConstraint.activate([
            muteLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            muteLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    // MARK: - Slider Value Changed
    @objc func playbackSliderValueChanged(_ playbackSlider: UISlider, event: UIEvent) {
        guard let slider = slider else { return }
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                player?.pause()
            case .moved:
                let seconds: Int64 = Int64(slider.value)
                let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
                player?.seek(to: targetTime)
            case .ended:
                // User finished dragging the slider
                let seconds: Int64 = Int64(slider.value)
                let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
                player?.seek(to: targetTime)
                sliderValueChanged()
                player?.play()
            default:
                break
            }
        }
    }
    
    override func prepareForReuse() {
      super.prepareForReuse()
      playerLayer.player?.pause()
      super.prepareForReuse()
      player?.pause()
      player?.seek(to: .zero)
      player = nil
      playerLayer.player = nil
    }

    // MARK: - Video Configuration
    func configureCell(url: URL) {
        if let videoPlayerView = superview as? VideoPlayerView {
            player?.isMuted = videoPlayerView.isMuted
        }
        if player == nil {
            player = AVPlayer(url: url)
            playerLayer.player = player
            playerLayer.frame = self.bounds
            playerLayer.videoGravity = .resizeAspectFill
            // Add observer for when the video finishes playing
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        } else {
            // The cell is being reused; reset the video to the beginning and play it
            player?.seek(to: .zero)
            player?.play()
        }
       
        // Add time observer to update the slider
        addTimeObserver()
    }

    // MARK: - Time Observer
    private func addTimeObserver() {
        let interval = CMTime(value: 1, timescale: 1)
        player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { [weak self] (progressTime) in
            guard let self = self else { return }
            let seconds = CMTimeGetSeconds(progressTime)
            let duration = CMTimeGetSeconds(self.player?.currentItem?.duration ?? .zero)
            if duration > 0 {
                let progress = Float(seconds / duration)
                self.slider?.setValue(progress, animated: true)
            }
        })
    }
//    Second, in your sliderValueChanged method, update the video playback time based on the slider's value:
    @objc func sliderValueChanged() {
        guard let slider = slider else { return }
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(slider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }
    }
   
    // MARK: - Playback Control
    @objc func playerDidFinishPlaying(notification: NSNotification) {
        player?.seek(to: .zero)
        player?.play()
    }

    func pauseVideo() {
        player?.pause()
    }

    func playVideo() {
        player?.play()
    }

    func restartVideo() {
        player?.seek(to: .zero)
        player?.play()
    }
    
    func updateMuteState(isMuted: Bool) {
        player?.isMuted = isMuted
        muteLabel.text = isMuted ? "Unmute" : "Mute"
    }

    // MARK: - Toggle Mute
    @objc func toggleMute() {
        if let player = player {
            player.isMuted = !player.isMuted
            muteLabel.text = player.isMuted ? "Unmute" : "Mute"
            // Update the mute state in the VideoPlayerView
            if let videoPlayerView = superview as? VideoPlayerView {
                videoPlayerView.isMuted = player.isMuted
            }
        }
    }

    // MARK: - Pause on Long Press
    @objc func pauseOnLongPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            player?.pause()
            muteLabel.text = "Paused"
        } else if sender.state == .ended {
            player?.play()
            muteLabel.text = player?.isMuted ?? false ? "Mute" : "Unmute"
        }
    }
}
