//
//  Extension.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func instantiate(_ storyboard: String, identifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
        
    }
    
}
