//
//  GalleryPageViewController.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import SDWebImage

class GalleryPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var infoOn = true
    var rover: Rover!
    var photos: [Photo]!
    var startIndex: Int = 0
    var currentPageItem: GalleryPageItemViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.infoOn = UserDefaults.standard.bool(forKey: "infoToggle")
        
        self.delegate = self
        self.dataSource = self
        
        let newGalleryPageItem = instantiate("Main", identifier: "GalleryPageItemViewController") as! GalleryPageItemViewController
        newGalleryPageItem.index = startIndex
        newGalleryPageItem.photo = self.photos[startIndex]
        newGalleryPageItem.pageViewController = self
        self.setViewControllers([newGalleryPageItem], direction: .forward, animated: true, completion: {
            complete in
            
            if complete {
                newGalleryPageItem.setImage()
            }
            
        })
        
        self.currentPageItem = newGalleryPageItem
        updateTitle()
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.currentPageItem = self.viewControllers![0] as! GalleryPageItemViewController
        updateTitle()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let galleryPageItem = viewController as! GalleryPageItemViewController
        
        var currIndex = galleryPageItem.index
        
        guard currIndex != 0 else {
            return nil
        }
        
        currIndex -= 1
        
        let newGalleryPageItem = instantiate("Main", identifier: "GalleryPageItemViewController") as! GalleryPageItemViewController
        newGalleryPageItem.index = currIndex
        newGalleryPageItem.photo = self.photos[currIndex]
        newGalleryPageItem.pageViewController = self
        return newGalleryPageItem
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let galleryPageItem = viewController as! GalleryPageItemViewController
        
        var currIndex = galleryPageItem.index
        
        guard currIndex != self.photos.count - 1 else {
            return nil
        }
        
        currIndex += 1
        
        let newGalleryPageItem = instantiate("Main", identifier: "GalleryPageItemViewController") as! GalleryPageItemViewController
        newGalleryPageItem.index = currIndex
        newGalleryPageItem.photo = self.photos[currIndex]
        newGalleryPageItem.pageViewController = self
        return newGalleryPageItem
        
    }
    
    func updateTitle() {
        self.navigationItem.backBarButtonItem?.title = nil
        self.navigationItem.title = "\(self.currentPageItem.index + 1) of \(self.photos.count)"
    }
    
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        self.infoOn = !self.infoOn
        UserDefaults.standard.set(self.infoOn, forKey: "infoToggle")
        UserDefaults.standard.synchronize()
        if self.currentPageItem.descriptionLabel.alpha == 0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentPageItem.descriptionLabel.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.currentPageItem.descriptionLabel.alpha = 0
            })
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        shareImage()
    }
    
    func shareImage() {
        
        var sharedItems: [Any] = []
        
        sharedItems.append(self.currentPageItem.imageView.image as Any)
        let shareString = "Check out this picture taken by the " + self.rover.name + " Rover!"
        sharedItems.append(shareString)
            
        let activityViewController = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
            
        self.present(activityViewController, animated: true, completion: nil)
    }
}
