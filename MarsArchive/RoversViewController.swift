//
//  ViewController.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/3/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import SceneKit

class RoversViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var scene: SCNScene!
    @IBOutlet weak var sceneView: SCNView!
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var rovers: [Rover]!

    let api = App.shared.api
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScene()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(fetchRovers), for: .valueChanged)
        tableView.addSubview(self.refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.setNavigationBarHidden(true, animated: true)
    }
    
    func configureScene() {
        self.scene = SCNScene(named: "sphere.obj")
        
        // Sphere
        let sphereNode = self.scene.rootNode.childNodes[0]
        
        // Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // Material
        let material = sphereNode.geometry?.firstMaterial
        material?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        material?.roughness.contents = UIImage(named: "mars_bump.jpg")
        material?.normal.contents = UIImage(named: "mars_map.jpg")
        
        // Background
        let bg = UIImage(named: "space_environment_blurred.jpg")
        scene.background.contents = bg

        // Lighting
        let env = UIImage(named: "space_environment.jpg")
        scene.lightingEnvironment.contents = env
        scene.lightingEnvironment.intensity = 2.0
        
        // set the scene to the view
        self.sceneView.scene = scene
        
        // allows the user to manipulate the camera
        self.sceneView.allowsCameraControl = true
        
        sphereNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 1, z: 1, duration: 10)))
        
    }
    
    func fetchRovers() {
        self.api.fetchRoversData(completion: {
            rovers in
            
            self.rovers = rovers
            self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .fade)
            self.refreshControl.endRefreshing()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rovers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoverCell", for: indexPath) as! RoverCell
        let rover = self.rovers[indexPath.row]
        cell.nameLabel.text = rover.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        roverSelected(rovers[indexPath.row])
    }
    
    func roverSelected(_ rover: Rover) {
        print("Selected: " + rover.name)
        
        let galleryViewController = instantiate("Main", identifier: "GalleryViewController") as! GalleryViewController
        galleryViewController.rover = rover
        
        self.navigationController!.show(galleryViewController, sender: nil)
    }
}

class RoverCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

