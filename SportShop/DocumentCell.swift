//
//  ProductCell.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Haneke
import Kinvey

class DocumentCell: UITableViewCell {
    var file: File?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func layoutSubviews() {
        nameLabel.text = file?.fileName
        
        
        if let date = file?.metadata?.lastModifiedTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = nil
        }
//        
//        if let src = product?.imageSource {
//            self.loadImage(src)
//        }
    }
//    
//    func loadImage (_ src: String) {
//        let url = URL(string: src)
//        
//        self.productImage.hnk_setImage(from: url)
//        
//        //        DispatchQueue.global().async {
//        //            let data = try? Data(contentsOf: url!)
//        //
//        //            if let _ = data{
//        //                DispatchQueue.main.async {
//        //                    self.productImage?.image = UIImage(data: data!)
//        //                }
//        //            }
//        //        }
//    }
    
    
}
