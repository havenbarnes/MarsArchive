//
//  ViewController.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/3/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import SceneKit

class RoversViewController: UIViewController {
    
    var scene: SCNScene!
    @IBOutlet weak var sceneView: SCNView!
    var roverNodes: [SCNNode : String] = [:]
    var cameraNode: SCNNode!
    
    var coverView: UIView!
    
    @IBOutlet weak var selectRoverLabel: UILabel!
    
    var rovers: [Rover]!

    let api = App.shared.api
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coverView = UIView(frame: self.view.frame)
        self.coverView.backgroundColor = UIColor.black
        self.view.addSubview(self.coverView)
        
        DispatchQueue.main.async {
            print("Configuring")
            self.configureScene()
        }
        
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .transitionCrossDissolve, animations: {
            self.coverView.alpha = 0
        }, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateLabel()
    }
    
    func fetchRovers() {
        self.api.fetchRoversData(completion: {
            rovers in
                        
            self.rovers = rovers.sorted(by: { $0.name < $1.name } )
            
            print(self.rovers)
        })
    }
    
    func animateLabel() {
        UIView.animate(withDuration: 0.7, animations: {
            self.selectRoverLabel.alpha = 0
        }, completion: {
            complete in
            
            if complete {
                UIView.animate(withDuration: 0.7, animations: {
                    self.selectRoverLabel.alpha = 1
                }, completion: {
                    complete in
                    
                    if complete {
                        self.animateLabel()
                    }
                })
            }
        })
    }
    
    func roverSelected(_ rover: Rover) {
        print("Selected: " + rover.name)
        
        let galleryViewController = instantiate("Main", identifier: "GalleryViewController") as! GalleryViewController
        galleryViewController.rover = rover
        
        self.navigationController!.show(galleryViewController, sender: nil)
    }
}
