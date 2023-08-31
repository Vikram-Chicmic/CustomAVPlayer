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
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
         let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
         guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
         collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
     }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(">>>>>>>> \(indexPath.row)")
        // start video
        if let cell = cell as? ReelCell {
            guard let url = URL(string: videos[indexPath.row]) else {
                return
            }
//            cell.slider = self.slider
            cell.configureCell(url: url)
            cell.restartVideo()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ReelCell {
            cell.player?.pause()
                  // Seek to the beginning of the video
                  cell.player?.seek(to: .zero)
        }
    }
    
      // Set the number of items (videos) in your collection view.
      public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return videos.count
      }

      // Configure each cell (row) in the collection view.
      public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reel", for: indexPath) as? ReelCell else {
              fatalError("Failed to dequeue a ReelCell.")
          }
          guard let url = URL(string: videos[indexPath.row]) else {
              return UICollectionViewCell()
          }
          print("Current index: \(indexPath.section) \(indexPath.item) \(indexPath.row)")
        
          cell.updateMuteState(isMuted: mute)
          cell.slider = self.slider
          cell.configureCell(url: url)
          
          return cell
      }

      // Set the size of each cell (row) in the collection view.
      public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          print("Current size", collectionView.bounds.size)
          return self.frame.size
      }
  }
