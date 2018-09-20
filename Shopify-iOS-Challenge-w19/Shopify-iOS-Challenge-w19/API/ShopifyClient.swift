//
//  ShopifyClient.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-18.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import Foundation
import UIKit

public typealias ProductDictionary = [String: [Product]]

public class ShopifyClient {
    public static let sharedInstance = ShopifyClient()
    private var productsCache = ProductDictionary()
    private var imageCache = [Int: UIImage]()
    private var initialData: Bool = true
    
    public func getProductsCache() -> ProductDictionary {
        return productsCache
    }
    
    public func getImageCache() -> [Int: UIImage] {
        return imageCache
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
                    self.downloadImage(from: URL(string: product.image.src)!, id: product.id)
                    product.tags.values.forEach(){ tag in
                        if self.productsCache[tag] == nil {
                            self.productsCache[tag] = [Product]()
                        }
                        self.productsCache[tag]?.append(product)
                    }
                }
                completion(self.productsCache)
            } catch {
                print("Failed")
                return
            }
        }
        task.resume()
    }
    
    private func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    public func downloadImage(from url: URL, id: Int) {
        getImageData(from: url) { (data, response, error) in
            guard let data = data, error == nil else {return}
            DispatchQueue.main.async {
                self.imageCache[id] = UIImage(data: data)
            }
        }
    }
}
