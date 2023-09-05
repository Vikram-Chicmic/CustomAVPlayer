import UIKit
import AVFoundation

class ReelCell: UICollectionViewCell {
    // Video player properties
    let playerLayer: AVPlayerLayer = AVPlayerLayer()
//    var player: AVPlayer?
    var timeObserver: Any?

    // Slider and UI elements
    let sliderContainer = UIView()
    var muteIconContainer = UIView()
    var muteIcon = UIButton()
    var videoPlayerView: VideoPlayerView?
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
        configureTapFunciton()
        
        // Add long press gesture recognizer for pause
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pauseOnLongPress))
        self.addGestureRecognizer(longPressGesture)
        
        // Call play() after setting up the player
        playerLayer.player?.play()
    }

    
    override func layoutSubviews() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.configureSlider()
            if let videoPlayerView = self.videoPlayerView {
                if videoPlayerView.tapFunctionForReel == .playPause && videoPlayerView.showMuteForReel {
                    self.configureMuteIcon()
                }
            }
          }
        }
    
    // MARK: - Configure MuteUnmute
    private func configureMuteIcon() {
        muteIconContainer.translatesAutoresizingMaskIntoConstraints =  false
        self.addSubview(muteIconContainer)
        if let muteicon = videoPlayerView?.muteButton {
            self.muteIcon = muteicon
        }
        muteIcon.setTitle("", for: .normal)
        muteIconContainer.addSubview(muteIcon)
        NSLayoutConstraint.activate([
            muteIconContainer.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            muteIconContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            muteIconContainer.heightAnchor.constraint(equalToConstant: 30),
            muteIconContainer.widthAnchor.constraint(equalToConstant: 30),
            muteIcon.centerYAnchor.constraint(equalTo: muteIconContainer.centerYAnchor),
            muteIcon.centerXAnchor.constraint(equalTo: muteIconContainer.centerXAnchor)
        ])
        muteIcon.addTarget(self, action: #selector(toggleMute), for: .touchUpInside)
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

    // MARK: - Slider Value Changed
    @objc func playbackSliderValueChanged(_ playbackSlider: UISlider, event: UIEvent) {
        guard let slider = slider else { return }
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                playerLayer.player?.pause()
            case .moved:
                let seconds: Int64 = Int64(slider.value)
                let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
                playerLayer.player?.seek(to: targetTime)
            case .ended:
                // User finished dragging the slider
                let seconds: Int64 = Int64(slider.value)
                let targetTime: CMTime = CMTimeMake(value: seconds, timescale: 1)
                playerLayer.player?.seek(to: targetTime)
                sliderValueChanged()
                playerLayer.player?.play()
            default:
                break
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Pause and reset the player
        playerLayer.player?.pause()
        playerLayer.player?.pause()
        playerLayer.player?.seek(to: .zero)
        
        // Remove observers and time observers
        NotificationCenter.default.removeObserver(self)
//        removeTimeObserver()
        
        // Clear the player and playerLayer
        playerLayer.player = nil
    }

    // MARK: - Video Configuration
    func configureCell(url: URL) {
        if let player = playerLayer.player , let videoPlayerView = videoPlayerView {
            player.isMuted = videoPlayerView.isMute
        }
        if playerLayer.player == nil {
            playerLayer.player = AVPlayer(url: url)
            playerLayer.frame = self.bounds
            playerLayer.videoGravity = .resizeAspectFill
            // Add observer for when the video finishes playing
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerLayer.player?.currentItem)
        } else {
            // The cell is being reused; reset the video to the beginning and play it
            playerLayer.player?.seek(to: .zero)
            playerLayer.player?.play()
        }
        
        configureTapFunciton()
        // Add time observer to update the slider
        addTimeObserver()
    }
}
