import UIKit
import AVFoundation

class ReelCell: UICollectionViewCell {
    let playerLayer: AVPlayerLayer = AVPlayerLayer()
    var player: AVPlayer?
    let sliderContainer = UIView()
    var slider = CustomSlider()
    let muteLabel = UILabel()
    var isMuted: Bool = false
    var timeObserver: Any?
//    var videoPlayerView = VideoPlayerView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playerLayer.frame = self.bounds
        self.layer.addSublayer(playerLayer)
        
        // Add tap gesture recognizer for mute/unmute
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleMute))
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
        // Add long press gesture recognizer for pause
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pauseOnLongPress))
        self.addGestureRecognizer(longPressGesture)
        
        
        // custom slider
        sliderContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sliderContainer)

        // Add slider to container view
        slider.translatesAutoresizingMaskIntoConstraints = false
        sliderContainer.addSubview(slider)
        slider.hideSliderThumb(hide: true)
        
        // Set slider constraints
        NSLayoutConstraint.activate([
            sliderContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sliderContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sliderContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            slider.leadingAnchor.constraint(equalTo: sliderContainer.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: sliderContainer.trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: sliderContainer.bottomAnchor)

//            slider.bottomAnchor.constraint(equalTo: sliderContainer.bottomAnchor + 20)
        ])


        // Add mute label for testing purposes
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

    func configureCell(url: URL) {
        if let videoPlayerView = superview as? VideoPlayerView {
            player?.isMuted = videoPlayerView.isMuted
        }
        if player == nil {
            player = AVPlayer(url: url)
            playerLayer.player = player
            playerLayer.frame = self.bounds
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.player?.play()
            // Add observer for when the video finishes playing
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        } else {
            // The cell is being reused; reset the video to the beginning and play it
            player?.seek(to: .zero)
            player?.play()
        }
        
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            
            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(self.player?.currentItem?.duration ?? .zero)
            let progress = currentTime / duration
            
            // Update the slider value
            self.slider.value = Float(progress)
        }}
    
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
    
    override func prepareForReuse() {
            super.prepareForReuse()
            player?.pause()
            player?.seek(to: .zero)
            playerLayer.player = nil
            player = nil
            NotificationCenter.default.removeObserver(self)
        if let timeObserver = timeObserver {
               player?.removeTimeObserver(timeObserver)
               self.timeObserver = nil
           }
        }
    
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
