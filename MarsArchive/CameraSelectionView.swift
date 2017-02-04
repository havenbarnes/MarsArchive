//
//  CameraSelectionView.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit

protocol CameraSelectionViewDelegate {
    func cameraSelectionView(_ cameraSelectionView: CameraSelectionView, didSelectCamera camera: Camera?)
}

class CameraSelectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var cameras: [Camera] = []
    var selectedCamera: Camera?
    var selectionDelegate: CameraSelectionViewDelegate!
    
    func setAvailableCameras(_ cameras: [Camera]?) {
        if cameras == nil {
            self.cameras = []
        } else {
            self.cameras = cameras!
        }
        
        // If user has previously selected a camera,
        // check to see if it is in this selected sol.
        // If not, default to "ALL", but, maintain previous selection
        if self.selectedCamera != nil
            && !cameras!.contains(where: { $0.name == selectedCamera!.name } ) {
            
        }
        
        self.performBatchUpdates({
            self.reloadSections(NSIndexSet(index: 0) as IndexSet)
        }, completion: nil)
    }
    
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
        
        if indexPath.row == 0 {
            self.selectedCamera = nil
            self.selectionDelegate.cameraSelectionView(self, didSelectCamera: nil)
        } else {
            self.selectionDelegate.cameraSelectionView(self, didSelectCamera: self.cameras[indexPath.row - 1])
        }
        
    }
    
}

class CameraCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}
