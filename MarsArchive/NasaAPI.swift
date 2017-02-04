//
//  Nasa.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/3/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NasaAPI {
    
    var failedAttempts = 0
    
    static let apiKeyParam = "api_key=7BJC3QBydynBog4ZQ9r2G1XJxpnVkdwwN8tQ6pCB"
    
    enum Endpoint: String  {
        case rovers = "https://api.nasa.gov/mars-photos/api/v1/rovers"
        case manifest = "https://api.nasa.gov/mars-photos/api/v1/manifests"
    }
    
    enum Options: String {
        case sol = "sol="
        case camera = "camera="
    }
    
    func fetchRoversData(completion: @escaping (([Rover]) -> Void)) {
        
        var rovers: [Rover] = []
        
        // First, grab rover summary from /rovers endpoint
        self.fetch(endpoint: NasaAPI.Endpoint.rovers, roverName: nil, photoRequest: false, options: nil, completion: {
            json in
            
            // Grab manifest data for each rover in rovers array
            for roverJSON in json["rovers"].array! {
                
                self.fetch(endpoint: NasaAPI.Endpoint.manifest, roverName: roverJSON["name"].string!, photoRequest: false, options: nil, completion: {
                    roverManifestJSON in
                    
                    
                    do {
                        try rovers.append(Rover(json: roverManifestJSON["photo_manifest"]))
                    } catch RoverJSONError.invalidValue {
                        self.failedAttempts += 1
                        if self.failedAttempts >= 3 {
                            self.fetchRoversData(completion: completion)
                        } else {
                            StatusBarNotification(message: "NASA Network Error", color: UIColor.red).show()
                        }
                        
                    }
                    
                    
                    
                    // If we've fetched the last rover manifest, return data
                    if rovers.count == json["rovers"].array!.count {
                        completion(rovers)
                    }
                })
            }
        })
        
    }
    
    func fetchPhotos(for rover: Rover, sol: Int, camera: Camera?) -> [Photo] {
        let photos: [Photo] = []
        
        
        return photos
    }
    func fetch(endpoint: Endpoint, roverName: String?, photoRequest: Bool, options: [Options]?, completion: @escaping ((JSON) throws -> Void)) {
        
        let url = self.url(from: endpoint, roverName: roverName, photoRequest: photoRequest, options: options)
        
        Alamofire.request(url)
            .responseJSON { response in
                
                let json = JSON(data: response.data!)
                try? completion(json)
        }
        
    }
    
    func url(from endpoint: Endpoint, roverName: String?, photoRequest: Bool, options: [Options]?) -> URL {
        
        var urlString = endpoint.rawValue
        if roverName != nil {
            urlString += "/" + roverName!
            if photoRequest {
                urlString += "/photos"
            }
        }
        urlString += "?"
        if options != nil {
            for option in options! {
                urlString += option.rawValue + "&"
            }
        }
        
        // Add API Key
        urlString += NasaAPI.apiKeyParam
        
        print("Endpoint: " + urlString + "\n\n")
        
        return URL(string: urlString)!
    }
    
}
