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
import WebKit

class DocumentDetailController : UIViewController {
    
    var document: File!
    
    @IBOutlet var documentView: WKWebView!
    
    override func loadView() {
        documentView = WKWebView()
        view = documentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = document.fileName
        
        let fileStore = FileStore.getInstance()
        fileStore.download(document) { (file, url: URL?, error) in
            if let file = file,
                let url = url,
                let downloadUrl = file.downloadURL
            {
                //success
                print("URL: \(url)")
                print("download URL: \(downloadUrl)")
                if let data = try? Data(contentsOf: url),
                    let mimeType = file.mimeType
                {
                    self.documentView.load(data, mimeType: mimeType, characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
                } else {
                    self.documentView.loadFileURL(url, allowingReadAccessTo: url.deletingLastPathComponent())
                }
            } else {
                //fail
                print("Error \(String(describing: error))")
            }
        }
        
    }
}
