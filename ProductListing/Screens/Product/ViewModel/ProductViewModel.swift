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
    @Published private(set) var products: [Product] = []

    func fetchProducts() async throws {
        self.products = try await APIManager.shared.fetchProducts()
    }
}

extension ProductViewModel {
    enum Event {
        case loading
        case dataLoaded
        case error(Error?)
    }
}
