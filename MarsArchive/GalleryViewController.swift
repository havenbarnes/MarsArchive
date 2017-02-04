//
//  GalleryViewController.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import UICountingLabel

class GalleryViewController: UIViewController, CameraSelectionViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var loaded = false
    let api = App.shared.api
    var rover: Rover!
    var selectedSol: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var solLabel: UICountingLabel!
    @IBOutlet weak var solSlider: UISlider!
    @IBOutlet weak var solStepper: UIStepper!
    @IBOutlet weak var cameraSelectionView: CameraSelectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Day to Today
        self.selectedSol = self.rover.maxSol

        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !loaded {
            animatePresentation()
            loaded = true
        }
    }
    
    func configureUI() {

        configureNavBar()
        configureSliderAndStepper()
        configureCameraSelection()
    }
    
    func animatePresentation() {
        self.solLabel.format = "%d"
        self.solLabel.animationDuration = 0.7
        
        UIView.animate(withDuration: 0.7, animations: {
            self.solSlider.setValue(self.solSlider.maximumValue, animated: true)
        })
        
        self.solLabel.countFromZero(to: CGFloat(self.rover.maxSol))

    }
    
    func configureNavBar() {
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.backgroundColor = UIColor.clear
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    func configureSliderAndStepper() {
        self.solSlider.maximumValue = Float(self.rover.maxSol)
        self.solStepper.maximumValue = Double(self.rover.maxSol)
        self.solStepper.value = Double(self.rover.maxSol)
    }
    
    func configureCameraSelection() {
        self.cameraSelectionView.delegate = self.cameraSelectionView
        self.cameraSelectionView.dataSource = self.cameraSelectionView
        self.cameraSelectionView.selectionDelegate = self
        self.cameraSelectionView.setAvailableCameras(self.rover.photoData[self.selectedSol])
    }
    
    func cameraSelectionView(_ cameraSelectionView: CameraSelectionView, didSelectCamera camera: Camera?) {
        // Make Request, Update Gallery
        if camera == nil {
            print("Selected All Cameras")
            
        } else {
            print("Selected Camera: " + camera!.name)

        }
        
    }
    
    @IBAction func solStepperChanged(_ sender: Any) {
        
        solValueChanged(sender, value: Int(self.solStepper.value))
        
        
        
    }
    
    @IBAction func solSliderChanged(_ sender: Any) {
        
        solValueChanged(sender, value: Int(self.solSlider.value))
        
    }
    
    func solValueChanged(_ sender: Any, value: Int) {
        self.selectedSol = value
        self.solLabel.text = String(describing: self.selectedSol)
        self.cameraSelectionView.setAvailableCameras(self.rover.photoData[self.selectedSol])
        
        // Make sure slider and stepper stay in sync
        if sender is UIStepper {
            self.solSlider.setValue(Float(self.selectedSol), animated: true)
        } else {
            self.solStepper.value = Double(self.selectedSol)
        }
        
    }
    
}
