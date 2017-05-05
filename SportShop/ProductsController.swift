//
//  ProductsController.swift
//  SportShop
//
//  Created by Tejas on 1/29/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Foundation
import UIKit
import Kinvey

class ProductsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var products: [Product]?
    @IBOutlet weak var tableView:UITableView!
    
    lazy var productStore:DataStore<Product> = {
        return DataStore<Product>.collection(.cache)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let query = Query(format: "category == %@", "shoes")

        //productStore.find (query) { (items, error) in
        productStore.find () { (items, error) in
            if let items = items {
                self.products = items
                self.tableView.reloadData()
            } else {
                print ("\(String(describing: error))")
            }
        }
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableViewAutomaticDimension

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        
        cell.product = products?[indexPath.row]
        return cell
 
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ProductDetailController,
            let indexPath = self.tableView.indexPathForSelectedRow {
                destination.product = products?[indexPath.row]
        }
    }
}
