//
//  ProductsListTableViewCell.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-19.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import UIKit

class ProductsListTableViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var inventory: UILabel!
    @IBOutlet weak var variantsAvailable: UILabel!
    
    var product: Product! {
        didSet {
            title.text = product.title
            var totalInventory: Int = 0
            product.variants.forEach() {
                totalInventory = totalInventory + $0.inventoryQuantity
            }
            inventory.text = "\(totalInventory)"
            variantsAvailable.text = "\(product.variants.count) Variants Available"

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if let product = product {
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
