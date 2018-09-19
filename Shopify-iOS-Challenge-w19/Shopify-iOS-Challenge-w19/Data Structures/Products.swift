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
    let width, height: Int
    let src: String
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case width
        case height
        case src
    }
}

public struct Product: Codable {
    let id: Int
    let title: String
    let productType: String
    let tags: Tags
    let variants: [Variant]
    let image: Image
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case productType = "product_type"
        case tags
        case variants
        case image
    }
}

struct Variant: Codable {
    let id: Int
    let productID: Int
    let title: String
    let price: String
    let sku: String
    let inventoryQuantity: Int
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case productID = "product_id"
        case price
        case sku
        case inventoryQuantity = "inventory_quantity"
    }
}

struct Products: Codable {
    var products: [Product]
    mutating func addProduct(_ product: Product) {
        products.append(product)
    }
}
