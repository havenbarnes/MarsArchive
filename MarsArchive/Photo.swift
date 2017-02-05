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
    
    init(json: JSON) throws {
        guard json.null == nil else {
            print("Error: Null JSON Value Found")
            throw NasaJSONError.invalidValue
        }
        self.url = URL(string: json["img_src"].string!)!
        self.earthDate = Utility.date(from: json["earth_date"].string!)
    }
}
