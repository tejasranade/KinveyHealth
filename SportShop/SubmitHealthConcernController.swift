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

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var prevTreated: UISwitch!
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var discomfort: UISlider!
    
    lazy var fileStore: FileStore = {
        return FileStore.getInstance()
    }()
    
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
        guard let image = imageView.image else {
            let alert = UIAlertController(title: "Missing Data", message: "Please take a picture of your concern", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true)
            }))
            present(alert, animated: true)
            return
        }
        
        let file = File()
        file.publicAccessible = true
        fileStore.upload(file, image: image) { (result: Result<File, Swift.Error>) in
            switch result {
            case .success(let file):
                let concern = HealthConcern()
                concern.name = self.descriptionText.text
                concern.discomfort = String(Int(self.discomfort.value))
                //concern.prevTreated = prevTreated.value
                if let user = Kinvey.sharedClient.activeUser as? HealthUser {
                    concern.pcpEmail = user.pcp
                }
                concern.imageSource = file.download
                
                self.healthConcernStore.save(concern) { item, error in
                    self.dismiss(animated: true, completion: nil)
                }
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
        }
    }

    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        imageButton.isHidden = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

}
