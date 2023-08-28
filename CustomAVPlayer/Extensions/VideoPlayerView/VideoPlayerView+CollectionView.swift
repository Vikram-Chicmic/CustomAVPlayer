//
//  VideoPlayerView+CollectionViewExtension.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 08/08/23.
//

import Foundation
import UIKit

extension VideoPlayerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // pause video
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // start video
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
        cell.backgroundColor = colors[indexPath.item]
        cell.configureCell(url: url)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
