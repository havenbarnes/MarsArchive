//
//  Photo.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/3/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Photo {
    var url: URL
    var earthDate: Date
    var sol: Int
    var camera: String
    var rover: String
    
    init(json: JSON) throws {
        guard json.null == nil else {
            print("Error: Null JSON Value Found")
            throw NasaJSONError.invalidValue
        }
        self.url = URL(string: json["img_src"].string!)!
        self.earthDate = Utility.date(from: json["earth_date"].string!)
        self.sol = json["sol"].int!
        self.camera = json["camera"]["full_name"].string!
        self.rover = json["rover"]["name"].string!
    }
    
    func descriptionString() -> String {
        if UserDefaults.standard.bool(forKey: "datePref") {
            return "Taken by \(self.rover)'s \(self.camera) on \(Utility.shortString(from: earthDate))"
        } else {
            return "Taken by \(self.rover)'s \(self.camera) on Sol \(self.sol)"
        }
        
    }
}
