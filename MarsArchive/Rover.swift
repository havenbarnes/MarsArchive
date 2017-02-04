//
//  Rover.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/3/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct Rover {
    var name: String
    var status: Bool
    var launchDate: Date
    var landingDate: Date
    var maxDate: Date
    var maxSol: Int
    var photoCount: Int
    var photoData: [[Int: [Camera]]] = []
    
    // Instantiates a Rover object from NASA /manifests endpoint
    init(json: JSON) {
        
        self.name = json["name"].string!
        self.status = json["status"].string! == "active"
        self.launchDate = Utility.date(from: json["launch_date"].string!)
        self.landingDate = Utility.date(from: json["landing_date"].string!)
        self.maxDate = Utility.date(from: json["max_date"].string!)
        self.maxSol = json["max_sol"].int!
        self.photoCount = json["total_photos"].int!
        self.photoData = self.analyzePhotoCollection(jsonArray: json["photos"].array!)

    }
    
    // Parses the photo manifest and returns a dictionary (sol: cameras)
    func analyzePhotoCollection(jsonArray: [JSON]) -> [[Int: [Camera]]] {
        var photoCollection: [[Int: [Camera]]] = []
        
        for json in jsonArray {
            var cameras: [Camera] = []
            for cameraJSON in json["cameras"].array! {
                cameras.append(Camera(name: cameraJSON.string!))
            }
            
            let sol = json["sol"].int!
            photoCollection.append([sol: cameras])
        }
        
        return photoCollection
    }
}

