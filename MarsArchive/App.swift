//
//  App.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import UIKit

class App {
    
    static let shared = App()
    var rovers: [Rover] = []
    var window: UIWindow!
    var api = NasaAPI()

}
