//
//  Products.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-19.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import Foundation

public class Product: Codable {
    var id: Int!
    var title: String!
    var tags: Tags!
    var variants: [Variant]!
    var image: Image!
    // Set custom coding keys for converting from JSON to object
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case tags
        case variants
        case image
    }
    
    public func getSmallImageURL() -> URL {
        // Append _small to image name in url to obtain a 100x100px image for memory management
        var imageURL = URL(string: image.src)!
        var newLastComponent = imageURL.lastPathComponent.split(separator: ".")[0].description
        newLastComponent.append(contentsOf: "_small.png")
        imageURL.deleteLastPathComponent()
        imageURL.appendPathComponent(newLastComponent)
        return imageURL
    }
}

struct Tags: Codable {
    let values: [String]
    init(from decoder: Decoder) throws {
        // Convert comma separated string for tags into an array of strings
        let container = try decoder.singleValueContainer()
        let tagString = try container.decode(String.self)
        self.values = tagString.components(separatedBy: ", ")
    }
    func encode(to encoder: Encoder) throws {
        // Convert array of strings to comma separated strings
        var container = encoder.singleValueContainer()
        let tagString: String = self.values.joined(separator: ", ")
        try container.encode(tagString)
    }
}

struct Image: Codable {
    let productID: Int
    let src: String
    // Set custom coding keys for converting from JSON to object
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case src
    }
}

struct Variant: Codable {
    let productID: Int
    let inventoryQuantity: Int
    // Set custom coding keys for converting from JSON to object
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case inventoryQuantity = "inventory_quantity"
    }
}

// Needed class to decode array of products returned by Shopify REST API
class Products: Codable {
    var products: [Product]!    
    init() {
        products = [Product]()
    }
}
