//
//  DocumentsController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/1/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Foundation
import Kinvey

class DocumentsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var files: [File]?
    @IBOutlet weak var tableView:UITableView!
    
    lazy var fileStore:FileStore = {
        return FileStore.getInstance()
    }()
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let query = Query(format: "category == %@", "shoes")
        //let query = Query(format: "healthconcern == false")
        //fileStore.find (query) { (items, error) in
        fileStore.find () { (items, error) in
            if let items = items {
                self.files = items
                self.tableView.reloadData()
            } else {
                print ("\(String(describing: error))")
            }
        }
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentCell
        
        cell.file = files?[indexPath.row]
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentDetailController,
            let indexPath = self.tableView.indexPathForSelectedRow {
            destination.document = files?[indexPath.row]
        }
    }
}

