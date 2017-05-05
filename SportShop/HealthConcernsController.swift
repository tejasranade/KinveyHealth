//
//  HealthConcernsController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/2/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//
import Foundation
import UIKit
import Kinvey

class HealthConcernsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var concerns: [HealthConcern]?
    @IBOutlet weak var tableView:UITableView!
    
    lazy var healthConcernStore:DataStore<HealthConcern> = {
        return DataStore<HealthConcern>.collection(.cache)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let query = Query(format: "category == %@", "shoes")
        
        //healthConcernStore.find (query) { (items, error) in
        healthConcernStore.find () { (items, error) in
            if let items = items {
                self.concerns = items
                self.tableView.reloadData()
            } else {
                print ("\(String(describing: error))")
            }
        }
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concerns?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HealthConcernCell", for: indexPath) as! HealthConcernCell
        
        cell.healthConcern = concerns?[indexPath.row]
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if let destination = segue.destination as? doctorDetailController,
        //            let indexPath = self.tableView.indexPathForSelectedRow {
        //            destination.product = doctors?[indexPath.row]
        //        }
    }
}
