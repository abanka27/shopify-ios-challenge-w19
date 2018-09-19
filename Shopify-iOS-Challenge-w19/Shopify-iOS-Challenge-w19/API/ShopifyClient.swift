//
//  ShopifyClient.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-18.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import Foundation

public typealias ProductDictionary = [String: [Product]]

public class ShopifyClient {
    public static let sharedInstance = ShopifyClient()
    private var productsCache = ProductDictionary()
    private var initialData: Bool = true
    
    public func getProductsCache() -> ProductDictionary {
        return productsCache
    }
    
    public func getJSONDataFromShopify(onCompletion completion: @escaping (ProductDictionary)->()) {
        guard productsCache.isEmpty || initialData else { return completion(productsCache) }
        let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")!
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) {(data, response, error) in
            guard let data = data, error == nil else {return}
            do {
                let products = try JSONDecoder().decode(Products.self, from: data)
                products.products.forEach(){ (product) in
                    product.tags.values.forEach(){ tag in
                        if self.productsCache[tag] == nil {
                            self.productsCache[tag] = [Product]()
                        }
                        self.productsCache[tag]?.append(product)
                        print("success \(product)")
                    }
                }
                print("Success \(self.productsCache)")
                completion(self.productsCache)
            } catch {
                print("Failed")
                return
            }
        }
        task.resume()
    }
}
