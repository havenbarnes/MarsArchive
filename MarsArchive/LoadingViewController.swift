//
//  LoadingViewController.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingLabel.alpha = 0
        self.activityIndicator.alpha = 0

        App.shared.api.fetchRoversData(completion: {
            rovers in
            
            let roversViewControllerNav = self.instantiate("Main", identifier: "RoversViewControllerNav") as! UINavigationController
            let roversViewController = roversViewControllerNav.viewControllers.first! as! RoversViewController
            roversViewController.rovers = rovers
            
            self.present(roversViewControllerNav, animated: true, completion: nil)
            
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.7, delay: 0.2, options: .curveLinear, animations: {
            self.loadingLabel.alpha = 1
            self.activityIndicator.alpha = 1
        }, completion: nil)
    }

}
