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

class HealthConcernCell: UITableViewCell {
    var healthConcern: HealthConcern?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var discomfortLevel: UILabel!
    @IBOutlet weak var healthConcernImage: UIImageView!
    
    override func layoutSubviews() {
        name.text = healthConcern?.name
        discomfortLevel.text = healthConcern?.discomfort
        
        healthConcernImage.image = nil
        if let src = healthConcern?.imageSource {
            self.loadImage(src)
        }
    }
    
    func loadImage (_ src: String) {
        let url = URL(string: src)
        
        self.healthConcernImage.hnk_setImage(from: url)
        
    }
}
