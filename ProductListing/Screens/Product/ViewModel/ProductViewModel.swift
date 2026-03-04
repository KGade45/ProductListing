//
//  ProductViewModel.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 02/12/25.
//

import Foundation
import Combine

@MainActor
final class ProductViewModel {

    let productService = ProductService()
    
    @Published private(set) var loading = false
    @Published private(set) var products: [Product] = []

    func fetchProducts() async throws {
        self.loading = true
        try await Task.sleep(nanoseconds: 1_000_000_000)
        self.products = try await productService.loadProduct()
        self.loading = false
//        self.products = try await APIManager.shared.fetchProducts()
    }

    func addProduct(_ product: Product) async throws {
        _ = try await productService.addProduct(product: product)
    }
}

extension ProductViewModel {
    enum Event {
        case loading
        case dataLoaded
        case error(Error?)
    }
}
