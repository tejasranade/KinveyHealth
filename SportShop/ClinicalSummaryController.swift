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
import PromiseKit

class ClinicalSummaryController: UITableViewController {
    
    lazy var prescriptionDataStore = DataStore<Prescription>.collection(.cache)
    lazy var immunizationDataStore = DataStore<Immunization>.collection(.cache)
    
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
        refreshControl!.beginRefreshing()
        refresh(refreshControl!)
    }
    
    @IBAction func refresh(_ sender: UIRefreshControl) {
        when(resolved: [loadPrescriptions(), loadImmunizations()]).always {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                sender.endRefreshing()
            }
        }
    }
    
    func loadPrescriptions() -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            prescriptionDataStore.find { (result: Kinvey.Result<[Prescription], Swift.Error>) in
                switch result {
                case .success(let prescriptions):
                    self.prescriptions = prescriptions
                case .failure(_):
                    break
                }
                fulfill()
            }
        }
    }
    
    func loadImmunizations() -> Promise<Void> {
        return Promise<Void> { fulfill, reject in
            immunizationDataStore.find { (result: Kinvey.Result<[Immunization], Swift.Error>) in
                switch result {
                case .success(let immunizations):
                    self.immunizations = immunizations
                case .failure(_):
                    break
                }
                fulfill()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .prescription:
            return max(1, prescriptions.count)
        case .immunization:
            return max(1, immunizations.count)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 64 + 16
        default:
            return 64
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch Section(rawValue: section)! {
        case .prescription:
            let header = UIStoryboard.viewController(identifier: "ClinicalSummaryHeaderViewController") as! ClinicalSummaryHeaderViewController
            let view = header.view
            header.label.text = "PRESCRIPTIONS"
            return view
        case .immunization:
            let header = UIStoryboard.viewController(identifier: "ClinicalSummaryHeaderViewController") as! ClinicalSummaryHeaderViewController
            let view = header.view
            header.label.text = "IMMUNIZATION"
            return view
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .prescription:
            if prescriptions.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell") as! ClinicalSummaryEmptyTableViewCell
                cell.label.text = "No Prescriptions"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Prescripton Cell") as! ClinicalSummaryTableViewCell
                let prescription = prescriptions[indexPath.row]
                cell.leftLabel.text = prescription.name
                cell.rightLabel.text = "\(prescription.dose ?? 0) \(prescription.doseUnit ?? "")\n\(prescription.freqPeriod ?? "") \(prescription.freqUnit ?? "")"
                return cell
            }
        case .immunization:
            if immunizations.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Empty Cell") as! ClinicalSummaryEmptyTableViewCell
                cell.label.text = "No Immunizations"
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Immunization Cell") as! ClinicalSummaryTableViewCell
                let immunization = immunizations[indexPath.row]
                cell.leftLabel.text = immunization.name
                cell.rightLabel.text = immunization.lastAdministered
                return cell
            }
        }
    }

}

class ClinicalSummaryHeaderViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
}

class ClinicalSummaryEmptyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
}

class ClinicalSummaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
}
