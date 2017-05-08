//
//  DoctorCell.swift
//  KinveyHealth
//
//  Created by Tejas on 5/2/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class AppointmentCell: UITableViewCell {
    var appointment: Appointment?
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var doctor: UILabel!
    @IBOutlet weak var apptDate: UILabel!
    @IBOutlet weak var apptTime: UILabel!
    
    override func layoutSubviews() {
        title.text = appointment?.title
        doctor.text = appointment?.doctor
        
        if let date = appointment?.apptDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            apptDate.text = dateFormatter.string(from: date)
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            apptTime.text = timeFormatter.string(from: date)
            
        }

    }
}
