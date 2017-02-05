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
    
    var rover: Rover!
    var photos: [Photo]!
    var startIndex: Int = 0
    var currentPageItem: GalleryPageItemViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        let newGalleryPageItem = instantiate("Main", identifier: "GalleryPageItemViewController") as! GalleryPageItemViewController
        newGalleryPageItem.index = startIndex
        newGalleryPageItem.photo = self.photos[startIndex]
        self.setViewControllers([newGalleryPageItem], direction: .forward, animated: true, completion: {
            complete in
            
            if complete {
                newGalleryPageItem.setImage()
            }
            
        })
        
        self.currentPageItem = newGalleryPageItem

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
        self.currentPageItem = newGalleryPageItem
        
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
        self.currentPageItem = newGalleryPageItem
        
        return newGalleryPageItem
        
    }
    
    @IBAction func actionButtonPressed(_ sender: Any) {
        shareImage()
    }
    
    func shareImage() {
        
        var sharedItems: [Any] = []
        
        let downloader = SDWebImageDownloader()
        downloader.downloadImage(with: self.currentPageItem.photo.url, options: [], progress: nil, completed: {
            completionBlock in
            
            sharedItems.append(completionBlock.0!)
            let shareString = "Check out this picture taken by the " + self.rover.name + " Rover!"
            sharedItems.append(shareString)
            
            let activityViewController = UIActivityViewController(activityItems: sharedItems, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            self.present(activityViewController, animated: true, completion: nil)
            
        })
    }
}
