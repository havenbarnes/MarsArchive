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
    
    var datePref = false
    var loaded = false
    let api = App.shared.api
    var rover: Rover!
    var photos: [Photo] = []
    var selectedSol: Int = 0
    
    var updateTimer: Timer!
    
    @IBOutlet weak var activeLabel: UILabel!
    @IBOutlet weak var launchDateLabel: UILabel!
    @IBOutlet weak var landingDateLabel: UILabel!
    @IBOutlet weak var totalPhotoCountLabel: UILabel!
    @IBOutlet weak var infoTopLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var dayTypeSwitch: UISwitch!
    @IBOutlet weak var settingsTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var dateTypeLabel: UILabel!
    @IBOutlet weak var solLabel: UICountingLabel!
    @IBOutlet weak var photoCountLabel: UILabel!
    @IBOutlet weak var solSlider: UISlider!
    @IBOutlet weak var solStepper: UIStepper!
    @IBOutlet weak var cameraSelectionView: CameraSelectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Day to Today
        self.selectedSol = self.rover.maxSol
        
        configureUI()
        updateGallery()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !loaded {
            animatePresentation()
            loaded = true
        }
    }
    
    // MARK: - Timer Configuration
    func startUpdateTimer() {
        if self.updateTimer != nil {
            self.updateTimer.invalidate()
        }
        
        self.updateTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: {
            timer in
            
            self.updateGallery()
        })
    }
    
    // MARK: - UI Configuration
    func configureUI() {
        configureNavBar()
        configureSettings()
        configureInfo()
        configureGallery()
        configureSliderAndStepper()
        configureCameraSelection()
    }
    
    func configureNavBar() {
        self.navigationController!.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = self.rover.name
    }
    
    func configureSettings() {
        self.settingsTopConstraint.constant = -100

        self.datePref = UserDefaults.standard.bool(forKey: "datePref")
        self.dayTypeSwitch.setOn(datePref, animated: false)
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.datePref {
                self.dateTypeLabel.text = "EARTH"
            } else {
                self.dateTypeLabel.text = "SOL"
            }
            self.solLabel.text = self.displayDay(self.selectedSol)
        })
    }
    
    func configureInfo() {
        self.infoTopLayoutConstraint.constant = -300
        if !self.rover.status {
            self.activeLabel.text = "Inactive"
            self.activeLabel.textColor = UIColor.red
        }
        self.launchDateLabel.text = Utility.shortString(from: self.rover.launchDate)
        self.landingDateLabel.text = Utility.shortString(from: self.rover.landingDate)
        self.totalPhotoCountLabel.text = String(describing: self.rover.photoCount)
    }
    
    func configureGallery() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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
    
    // MARK: - Animation Presentation
    func animatePresentation() {
        self.solLabel.format = "%d"
        self.solLabel.animationDuration = 0.7
        
        UIView.animate(withDuration: 0.7, animations: {
            self.solSlider.setValue(self.solSlider.maximumValue, animated: true)
        })
        
        if self.datePref {
            self.solLabel.text = Utility.shortString(from: self.rover.landingDate)
            
            UIView.animate(withDuration: 0.7, animations: {
                self.solLabel.text = self.displayDay(self.rover.maxSol)
            }, completion: nil)
        } else {
            self.solLabel.countFromZero(to: CGFloat(self.rover.maxSol))
        }
        
    }
    
    func cameraSelectionView(_ cameraSelectionView: CameraSelectionView, didSelectCamera camera: Camera?) {
        // Make Request, Update Gallery
        if camera == nil {
            print("Selected All Cameras")
            
        } else {
            print("Selected Camera: " + camera!.name)
        }
        
        updateGallery()
        
    }
    
    @IBAction func solStepperChanged(_ sender: Any) {
        
        solValueChanged(sender, value: Int(self.solStepper.value))
        
        startUpdateTimer()
        
    }
    
    @IBAction func solSliderChanged(_ sender: Any) {
        
        solValueChanged(sender, value: Int(self.solSlider.value))
        
        startUpdateTimer()
        
    }
    
    func solValueChanged(_ sender: Any, value: Int) {
        
        self.selectedSol = updateSol(value)
        self.solLabel.text = displayDay(self.selectedSol)
        self.cameraSelectionView.setAvailableCameras(self.rover.photoData[self.selectedSol])
        
        // Make sure slider and stepper stay in sync
        if sender is UIStepper {
            self.solSlider.setValue(Float(self.selectedSol), animated: true)
        } else {
            self.solStepper.value = Double(self.selectedSol)
        }
    }
    
    func displayDay(_ sol: Int) -> String {
        if !self.datePref {
            return String(describing: sol)
        }
        
        let daysSinceLand = Int(Double(sol) * 1.0274912510416665)
        let landingDate = self.rover.landingDate
        let date = Calendar.current.date(byAdding: .day, value: daysSinceLand, to: landingDate)
        
        return Utility.shortString(from: date!)
    }
    
    func earthDay(for sol: Int) -> String {
        let daysSinceLand = Int(Double(sol) * 1.0274912510416665)
        let landingDate = self.rover.landingDate
        let date = Calendar.current.date(byAdding: .day, value: daysSinceLand, to: landingDate)
        
        return Utility.apiString(from: date!)
    }
    
    /**
     Jump to the correct sol based on whether there
     are photos for it
     */
    func updateSol(_ value: Int) -> Int {
        guard value != 0 && value != self.rover.maxSol else {
            return value
        }
        
        var adjustedValue = value
        
        if adjustedValue > self.selectedSol || adjustedValue <= 0 {
            // Jump up until we find sol with photos
            if self.rover.photoData[adjustedValue] == nil {
                adjustedValue = updateSol(adjustedValue + 1)
            }
        } else if adjustedValue < self.selectedSol || adjustedValue >= self.rover.maxSol {
            // Jump down until we find sol with photos
            if self.rover.photoData[adjustedValue] == nil {
                adjustedValue = updateSol(adjustedValue - 1)
            }
        }
        
        return adjustedValue
    }
    
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        
        if self.infoTopLayoutConstraint.constant == 0 {
            self.infoTopLayoutConstraint.constant = -300
        } else {
            self.infoTopLayoutConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        
        if self.navigationItem.rightBarButtonItem?.image == #imageLiteral(resourceName: "Settings") {
            self.settingsButton.title = "Done"
            self.navigationItem.rightBarButtonItem?.image = nil
            self.settingsTopConstraint.constant = 0
        } else {
            self.settingsButton.title = nil
            self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "Settings")
            self.settingsTopConstraint.constant = -100
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    
    }
    
    @IBAction func dateTypePreferenceChanged(_ sender: Any) {
        UserDefaults.standard.set(self.dayTypeSwitch.isOn, forKey: "datePref")
        UserDefaults.standard.synchronize()
        self.datePref = self.dayTypeSwitch.isOn
    
        configureSettings()
        updateGallery()
    }
}
