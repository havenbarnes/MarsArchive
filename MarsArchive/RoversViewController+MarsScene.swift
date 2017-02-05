//
//  RoversViewController+MarsScene.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import SceneKit

// Locations: Spirit, Curiosity, Opportunity
// Lat: Lon
let roverLocations: [Float: Float] = [
    175.4785: -14.5718,
    -4.711008263280026: 137.35747239276338,
    354.4734: -1.9462,
]
extension RoversViewController {
    
    func configureScene() {
        self.scene = SCNScene(named: "sphere.obj")
        
        // Sphere
        let sphereNode = self.scene.rootNode.childNodes[0]
        
        // Camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
        cameraNode.camera?.motionBlurIntensity = 0.2
        
        // Material
        let material = sphereNode.geometry?.firstMaterial
        material?.shininess = 10.0
        material?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        material?.diffuse.contents = UIImage(named: "mars_map.jpg")
        material?.reflective.intensity = 0.0
        
        // Background
        let bg = UIImage(named: "space_environment_big.jpg")
        scene.background.contents = bg
        
        // Lighting
        let env = UIImage(named: "space_environment_big.jpg")
        scene.lightingEnvironment.contents = env
        scene.lightingEnvironment.intensity = 10.0
        
        // set the scene to the view
        self.sceneView.scene = scene
        
        // allows the user to manipulate the camera
        self.sceneView.allowsCameraControl = true
        
        
        self.rotateAction = SCNAction.repeatForever(SCNAction.rotateBy(x: 1, y: 1, z: 1, duration: 10))
        sphereNode.runAction(self.rotateAction)
        
    }

}
