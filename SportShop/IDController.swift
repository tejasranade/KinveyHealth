//
//  IDController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/1/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class IDController: UIViewController {

    @IBOutlet weak var subscriberName: UILabel!
    @IBOutlet weak var subscriberNo: UILabel!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupNo: UILabel!
    @IBOutlet weak var planName: UILabel!
    @IBOutlet weak var issueDate: UILabel!
    @IBOutlet weak var officeCopay: UILabel!
    @IBOutlet weak var prevCopay: UILabel!
    
    lazy var idStore:DataStore<IDCard> = {
        return DataStore<IDCard>.collection(.cache)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        idStore.find() { (idcards, error) in
            if let cards = idcards,
                cards.count > 0 {
                
                self.refreshView(card:cards[0])
            }
        }
        
    }
    
    func refreshView(card: IDCard){
        //subscriberName.text = card.subscriberName
        subscriberName.text = Kinvey.sharedClient.activeUser?.username
        subscriberNo.text = card.subscriberNo
        groupName.text = card.groupName
        groupNo.text = card.groupNo
        planName.text = card.plan
        issueDate.text = card.issueDate
        if let offCopay = card.officeCopay {
            officeCopay.text = "$\(offCopay)"
        }

        if let specCopay = card.specialistCopay {
            prevCopay.text = "$\(specCopay)"
        }
    }
}
