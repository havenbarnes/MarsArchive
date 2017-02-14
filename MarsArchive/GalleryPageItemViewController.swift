//
//  GalleryPageItemViewController.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import SDWebImage

class GalleryPageItemViewController: UIViewController, UIScrollViewDelegate {
    
    var index = 0
    var photo: Photo!
    var pageViewController: GalleryPageViewController!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pageViewController.infoOn {
            self.descriptionLabel.alpha = 1
        } else {
            self.descriptionLabel.alpha = 0
        }
        
        self.descriptionLabel.text = self.photo.descriptionString()
        setImage()
    }
    
    func setImage() {
        
        self.imageView.sd_setImage(with: photo.url)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

