//
//  SubmitHealthConcernController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/3/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey


class SubmitHealthConcernController:UIViewController, UIImagePickerControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var descText: UITextField!
    
    @IBOutlet weak var discomfort: UISlider!
    
    lazy var healthConcernStore:DataStore<HealthConcern> = {
        return DataStore<HealthConcern>.collection(.cache)
    }()

    
    @IBAction func useCamera(_ sender: AnyObject) {
        
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true,
                         completion: nil)
    }

    @IBAction func submit(_ sender: AnyObject) {
        let concern = HealthConcern()
        concern.name = descText.text
        concern.discomfort = String(discomfort.value)
        
        healthConcernStore.save(concern) { item, error in
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}
