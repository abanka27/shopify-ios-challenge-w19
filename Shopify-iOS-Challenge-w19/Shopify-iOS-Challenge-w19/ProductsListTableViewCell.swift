//
//  ProductsListTableViewCell.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-19.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import UIKit

class ProductsListTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var inventory: UILabel!
    
    var product: Product! {
        didSet {
            title.text = product.title
            var totalInventory: Int = 0
            product.variants.forEach() {
                totalInventory = totalInventory + $0.inventoryQuantity
            }
            inventory.text = "\(totalInventory)"
            if let image = ShopifyClient.sharedInstance.getImageCache()[product.id] {
                productImage.image = image
            }
        }
    }
    
    // MARK: - Initializers
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Round the image and add black border to it
        productImage.layer.cornerRadius = productImage.bounds.size.width * 0.5
        productImage.clipsToBounds = true
        productImage.layer.borderWidth = 1
    }
}
