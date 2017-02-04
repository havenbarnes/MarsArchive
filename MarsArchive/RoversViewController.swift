//
//  ViewController.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/3/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import UIKit

class RoversViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    var rovers: [Rover]!

    let api = App.shared.api
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController!.setNavigationBarHidden(true, animated: false)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(fetchRovers), for: .valueChanged)
        tableView.addSubview(self.refreshControl)
        
    }
    
    func fetchRovers() {
        self.api.fetchRoversData(completion: {
            rovers in
            
            self.rovers = rovers
            self.tableView.reloadSections(NSIndexSet(index: 0) as IndexSet, with: .fade)
            self.refreshControl.endRefreshing()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rovers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoverCell", for: indexPath) as! RoverCell
        let rover = self.rovers[indexPath.row]
        cell.nameLabel.text = rover.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        roverSelected(rovers[indexPath.row])
    }
    
    func roverSelected(_ rover: Rover) {
        print("Selected: " + rover.name)
        
        let galleryViewController = instantiate("Main", identifier: "GalleryViewController") as! GalleryViewController
        galleryViewController.rover = rover
        
        self.navigationController!.show(galleryViewController, sender: nil)
    }
}

class RoverCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
}

