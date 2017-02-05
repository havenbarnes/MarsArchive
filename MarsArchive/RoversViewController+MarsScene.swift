//
//  RoversViewController+MarsScene.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit
import SceneKit

// Locations: Curiosity, Opportunity, Spirit
// Lat, Lon
let roverLocations: [[Float]] = [
    [180.8, 38.4],
    [354.4734, -1.9462],
    [195.4785, 1.5718],
]

extension RoversViewController {
    
    func configureScene() {
        self.scene = SCNScene(named: "sphere.obj")
        
        // Sphere
        let sphereNode = self.scene.rootNode.childNodes[0]
        
        // Camera
        self.cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        self.scene.rootNode.addChildNode(cameraNode)
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 25)
        cameraNode.camera?.motionBlurIntensity = 0.1
        
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
        scene.lightingEnvironment.intensity = 20.0
        
        // set the scene to the view
        self.sceneView.scene = scene
        
        // allows the user to manipulate the camera
        self.sceneView.allowsCameraControl = true
        
        configureMissionMarkers()
        filterOutGestures()
        configureGestures()
    }
    
    func configureMissionMarkers() {
        
        let sphereRadius: Float = 0.4
        let planetRadius: Float = 5.0
        
        let sphere = SCNSphere(radius: CGFloat(sphereRadius))
        sphere.firstMaterial?.diffuse.contents = UIColor.white

        var index = 0
        
        for coords in roverLocations {
            
            let latitude = Float.pi / 180 * (90 - (coords[0]))
            let longitude = Float.pi / 180 * (0 - (coords[1]))
            
            let wantedX = planetRadius * sin(latitude) * cos(longitude)
            let wantedY = planetRadius * cos(latitude)
            let wantedZ = planetRadius * sin(latitude) * sin(longitude)
            
            let node = SCNNode(geometry: sphere)
            node.position = SCNVector3(x: wantedZ, y: wantedY, z: wantedX)
            self.scene.rootNode.addChildNode(node)
            
            switch index {
            case 0:
                roverNodes[node] = "Curiosity"
            case 1:
                roverNodes[node] = "Opportunity"
            case 2:
                roverNodes[node] = "Spirit"
            default:
                break
            }
        
            index += 1
        }
    }
    
    func filterOutGestures() {
        var gesturesToRemove: [Int] = []
        
        for index in 0..<self.sceneView.gestureRecognizers!.count  {
            let gesture = self.sceneView.gestureRecognizers![index]
            if gesture is UITapGestureRecognizer {
                gesturesToRemove.append(index)
            }
            if gesture is UIPanGestureRecognizer {
                let pan = gesture as! UIPanGestureRecognizer
                pan.maximumNumberOfTouches = 1
            }
        }
        
        for index in gesturesToRemove {
            self.sceneView.gestureRecognizers!.remove(at: index)
        }
    }
    
    func configureGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hitTest))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        
        self.sceneView.gestureRecognizers!.append(tap)
    }
    
    func hitTest(recognizer: UITapGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults[0] 
            let node = result.node
            
            for rover in rovers {
                if rover.name == roverNodes[node] {
                    roverSelected(rover)
                }
            }
            
        }
    }

}
