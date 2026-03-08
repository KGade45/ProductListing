//
//  ProductService.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 22/02/26.
//

import Foundation

class ProductService {
    let productID: String?
    let apiManager: APIManager
    init(apiManager: APIManager = APIManager(), _ productID: String? = nil) {
        self.productID = productID
        self.apiManager = apiManager
    }

    func loadProduct() async throws -> [Product] {
//        product = try await APIManager.shared.get(ProductRequest(productID: self.productID, methodType: .get))
        let products: [Product] = try await apiManager.request(ProductRequest(path: "/products"))
//        print(String(describing: products))
        return products
    }

    func addProduct(product: Product) async throws -> Product {
        let productData: Data
        do {
            productData = try JSONEncoder().encode(product)
        } catch {
            throw DataError.decoding(error)
        }

        let productRequest = ProductRequest(
            path: "/products",
            methodType: .post,
            header: ["Content-Type": "application/json"],
            bodyData: productData
        )

        let createdProduct: Product = try await apiManager.request(productRequest)
        print(createdProduct)
        return createdProduct
    }
}
