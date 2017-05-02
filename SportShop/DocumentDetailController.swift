//
//  DocumentDetailController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/1/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import UIKit
import Foundation

class DocumentDetailController : UIViewController {
    var document:File?
    @IBOutlet weak var documentView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = document?.fileName
        
        let fileStore = FileStore.getInstance()
        let file = File()
        file.fileId = document?.fileId
        fileStore.download(file) { (file, url: URL?, error) in
            if let file = file, let url = url, let downloadUrl = file.downloadURL {
                //success
                print("URL: \(url)")
                print("download URL: \(downloadUrl)")
                self.documentView.loadRequest(URLRequest(url: downloadUrl))
//                /self.documentView.load(NSData(contentsOf: url), mimeType: "application/pdf", textEncodingName: .textEnc)
            } else {
                //fail
                print("Error \(String(describing: error))")
            }
        }
        
    }
}
