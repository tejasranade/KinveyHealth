//
//  ClinicalSummaryController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/5/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit

class ClinicalSummaryController: UITableViewController {
    
    var prescriptions: []
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return
        }
    }

}
