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
    var product: Product?
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var discipline: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var doctorImage: UIImageView!
    
    override func layoutSubviews() {
        name.text = product?.name
        discipline.text = product?.priceString
        address.text = product?.shortDesc
        //productImage.image = UIImage
        
        if let src = product?.imageSource {
            self.loadImage(src)
        }
    }
    
    func loadImage (_ src: String) {
        let url = URL(string: src)
        
        self.doctorImage.hnk_setImage(from: url)

    }
}
