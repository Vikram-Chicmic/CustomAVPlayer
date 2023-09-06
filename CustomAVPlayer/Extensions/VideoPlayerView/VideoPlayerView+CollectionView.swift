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
//    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//         let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//         guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
//        print(indexPath)
//        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
//     }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(">>>>>>>> \(indexPath.row)")
        // start video
        if let cell = cell as? ReelCell {
            guard let url = URL(string: videos[indexPath.row]) else {
                return
            }
            cell.configureCell(url: url)
            cell.restartVideo()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ReelCell {
            cell.playerLayer.player?.pause()
                  cell.playerLayer.player?.seek(to: .zero)
        }
    }

      public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return videos.count
      }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Capture the index path in a closure to ensure it's retained correctly
        let configureCellForIndexPath: (IndexPath) -> UICollectionViewCell = { [weak self] capturedIndexPath in
            guard let self = self else {
                return UICollectionViewCell()
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reel", for: capturedIndexPath) as? ReelCell else {
                fatalError("Failed to dequeue a ReelCell.")
            }
            
            guard let url = URL(string: self.videos[capturedIndexPath.row]) else {
                return UICollectionViewCell()
            }
            print(">>>Current>>",indexPath, indexPath.row)
            cell.slider = self.slider
            cell.videoPlayerView = self
            cell.configureCell(url: url)
            return cell
        }
        
        // Check if cell is already visible
        if collectionView.indexPathsForVisibleItems.contains(indexPath) {
            // Cell is already visible, return the existing cell
            if let cell = collectionView.cellForItem(at: indexPath) as? ReelCell {
                return cell
            }
        }
        
        // If cell is not visible or not already loaded, use the captured index path
        return configureCellForIndexPath(indexPath)
    }


      // Set the size of each cell (row) in the collection view.
      public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: self.bounds.width, height: self.bounds.height)
      }
  }
