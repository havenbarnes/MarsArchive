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

enum NasaJSONError: Error {
    case invalidValue
}


class NasaAPI {
    
    var failedAttempts = 0
    
    static let apiKeyParam  = "api_key=7BJC3QBydynBog4ZQ9r2G1XJxpnVkdwwN8tQ6pCB"
    static let apiKeyParam2 = "api_key=Zhw2p1l4z9ZWx4V3BYpIaGj33Vn8esn7fbRABxC9"
    static let apiKeyParam3 = "api_key=MLv1J3WzJFFpmfrse7KOZ3fBjzJpzoAPyTs3FLO0"
    static let apiKeyParam4 = "api_key=MLv1J3WzJFFpmfrse7KOZ3fBjzJpzoAPyTs3FLO0"
    static let apiKeyParam5 = "api_key=6BBAacuqI5nIezsMEuatqFjLIZIU6y21suJZKF0J"
    
    enum Endpoint: String  {
        case rovers = "https://api.nasa.gov/mars-photos/api/v1/rovers"
        case manifest = "https://api.nasa.gov/mars-photos/api/v1/manifests"
    }
    
    enum Options: String {
        case sol = "sol="
        case earthDate = "earth_date="
        case camera = "camera="
    }
    
    func fetchRoversData(completion: @escaping (([Rover]) -> Void)) {
        
        var rovers: [Rover] = []
        
        // First, grab rover summary from /rovers endpoint
        fetch(endpoint: NasaAPI.Endpoint.rovers, roverName: nil, photoRequest: false, options: nil, completion: {
            json in
            
            // Grab manifest data for each rover in rovers array
            guard json["rovers"].array != nil else  {
                completion(rovers)
                StatusBarNotification(message: "API Currently Unavailable", color: UIColor.red, lightStatusBar: true).show()
                return
            }
            for roverJSON in json["rovers"].array! {
                
                self.fetch(endpoint: NasaAPI.Endpoint.manifest, roverName: roverJSON["name"].string!, photoRequest: false, options: nil, completion: {
                    roverManifestJSON in
                    
                    
                    do {
                        try rovers.append(Rover(json: roverManifestJSON["photo_manifest"]))
                    } catch NasaJSONError.invalidValue {
                        self.failedAttempts += 1
                        if self.failedAttempts >= 3 {
                            self.fetchRoversData(completion: completion)
                        } else {
                            StatusBarNotification(message: "NASA Network Error", color: UIColor.red, lightStatusBar: true).show()
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
    
    func fetchPhotos(for rover: Rover, sol: Int?, earthDate: String?, camera: Camera?, completion: @escaping (([Photo]) -> Void)) {
        var photos: [Photo] = []
        var options: [Options: Any] = [:]
        
        if sol != nil {
            options[NasaAPI.Options.sol] = sol!
        } else {
            options[NasaAPI.Options.earthDate] = earthDate!
        }
        
        if camera != nil {
            options[NasaAPI.Options.camera] = camera!.name
        }
        
        fetch(endpoint: NasaAPI.Endpoint.rovers, roverName: rover.name, photoRequest: true, options: options, completion: {
            json in
            
            guard json["photos"].array != nil else {
                completion(photos)
                return
            }
            
            for photoJSON in json["photos"].array! {
                do {
                    try photos.append(Photo(json: photoJSON))
                } catch NasaJSONError.invalidValue {
                    StatusBarNotification(message: "NASA Network Error", color: UIColor.red, lightStatusBar: true).show()
                }
            }
            completion(photos)
        })
    }
    
    func fetch(endpoint: Endpoint, roverName: String?, photoRequest: Bool, options: [Options : Any]?, completion: @escaping ((JSON) throws -> Void)) {
        
        let url = self.url(from: endpoint, roverName: roverName, photoRequest: photoRequest, options: options)
        
        print(url)
        
        Alamofire.request(url)
            .responseJSON { response in
                
                let json = JSON(data: response.data!)
                try? completion(json)
        }
        
    }
    
    func url(from endpoint: Endpoint, roverName: String?, photoRequest: Bool, options: [Options : Any]?) -> URL {
        
        var urlString = endpoint.rawValue
        if roverName != nil {
            urlString += "/" + roverName!
            if photoRequest {
                urlString += "/photos"
            }
        }
        urlString += "?"
        if options != nil {
            for optionType in options!.keys {
                urlString += optionType.rawValue + String(describing: options![optionType]!) + "&"
            }
        }
        
        // Add API Key
        urlString += NasaAPI.apiKeyParam
            
        return URL(string: urlString)!
    }
    
}
