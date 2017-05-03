//
//  HealthTeamController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/2/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//
import Foundation
import UIKit
import Kinvey

class HealthTeamController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var doctors: [Doctor]?
    @IBOutlet weak var tableView:UITableView!
    
    lazy var doctorStore:DataStore<Doctor> = {
        return DataStore<Doctor>.collection(.cache)
    }()
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let query = Query(format: "category == %@", "shoes")
        
        //doctorStore.find (query) { (items, error) in
        doctorStore.find () { (items, error) in
            if let items = items {
                self.doctors = items
                self.tableView.reloadData()
            } else {
                print ("\(String(describing: error))")
            }
        }
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorCell", for: indexPath) as! DoctorCell
        
        cell.doctor = doctors?[indexPath.row]
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? doctorDetailController,
//            let indexPath = self.tableView.indexPathForSelectedRow {
//            destination.product = doctors?[indexPath.row]
//        }
    }
}
