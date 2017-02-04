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
    
    static let apiKeyParam = "api_key=7BJC3QBydynBog4ZQ9r2G1XJxpnVkdwwN8tQ6pCB"

    enum Endpoint: String  {
        case rovers = "https://api.nasa.gov/mars-photos/api/v1/rovers"
        case manifest = "https://api.nasa.gov/mars-photos/api/v1/manifests"
    }
    
    enum Options: String {
        case sol = "sol="
        case camera = "camera="
    }
    
    func fetchRoverData() -> [Rover] {
        
        var rovers: [Rover] = []
        
        self.fetch(endpoint: NasaAPI.Endpoint.rovers, roverName: nil, photoRequest: false, options: nil, completion: {
            json in
            
            for roverJSON in json["rovers"].array! {
                
                // Grab Rover Manifest
                self.fetch(endpoint: NasaAPI.Endpoint.manifest, roverName: roverJSON["name"].string!, photoRequest: false, options: nil, completion: {
                    roverManifestJSON in
                    
                    rovers.append(Rover(json: roverManifestJSON))
                })
            }
        })
        
        return rovers
    }
     
    func fetchPhotos(for rover: Rover, sol: Int, camera: Camera?) -> [Photo] {
        let photos: [Photo] = []
    
        
        return photos
    }
    
    func fetch(endpoint: Endpoint, roverName: String?, photoRequest: Bool, options: [Options]?, completion: @escaping ((JSON) -> Void)) {
        
        let url = self.url(from: endpoint, roverName: roverName, photoRequest: photoRequest, options: options)
        
        Alamofire.request(url)
            .responseJSON { response in
                
                let json = JSON(data: response.data!)
                completion(json)
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
        
        print("Accessing Endpoint - " + urlString)
        
        return URL(string: urlString)!
    }
    
}
