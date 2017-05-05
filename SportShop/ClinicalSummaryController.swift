//
//  ClinicalSummaryController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/5/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class ClinicalSummaryController: UITableViewController {
    
    lazy var prescriptionDataStore = DataStore<Prescription>.collection()
    lazy var immunizationDataStore = DataStore<Immunization>.collection()
    
    enum Section: Int {
        case prescription = 0
        case immunization = 1
    }
    
    var prescriptions = [Prescription]() {
        didSet {
            tableView.reloadSections([Section.prescription.rawValue], with: .automatic)
        }
    }
    
    var immunizations = [Immunization]() {
        didSet {
            tableView.reloadSections([Section.immunization.rawValue], with: .automatic)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    func refresh() {
        refresh(refreshControl!)
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        loadPrescriptions()
        loadImmunizations()
    }
    
    func loadPrescriptions() {
        prescriptionDataStore.find { (result: Result<[Prescription], Swift.Error>) in
            switch result {
            case .success(let prescriptions):
                self.prescriptions = prescriptions
            case .failure(_):
                break
            }
        }
    }
    
    func loadImmunizations() {
        immunizationDataStore.find { (result: Result<[Immunization], Swift.Error>) in
            switch result {
            case .success(let immunizations):
                self.immunizations = immunizations
            case .failure(_):
                break
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.prescription.rawValue:
            return prescriptions.count
        case Section.immunization.rawValue:
            return immunizations.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case Section.prescription.rawValue:
            let vc = UIStoryboard.viewController(identifier: "ClinicalSummaryHeaderViewController") as! ClinicalSummaryHeaderViewController
            vc.label.text = "PRESCRIPTIONS"
            return vc.view
        case Section.immunization.rawValue:
            let vc = UIStoryboard.viewController(identifier: "ClinicalSummaryHeaderViewController") as! ClinicalSummaryHeaderViewController
            vc.label.text = "IMMUNIZATION"
            return vc.view
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Immunization Cell")!
        return cell
    }

}

class ClinicalSummaryHeaderViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
}
