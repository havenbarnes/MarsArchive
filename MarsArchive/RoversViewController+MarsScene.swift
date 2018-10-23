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
        material?.lightingModel = SCNMaterial.LightingModel.physicallyBased
        material?.diffuse.contents = UIImage(named: "mars_map.jpg")
        material?.reflective.intensity = 0.0
        
        // Background
        let bg = UIImage(named: "space.jpg")
        scene.background.contents = bg
        
        // Lighting
        let env = UIImage(named: "space.jpg")
        scene.lightingEnvironment.contents = env
        scene.lightingEnvironment.intensity = 700.0
        
        // set the scene to the view
        self.sceneView.scene = scene
        
        // allows the user to manipulate the camera
        self.sceneView.allowsCameraControl = true
        
        configureMissionMarkers()
        configureRoverLabels()
        filterOutGestures()
        configureGestures()
        
    }
    
    func configureMissionMarkers() {
        
        let sphereRadius: Float = 0.8
        let planetRadius: Float = 4.7
        
        var index = 0
        
        for coords in roverLocations {
            
            let sphere = SCNSphere(radius: CGFloat(sphereRadius))
            
            let latitude = Float.pi / 180 * (90 - (coords[0]))
            let longitude = Float.pi / 180 * (0 - (coords[1]))
            
            let wantedZ = planetRadius * sin(latitude) * cos(longitude)
            let wantedY = planetRadius * cos(latitude)
            let wantedX = planetRadius * sin(latitude) * sin(longitude)
            
            let node = SCNNode(geometry: sphere)
            node.position = SCNVector3(x: wantedX, y: wantedY, z: wantedZ)
            self.scene.rootNode.addChildNode(node)
            
            switch index {
            case 0:
                roverNodes[node] = "Curiosity"
                sphere.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.6)
                break
            case 1:
                roverNodes[node] = "Opportunity"
                sphere.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.6)
                break
            case 2:
                roverNodes[node] = "Spirit"
                sphere.firstMaterial?.diffuse.contents = UIColor.red.lighter(by: 40)!.withAlphaComponent(0.6)
                break
            default:
                break
            }
            
            index += 1
        }
    }
    
    func configureRoverLabels() {
        var index = 0
        
        for coords in roverLocations {
            
            let planetRadius: Float = 6.0
            
            var textString = ""
            switch index {
            case 0:
                textString = "Curiosity"
            case 1:
                textString = "Opportunity"
            case 2:
                textString = "Spirit"
            default:
                break
            }
            
            let text = SCNText(string: textString, extrusionDepth: 0)
            text.firstMaterial?.diffuse.contents = UIColor.white
            text.font = UIFont(name: "Michroma", size: 0.4)
            text.alignmentMode = kCAAlignmentRight
            
            
            let latitude = Float.pi / 180 * (90 - (coords[0]))
            let longitude = Float.pi / 180 * (0 - (coords[1]))
            
            let wantedZ = planetRadius * sin(latitude) * cos(longitude)
            let wantedY = planetRadius * cos(latitude)
            let wantedX = planetRadius * sin(latitude) * sin(longitude)
            
            let node = SCNNode(geometry: text)
            let billboardConstraint = SCNBillboardConstraint()
            billboardConstraint.influenceFactor = 0.1
            node.constraints = [SCNBillboardConstraint()]
            node.position = SCNVector3(x: wantedX - 1.0, y: wantedY, z: wantedZ)
            
            
            switch index {
            case 0:
                roverLabelNodes[node] = "Curiosity"
                node.position = SCNVector3(x: wantedX - 1.0, y: wantedY + 0.2, z: wantedZ)
                break
            case 1:
                roverLabelNodes[node] = "Opportunity"
                node.position = SCNVector3(x: wantedX - 1.4, y: wantedY, z: wantedZ)
                break
            case 2:
                roverLabelNodes[node] = "Spirit"
                node.position = SCNVector3(x: wantedX - 1.0, y: wantedY + 0.2, z: wantedZ)
                break
            default:
                break
            }
            
            self.scene.rootNode.addChildNode(node)
            
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
            
            for rover in self.rovers {
                if rover.name == self.roverNodes[node] {
                    self.roverSelected(rover)
                }
            }
        }
    }
    
}
