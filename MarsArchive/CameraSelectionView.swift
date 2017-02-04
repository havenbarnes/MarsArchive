//
//  CameraSelectionView.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit

class CameraSelectionView: UICollectionView {

    var cameras: [Camera] = []
    
    func setAvailableCamera(_ cameras: [Camera]) {
        self.cameras = cameras
        self.reloadData()
    }
}
