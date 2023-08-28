//
//  ReelCell.swift
//  CustomAVPlayer
//
//  Created by Nitin on 8/8/23.
//

import UIKit
import AVFoundation

class ReelCell: UICollectionViewCell {

    let playerLayer: AVPlayerLayer = AVPlayerLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        playerLayer.frame = self.bounds
        
        self.layer.addSublayer(playerLayer)
    }

    func configureCell(url: URL) {
//        let url1 = Bundle.main.path(forResource: "video", ofType: "mp4")!
//        print(url1)
        playerLayer.player = AVPlayer(url: url)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.player?.play()
    }
    
    func pauseVideo() {
        playerLayer.player?.pause()
    }
    
    func playVideo() {
        playerLayer.player?.play()
    }
    
    func restartVideo() {
        playerLayer.player?.seek(to: .zero)
        playVideo()
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
        playerLayer.player?.pause()
        playerLayer.player = nil
      }
}
