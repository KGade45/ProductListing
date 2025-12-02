//
//  ProductViewModel.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 02/12/25.
//

import Foundation

final class ProductViewModel {
    var products: [Product] = []
    var handler: ((_ event: Event) -> Void)?

    func fetchProducts() {
        handler?(.loading)
        APIManager.shared.fetchProducts { (result) in
            self.handler?(.dataLoaded)
            switch result {
            case .success(let products):
                self.products = products
                self.handler?(.dataLoaded)
            case .failure(let error):
                self.handler?(.error(error))
            }
        }
    }
}

extension ProductViewModel {
    enum Event {
        case loading
        case dataLoaded
        case error(Error?)
    }
}
