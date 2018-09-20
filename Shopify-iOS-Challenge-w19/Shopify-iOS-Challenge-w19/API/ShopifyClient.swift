//
//  ShopifyClient.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-18.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import Foundation
import UIKit

typealias TagCache = [String: [Int]]
typealias ProductCache = [Int: Product]

class ShopifyClient {
    // MARK: - Properties
    
    static let sharedInstance = ShopifyClient()
    private var tagsCache = TagCache()
    private var productsCache = ProductCache()
    private var imageCache = [Int: UIImage]()
    private var initialData: Bool = true
    private var apiURL: URL!
    
    private init() {
        apiURL = URL(string: "https://shopicruit.myshopify.com/admin/products.json?access_token=c32313df0d0ef512ca64d5b336a0d7c6&page=1")!
    }
    
    // MARK: - Getter Methods
    
    public func getProducts(for tag: String) -> [Product]{
        var productsArray = [Product]()
        if let productIds = self.tagsCache[tag] {
            productIds.forEach({productsArray.append(self.productsCache[$0]!)})
        }
        return productsArray
    }
    
    public func getImageCache() -> [Int: UIImage] {
        return imageCache
    }
    
    // MARK: - Common Methods
    
    private func getDataFromURL(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        let config = URLSessionConfiguration.ephemeral
        config.waitsForConnectivity = true
        let session = URLSession(configuration: config)
        session.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // MARK: - Data Downloading Methods
    
    private func downloadImage(from url: URL,for productId: Int) {
        getDataFromURL(from: url) { (data, response, error) in
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                // Store UIImage in imageCache
                self.imageCache[productId] = UIImage(data: data)
            }
        }
    }
    
    public func downloadProductsListFromShopify(completion: @escaping  (TagCache?, Error?)->()) {
        guard tagsCache.isEmpty || initialData else { return completion(tagsCache, nil) }
        getDataFromURL(from: apiURL) { data, response, error in
            guard let data = data, error == nil else { return completion(nil, error) }
            do {
                let products = try JSONDecoder().decode(Products.self, from: data)
                products.products.forEach(){ (product) in
                    // Download sized-down image
                    self.downloadImage(from: product.getSmallImageURL(), for: product.id)
                    // Store product in dictionary with id as key
                    self.productsCache[product.id] = product
                    product.tags.values.forEach(){ tag in
                        // Check if tagsCache has been initialized
                        if self.tagsCache[tag] == nil {
                            self.tagsCache[tag] = [Int]()
                        }
                        // Append product id to the array stored under the tag key in tagsCache
                        self.tagsCache[tag]?.append(product.id)
                    }
                }
                completion(self.tagsCache, nil)
            } catch {
                return completion(nil, error)
            }
        }
    }
}
