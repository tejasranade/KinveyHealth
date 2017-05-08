//
//  ApptController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/4/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class ApptController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appointments: [Appointment]?
    @IBOutlet weak var tableView:UITableView!
    
    lazy var apptStore:DataStore<Appointment> = {
        return DataStore<Appointment>.collection(.cache)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let query = Query(format: "category == %@", "shoes")
        
        //apptStore.find (query) { (items, error) in
        apptStore.find () { (items, error) in
            if let items = items {
                self.appointments = items
                self.tableView.reloadData()
            } else {
                print ("\(String(describing: error))")
            }
        }
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApptCell", for: indexPath) as! AppointmentCell
        
        cell.appointment = appointments?[indexPath.row]
        return cell
        
    }
}
