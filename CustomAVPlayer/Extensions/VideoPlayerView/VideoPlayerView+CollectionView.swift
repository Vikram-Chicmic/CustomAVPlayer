//
//  VideoPlayerView+CollectionViewExtension.swift
//  CustomAVPlayer
//
//  Created by ChicMic on 08/08/23.
//

import Foundation
import UIKit

extension VideoPlayerView: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reel", for: indexPath) as? ReelCell else {
            fatalError("ayo u got error,")
        }
        
        let url = Bundle.main.path(forResource: "demovideo", ofType: "mp4")
        
        cell.reelView.startAvPlayer(videoURL: URL(fileURLWithPath: url!))
        cell.reelView.avPlayerLayer.player?.play()
        
        return cell
    }
    
}
