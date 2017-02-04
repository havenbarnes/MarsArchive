//
//  GalleryViewController+Gallery.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import UIKit

extension GalleryViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cameras.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cameraCell = self.dequeueReusableCell(withReuseIdentifier: "CameraCell", for: indexPath) as! CameraCell
        cameraCell.nameLabel.layer.masksToBounds = true
        cameraCell.nameLabel.layer.cornerRadius = 8
        
        if indexPath.row == self.selectedCameraIndex {
            cameraCell.nameLabel.backgroundColor = UIColor.lightGray
            cameraCell.nameLabel.textColor = UIColor.black
        } else {
            cameraCell.nameLabel.backgroundColor = UIColor.from(string: "424242")
            cameraCell.nameLabel.textColor = UIColor.from(string: "DBDBDB")
        }
        
        if indexPath.row == 0 {
            cameraCell.nameLabel.text = "ALL"
            return cameraCell
        }
        
        let camera = self.cameras[indexPath.row - 1]
        cameraCell.nameLabel.text = camera.name
        return cameraCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {
            return CGSize(width: 50, height: 46)
        }
        
        let numCharacters = self.cameras[indexPath.row - 1].name.characters.count
        let width = numCharacters * 16
        
        return CGSize(width: width, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.row != self.selectedCameraIndex else {
            return
        }
        
        if indexPath.row == 0 {
            self.selectedCamera = nil
            updateCameraCollection()
            self.selectionDelegate.cameraSelectionView(self, didSelectCamera: nil)
        } else {
            self.selectedCamera = self.cameras[indexPath.row - 1]
            self.selectedCameraIndex = indexPath.row
            updateCameraCollection()
            self.selectionDelegate.cameraSelectionView(self, didSelectCamera: self.cameras[indexPath.row - 1])
        }
    }

}
