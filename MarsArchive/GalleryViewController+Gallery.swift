//
//  GalleryViewController+Gallery.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

// Houses all UICollection View Logic
extension GalleryViewController {
    
    func updateGallery() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.activityIndicator.alpha = 1
            self.activityIndicator.isHidden = false
            self.collectionView.alpha = 0
            self.photoCountLabel.alpha = 0
        })
        
        let selectedCamera: Camera? = self.cameraSelectionView.selectedCameraIndex == 0 ? nil : self.cameraSelectionView.cameras[self.cameraSelectionView.selectedCameraIndex - 1]
        
        self.api.fetchPhotos(for: self.rover, sol: self.selectedSol, camera: selectedCamera, completion: {
            photos in
            
            self.photos = photos
            
            if self.photos.count == 1 {
                self.photoCountLabel.text = "1 Photo"
            } else {
                self.photoCountLabel.text = "\(self.photos.count) Photos"
            }
            
            self.activityIndicator.isHidden = true
            
            // Scroll Back To Top
            self.collectionView.setContentOffset(CGPoint(x: 0, y: -70), animated: false)
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }, completion: {
                complete in
                
                if complete {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.activityIndicator.alpha = 0
                        self.collectionView.alpha = 1
                        self.photoCountLabel.alpha = 1
                    })
                }
            })

        })
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let galleryCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        
        guard indexPath.row < self.photos.count else { return galleryCell }
        
        let photo = self.photos[indexPath.row]
        galleryCell.imageView.sd_setImage(with: photo.url)
        galleryCell.imageView.sd_setImage(with: photo.url, completed: {
            completionBlock in
            
            if completionBlock.2 == SDImageCacheType.none {
                galleryCell.imageView.alpha = 0
                UIView.animate(withDuration: 0.3, animations: {
                    galleryCell.imageView.alpha = 1
                })
            } else {
                galleryCell.imageView.alpha = 1
            }
        })
        
        return galleryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let dimension = App.shared.window.frame.width / 4.05
        
        return CGSize(width: dimension, height: dimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Go to full screen view
        let galleryPageViewController = instantiate("Main", identifier: "GalleryPageViewController") as! GalleryPageViewController
        galleryPageViewController.startIndex = indexPath.row
        galleryPageViewController.photos = self.photos
        galleryPageViewController.rover = self.rover
        self.navigationController!.show(galleryPageViewController, sender: nil)

        
    }
}

class GalleryCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}
