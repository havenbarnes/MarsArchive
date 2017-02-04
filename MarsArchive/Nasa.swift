//
//  Nasa.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/3/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation

class NasaAPI {
    
    static let apiKeyParam = "&api_key=7BJC3QBydynBog4ZQ9r2G1XJxpnVkdwwN8tQ6pCB"

    enum Endpoint  {
        enum manifest: String {
            case curiosity = "https://api.nasa.gov/mars-photos/api/v1/manifests/curiosity"
            case opportunity = "https://api.nasa.gov/mars-photos/api/v1/manifests/opportunity"
            case spirit = "https://api.nasa.gov/mars-photos/api/v1/manifests/spirit"
        }
        enum curiosity: String {
            case photos = "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?"
        }
    }
    
    enum Options: String {
        case sol = "sol="
        case camera = "&camera="
    }
    
    func url(from endpoint: Endpoint, options: [Options]) -> URL {
        
        let urlString = ""
        
        return URL(string: urlString)!
    }
    
    func fetch(for rover: RoverType, sol: Int, camera: Camera) -> [Photo] {
        
        let photos: [Photo] = []
    
        
        return photos
    }
    
}
