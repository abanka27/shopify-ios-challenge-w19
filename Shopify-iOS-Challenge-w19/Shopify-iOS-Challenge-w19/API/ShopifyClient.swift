//
//  ShopifyClient.swift
//  Shopify-iOS-Challenge-w19
//
//  Created by user on 2018-09-18.
//  Copyright © 2018 Anshuman Banka. All rights reserved.
//

import Foundation
import UIKit

public class ShopifyClient {
    public static let sharedInstance = ShopifyClient()
    private var tagsCache = [String: [Int]]()
    private var productsCache = [Int: Product]()
    private var imageCache = [Int: UIImage]()
    private var initialData: Bool = true
    
    public func getProducts(for tag: String) -> [Product] {
        var productsArray = [Product]()
        if let productIds = self.tagsCache[tag] {
            productIds.forEach({productsArray.append(productsCache[$0]!)})
        }
        return productsArray
    }
    
    public func getImageCache() -> [Int: UIImage] {
        return imageCache
    }
    
    public func getDataFromShopify(onCompletion completion: @escaping ([String: [Int]])->()) {
        guard tagsCache.isEmpty || initialData else { return completion(tagsCache) }
        let url = URL(string: "https://shopicruit.myshopify.com/admin/products.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6")!
        let session = URLSession(configuration: .ephemeral)
        let task = session.dataTask(with: url) {(data, response, error) in
            guard let data = data, error == nil else {return}
            do {
                let products = try JSONDecoder().decode(Products.self, from: data)
                products.products.forEach(){ (product) in
                    // Append _small to image name to obtain a 100x100px image for memory management
                    var imageURL = URL(string: product.image.src)!
                    var newLastComponent = imageURL.lastPathComponent.split(separator: ".")[0].description
                    newLastComponent.append(contentsOf: "_small.png")
                    imageURL.deleteLastPathComponent()
                    imageURL.appendPathComponent(newLastComponent)
                    print("\(imageURL)")
                    self.downloadImage(from: imageURL, id: product.id)
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
                completion(self.tagsCache)
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
                // Store UIImage in imageCache
                self.imageCache[id] = UIImage(data: data)
            }
        }
    }
}
