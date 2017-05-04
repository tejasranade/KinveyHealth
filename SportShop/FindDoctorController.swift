//
//  FindDoctorController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/2/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class FindDoctorTableViewController: UITableViewController {
    
    lazy var doctorStore:DataStore<Doctor> = {
        return DataStore<Doctor>.collection(.network)
    }()

    @IBOutlet weak var specialtyTextField: UITextField!
    @IBOutlet weak var specialtyLabel: UILabel!
    let specialtyPickerView = UIPickerView()
    let specialtyOptions = ["Family Medicine", "Lungs", "Cardiology", "Neurology"]
    
    @IBOutlet weak var languageTextField: UITextField!
    @IBOutlet weak var languageLabel: UILabel!
    let languagePickerView = UIPickerView()
    let languageOptions = ["No Preference", "English", "Spanish", "Chinese", "Portuguese"]
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var genderLabel: UILabel!
    let genderPickerView = UIPickerView()
    let genderOptions = ["No Preference", "Male", "Female"]
    
    @IBOutlet weak var acceptingNewPatientsSwitch: UISwitch!
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        specialtyPickerView.delegate = self
        specialtyTextField.inputView = specialtyPickerView
        
        languagePickerView.delegate = self
        languageTextField.inputView = languagePickerView
        
        genderPickerView.delegate = self
        genderTextField.inputView = genderPickerView
    }
    
    @IBAction func submit(_ sender: AnyObject) {
        let query = Query(format: "PostalCode == %@", locationTextField.text ?? "40514")
        
        doctorStore.find(query) { doctors, error in
            if let _ = error {
            
            } else {
                let destinationVC = FindDoctorMapController()
                destinationVC.doctors = doctors!
                
                // Let's assume that the segue name is called playerSegue
                // This will perform the segue and pre-load the variable for you to use
                self.performSegue(withIdentifier: "findDoctors", sender: self)

            }
            
        }

        
    }
}

extension FindDoctorTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case specialtyPickerView:
            return specialtyOptions.count
        case languagePickerView:
            return languageOptions.count
        case genderPickerView:
            return genderOptions.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case specialtyPickerView:
            return specialtyOptions[row]
        case languagePickerView:
            return languageOptions[row]
        case genderPickerView:
            return genderOptions[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case specialtyPickerView:
            specialtyLabel.text = specialtyOptions[row]
            specialtyTextField.resignFirstResponder()
        case languagePickerView:
            languageLabel.text = languageOptions[row]
            languageTextField.resignFirstResponder()
        case genderPickerView:
            genderLabel.text = genderOptions[row]
            genderTextField.resignFirstResponder()
        default:
            break
        }
    }
    
}
