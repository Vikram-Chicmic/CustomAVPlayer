//
//  VideoPlayerView+CollectionViewExtension.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 08/08/23.
//

import Foundation
import UIKit
import AVFoundation

extension VideoPlayerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // start video
        if let cell = cell as? ReelCell {
            cell.restartVideo()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ReelCell {
            cell.playerLayer.player?.seek(to: .zero)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reel", for: indexPath) as? ReelCell else {
            fatalError("ayo u got error,")
        }
        guard let url = URL(string: videos[indexPath.item]) else {
            return UICollectionViewCell()
        }
        
        cell.configureCell(url: url)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.frame.size
    }
}
