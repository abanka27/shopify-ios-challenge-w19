//
//  TagsListTableViewController.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-18.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import UIKit

class TagsListTableViewController: UITableViewController {
    
    // MARK: - Properties
    private var tagsList = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Product Tags"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.viewControllers.first?.title = nil
        self.title = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clearsSelectionOnViewWillAppear = true
        ShopifyClient.sharedInstance.getDataFromShopify() { products in
            self.tagsList = Array(products.keys)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TagCell"
         let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) 
        cell.textLabel?.text = tagsList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), let tag = cell.textLabel?.text else {return}
        let nextViewController = ProductsListTableViewController.getInstance()
        nextViewController.setProducts(ShopifyClient.sharedInstance.getProducts(for: tag))
        nextViewController.setTag(to: tag)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
