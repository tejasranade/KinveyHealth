//
//  AccountViewController.swift
//  SportShop
//
//  Created by Tejas on 1/25/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class AccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = Kinvey.sharedClient.activeUser {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func login(_ sender: Any) {
        if let _ = userName.text, let _ = password.text {

            User.login(username: userName.text!, password: password.text!) { user, error in
                if let _ = user {
                    NotificationCenter.default.post(name: Notification.Name("kinveyUserChanged"), object: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        else {
            print ("input validation error")
        }
        
    }
}
