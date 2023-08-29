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
         if let cell = collectionView.cellForItem(at: indexPath) as? ReelCell {
             cell.restartVideo()
         }
     }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(">>>>>>>> \(indexPath.row)")
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
        
          cell.configureCell(url: url)
          
          return cell
      }

      // Set the size of each cell (row) in the collection view.
      public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          // Use the frame size of the VideoPlayerView as the size for each cell.
          print("cell size: \(self.frame.size)")
          let screenHeight = UIScreen.main.bounds.height
          let safeAreaHeight = UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
          let viewHeight = screenHeight - safeAreaHeight
//          return CGSize(width: UIScreen.main.bounds.width, height: viewHeight)
          return collectionView.bounds.size
      }
  }
