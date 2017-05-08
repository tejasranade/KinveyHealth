//
//  ScheduleApptController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/6/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class ScheduleApptController: UIViewController {
    var doctor:Doctor?
    @IBOutlet weak var apptDatePicker: UIDatePicker!
    
    @IBOutlet weak var descText: UITextField!
    
    lazy var apptStore:DataStore<Appointment> = {
        return DataStore<Appointment>.collection(.network)
    }()

    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func confirmAppt(_ sender: Any) {
        
        let appt = Appointment()
        appt.title = descText.text
        appt.apptDate = apptDatePicker.date
        appt.doctor = doctor?.name
        appt.doctorId = doctor?.entityId
    
        if let user = Kinvey.sharedClient.activeUser as? HealthUser {
            appt.patientId = user.sfId
        }
        apptStore.save(appt) {savedAppt, error in
            self.showConfirmation()
        }
    }
    
    func showConfirmation() {
        let alert = UIAlertController(title: "Done!", message: "An appointment has been requested.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: { 
                self.dismiss(animated: true)
            })
        }
    }

}
