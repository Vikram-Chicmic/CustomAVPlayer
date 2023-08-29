import UIKit
import AVFoundation

class ReelCell: UICollectionViewCell {
    let playerLayer: AVPlayerLayer = AVPlayerLayer()
    var player: AVPlayer?
    let sliderContainer = UIView()
    let slider = CustomSlider()
    let muteLabel = UILabel()
    
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
        
        
//        // custom slider
//        sliderContainer.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(sliderContainer)
//
//        // Add slider to container view
//        slider.translatesAutoresizingMaskIntoConstraints = false
//        sliderContainer.addSubview(slider)
//        slider.hideSliderThumb(hide: true)
//        // Set slider constraints
////        NSLayoutConstraint.activate([
////            sliderContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
////            sliderContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
////            sliderContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
////            slider.heightAnchor.constraint(equalToConstant: 50),
////            slider.leadingAnchor.constraint(equalTo: sliderContainer.leadingAnchor),
////            slider.trailingAnchor.constraint(equalTo: sliderContainer.trailingAnchor),
////            slider.bottomAnchor.constraint(equalTo: sliderContainer.bottomAnchor)
//////            slider.bottomAnchor.constraint(equalTo: sliderContainer.bottomAnchor + 20)
////        ])
//
//
//        // Add mute label for testing purposes
//        muteLabel.text = "Mute"
//        muteLabel.textColor = .white
//        muteLabel.font = UIFont.systemFont(ofSize: 20)
//        muteLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(muteLabel)
//
//        NSLayoutConstraint.activate([
//            muteLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
//            muteLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//        ])
    }

    func configureCell(url: URL) {
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
    }
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
        player = nil
        playerLayer.player = nil
    }
    
    @objc func toggleMute() {
        if let player = player {
            player.isMuted = !player.isMuted
            muteLabel.text = player.isMuted ? "Unmute" : "Mute"
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
