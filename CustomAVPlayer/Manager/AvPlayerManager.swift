//
//  AvPlayerManager.swift
//  CustomAVPlayer
//
//  Created by Nitin on 8/4/23.
//

import AVFoundation
import UIKit

class AvPlayerManager {
    
    // MARK: - Properties
    
    // Shared instance for AvPlayerManager
    static let shared = AvPlayerManager()
    
    // Instance for AVPlayerLayer
    let avPlayerLayer = AVPlayerLayer()
    var player: AVPlayer?
    
    // MARK: - Player State
    
    var audioIsMuted: Bool? {
        return self.player?.isMuted
    }
    
    var videoCompleted: Bool {
        return self.player?.currentItem?.duration == self.player?.currentTime()
    }
    
    // MARK: - Initializers
    
    /// Default Intializer, set the player instance from avPlayerLayer
    init() {
        self.player = avPlayerLayer.player
    }
    
    func playPlayer() {
        self.player?.play()
    }
    
    func pausePlayer() {
        self.player?.pause()
    }
    
    func changePlayingStateOfPlayer() {
        if player?.timeControlStatus == .playing {
            player?.pause()
        } else if player?.currentItem?.currentTime() == player?.currentItem?.duration {
            player?.seek(to: CMTime.zero)
            player?.play()
        } else {
            player?.play()
        }
    }
    
    func toggleAudioStateOfPlayer() {
        self.player?.isMuted.toggle()
    }
    
    func seekPlayerVideo(withBuffer buffer: Double) {
        if Double((player?.currentItem?.duration.seconds)!) - Double((player?.currentTime().seconds)!) > buffer {
            player?.seek(to: CMTime(seconds: (player?.currentTime().seconds)! + buffer, preferredTimescale: 1))
        } else {
            player?.seek(to: (player?.currentItem!.duration)!)
        }
    }
    
    func replaceCurrentItem(with item: AVPlayerItem?) {
        player?.replaceCurrentItem(with: item)
    }
}
