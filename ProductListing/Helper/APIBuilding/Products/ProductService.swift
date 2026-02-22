//
//  ProductService.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 22/02/26.
//

import Foundation

class ProductService {
    var product: Product?
    let productID: String?

    init(_ productID: String? = nil) {
        self.productID = productID
    }

    func loadProduct() async throws {
        product = try await APIManager.shared.get(ProductRequest(productID: self.productID, methodType: .get))
        print(String(describing: product))
    }
}
