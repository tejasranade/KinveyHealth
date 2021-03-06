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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fileStore.find () { (items, error) in
            if let items = items {
                var result = [File]()
                for item in items{
                    if (item.fileName?.hasSuffix(".pdf"))! {
                        result.append(item)
                    }
                }
                self.files = result
                self.tableView.reloadData()
            } else {
                print ("\(String(describing: error))")
            }
        }
        
        self.tableView.rowHeight = 64
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
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
            let indexPath = self.tableView.indexPathForSelectedRow,
            let files = files
        {
            destination.document = files[indexPath.row]
        }
    }
}

