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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionLabel: UILabel!
    var doubleTapGesture: UITapGestureRecognizer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if pageViewController.infoOn {
            self.descriptionLabel.alpha = 1
        } else {
            self.descriptionLabel.alpha = 0
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setImage()
        self.scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 6.0;
        self.doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        self.doubleTapGesture.numberOfTapsRequired = 2
        self.scrollView.addGestureRecognizer(doubleTapGesture)
        
        self.descriptionLabel.text = self.photo.descriptionString()
    }
    
    func setImage() {
        
        self.imageView.sd_setImage(with: photo.url, completed: {
            completionBlock in
            
            self.imageView.bounds.size = CGSize(width: completionBlock.0!.size.width, height: completionBlock.0!.size.height)
            self.imageView.center = self.scrollView.center
            self.scrollView.contentSize = self.imageView.frame.size
        })
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func doubleTapped() {
        var scale: CGFloat!
        
        if scrollView.zoomScale == 1 {
            scale = 3
        } else {
            scale = 1
        }
        
        let point = doubleTapGesture.location(in: imageView)
        
        let scrollSize = scrollView.frame.size
        let size = CGSize(width: scrollSize.width / scale,
                          height: scrollSize.height / scale)
        let origin = CGPoint(x: point.x - size.width / 3,
                             y: point.y - size.height / 3)
        scrollView.zoom(to:CGRect(origin: origin, size: size), animated: true)
        
    }
}

