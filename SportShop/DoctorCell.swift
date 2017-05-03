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

class DoctorCell: UITableViewCell {
    var doctor: Doctor?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var discipline: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var doctorImage: UIImageView!
    
    override func layoutSubviews() {
        name.text = doctor?.name
        discipline.text = doctor?.companyName
        address.text = doctor?.aboutme
        
        if let src = doctor?.imageSource {
            self.loadImage(src)
        }
    }
    
    func loadImage (_ src: String) {
        let url = URL(string: src)
        
        self.doctorImage.hnk_setImage(from: url)

    }
}
