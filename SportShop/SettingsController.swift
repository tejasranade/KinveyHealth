//
//  SettingsController.swift
//  SportShop
//
//  Created by Tejas on 1/31/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey
import FBSDKLoginKit

class SettingsController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = Kinvey.sharedClient.activeUser as? HealthUser {
            email.text = user.email
            firstName.text = user.firstname
            lastName.text = user.lastname
            phoneNumber.text = user.phone
        }
        
        
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func save(_ sender: Any) {
        if let user = Kinvey.sharedClient.activeUser as? HealthUser{
            user.email = email.text
            user.firstname = firstName.text
            user.lastname = lastName.text
            user.phone = phoneNumber.text
            //user.save()
        }
    }
    @IBAction func logout(_ sender: Any) {
        Kinvey.sharedClient.activeUser?.logout()
        self.dismiss(animated:true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("kinveyUserChanged"), object: nil)
        
//        User.login(username: "Guest", password: "kinvey") { user, error in
//            if let _ = user {
//                NotificationCenter.default.post(name: Notification.Name("kinveyUserChanged"), object: nil)
//                self.dismiss(animated:true, completion: nil)
//            }
//        }
    }
}
