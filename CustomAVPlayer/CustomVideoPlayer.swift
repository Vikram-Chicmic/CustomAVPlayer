//
//  CustomVideoPlayer.swift
//  AVPlayerCustom
//
//  Created by Himanshu on 7/24/23.
//

import UIKit
import AVFoundation
import Photos

class CustomVideoPlayer: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - properties
    
    let picker = UIImagePickerController()
    let playerLayer = AVPlayerLayer()
    var duration: Float = 0.0
    
    // MARK: - outlets
    
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeButton: UIButton!
//    @IBOutlet weak var endTime: UILabel!
//    @IBOutlet weak var currentTime: UILabel!
    
//    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVideoPicker()
        setVideoContainer()
//        customizedSlider()
    }
    
//    func customizedSlider() {
//        slider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
//    }
    
    func setVideoContainer() {
        videoContainer.isHidden = true
        videoContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showHideControls(sender:))))
        videoContainer.backgroundColor = .black
    }
    
    // MARK: - video picker
    
    func setVideoPicker() {
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary) ?? []
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let movieUrl = info[.mediaURL] as? URL else { return }
        setPlayerLayer(url: movieUrl)
    }
    
    // MARK: - helper methods
    
    func getDurationString(seconds: Float64) -> String {
        let secondString = String(format: "%02d", Int(seconds) % 60)
        let minutString = String(format: "%02d", Int(seconds) / 60)
        return "\(minutString):\(secondString)"
    }
    
    // MARK: - video player
    
    func setPlayerLayer(url: URL) {
        
        videoContainer.isHidden = false
        
        let player = AVPlayer(url: url)
        
        let interval = CMTime(value: 1, timescale: 2)
        
        // time interval for updating slider value
        
//        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
//            let seconds = CMTimeGetSeconds(progressTime)
//            self.currentTime.text = self.getDurationString(seconds: seconds)
//
//            self.slider.setValue(Float(seconds), animated: true)
//        })
        
//        let seconds = CMTimeGetSeconds(player.currentItem?.asset.duration ?? CMTime(seconds: .zero, preferredTimescale: .zero))
//
//        self.endTime.text = getDurationString(seconds: seconds)
//
//        slider.maximumValue = Float(seconds)
        
        self.startPlayer(player: player)
        
        setControls()
    }
    
    func pausePlayer() {
        playerLayer.player?.pause()
    }
    
    func playPlayer() {
        playerLayer.player?.play()
    }
    
    func startPlayer(player: AVPlayer) {
        playerLayer.frame = videoContainer.bounds
        playerLayer.player = player
        videoContainer.layer.addSublayer(playerLayer)
        player.play()
    }
    
    // MARK: - player controls

    func setControls() {
        volumeButton.setImage(UIImage(systemName: "volume.3.fill"), for: .normal)
        volumeButton.isHidden = false
        playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        playPauseButton.isHidden = false
        
//        slider.isHidden = false
//        currentTime.isHidden = false
//        endTime.isHidden = false
        closeButton.isHidden = false
    }
    
    // MARK: - tap events
    
    @objc
    func showHideControls(sender: UITapGestureRecognizer) {
        if playerLayer.player != nil {
            playPauseButton.isHidden = !playPauseButton.isHidden
            volumeButton.isHidden = !volumeButton.isHidden
//            slider.isHidden = !slider.isHidden
//            currentTime.isHidden = !currentTime.isHidden
//            endTime.isHidden = !endTime.isHidden
            closeButton.isHidden = !closeButton.isHidden
        }
    }

    // MARK: - ib actions
    
//    @IBAction func sliderDidSlide(_ sender: UISlider) {
//        let seconds = slider.value
//        playerLayer.player?.currentItem?.seek(to: CMTimeMakeWithSeconds(Float64(seconds), preferredTimescale: 60000))
//    }
    
    @IBAction func selectVideo(_ sender: UIButton) {
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if playPauseButton.currentImage == UIImage(systemName: "pause.circle.fill") {
            playerLayer.player?.pause()
            playPauseButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        } else {
            playerLayer.player?.play()
            playPauseButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        }
    }
    
    @IBAction func volumeControl(_ sender: UIButton) {
        if volumeButton.currentImage == UIImage(systemName: "volume.3.fill") {
            playerLayer.player?.isMuted = true
            volumeButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
        } else {
            playerLayer.player?.isMuted = false
            volumeButton.setImage(UIImage(systemName: "volume.3.fill"), for: .normal)
        }
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        playerLayer.player = nil
        
        playPauseButton.isHidden = !playPauseButton.isHidden
        volumeButton.isHidden = !volumeButton.isHidden
//        slider.isHidden = !slider.isHidden
//        currentTime.isHidden = !currentTime.isHidden
//        endTime.isHidden = !endTime.isHidden
        closeButton.isHidden = !closeButton.isHidden
        
        videoContainer.isHidden = true
    }
    
    // MARK: - observers

}
