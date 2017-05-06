//
//  DoctorDetailController.swift
//  SportShop
//
//  Created by Tejas on 1/30/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Material
import Haneke

class DoctorDetailsController: UIViewController {
    var doctor:Doctor?
    
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var addr1: UILabel!
    @IBOutlet weak var addr2: UILabel!
    @IBOutlet weak var email: UILabel!
    //@IBOutlet weak var price: UILabel!
    @IBOutlet weak var doctorImage: UIImageView!
    
    //    @IBAction func onAddToCart(_ sender: Any){
    //        Cart.shared.addToCart(CartItem((doctor?.entityId)!, quantity: 1))
    //        showConfirmation()
    //    }
    
    func showConfirmation() {
        let alert = UIAlertController(title: "Done!", message: "Doctor has been added to your cart", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = doctor?.name
        
        self.nameText.text = doctor?.name
        self.companyName.text = doctor?.companyName
        self.titleText.text = doctor?.title
        self.addr1.text = doctor?.street
        self.addr2.text = doctor?.addr2
        self.email.text = doctor?.email
        
        if let src = doctor?.imageSource {
            let url = URL(string: src)
            self.doctorImage.hnk_setImage(from: url)
            
            //            DispatchQueue.global().async {
            //                let data = try? Data(contentsOf: url!)
            //
            //                if let _ = data{
            //                    DispatchQueue.main.async {
            //                        self.doctorImage?.image = UIImage(data: data!)
            //                    }
            //                }
            //                
            //            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ScheduleApptController {
            destination.doctor = self.doctor
        }
    }

}
