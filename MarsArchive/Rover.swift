//
//  Rover.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/3/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation

enum RoverType: String {
    case opportunity = "opportunity"
    case curiosity = "curiosity"
    case spirit = "spirit"
}

struct Rover {
    var type: RoverType
    var status: Bool
    var maxSol: Int
    var launchDate: Date
    var landingDate: Date
    var maxDate: Date
    var photoCount: Int
    var photoDates: [Int]
}

