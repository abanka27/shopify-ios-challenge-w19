//
//  ProductsListTableViewController.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-18.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import UIKit

class ProductsListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var products = [Product]()
    private var tag: String!
    
    // MARK: - Setters
    public func setProducts(_ products: [Product]) {
        self.products = products
    }
    
    public func setTag(to tag: String) {
        self.tag = tag
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = tag
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: "ProductsListTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductsListTableViewCell")
        if (!self.products.isEmpty) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        products.removeAll()
        tableView.removeFromSuperview()
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
        return products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "ProductsListTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ProductsListTableViewCell else { fatalError("Dequeued cell is not of type \(reuseIdentifier)")}
        // Configure the cell...
        cell.product = products[indexPath.row]
        return cell
    }
    
    // MARK: - Static Methods
    
    public static func getInstance() -> ProductsListTableViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProductsListTableViewController") as? ProductsListTableViewController else {fatalError()}
        return viewController
    }

}
