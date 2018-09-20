//
//  Products.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-19.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import Foundation
struct Tags: Codable {
    let values: [String]
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let tagString = try container.decode(String.self)
        self.values = tagString.components(separatedBy: ", ")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        let tagString: String = self.values.joined(separator: ", ")
        try container.encode(tagString)
    }
}

struct Image: Codable {
    let productID: Int
    let src: String
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case src
    }
}

public class Product: Codable {
    var id: Int!
    var title: String!
    var tags: Tags!
    var variants: [Variant]!
    var image: Image!
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case tags
        case variants
        case image
    }
}

struct Variant: Codable {
    let productID: Int
    let inventoryQuantity: Int
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case inventoryQuantity = "inventory_quantity"
    }
}

class Products: Codable {
    var products: [Product]!    
    init() {
        products = [Product]()
    }
    func addProduct(_ product: Product) {
        products.append(product)
    }
}
