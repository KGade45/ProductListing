//
//  APIManager.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 01/12/25.
//

import UIKit

enum DataError: Error {
    case invalideURL
    case invalideResponse
    case noDataReturned
    case unableToDecode
    case networkError(Error)
}
final class APIManager {
    private init(){}
    static let shared = APIManager()

    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: Constant.API.baseURL) else {
            throw DataError.invalideURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse,
              200...299 ~= response.statusCode else {
            throw DataError.invalideResponse
        }

        do {
            return try JSONDecoder().decode([Product].self, from: data)
        } catch {
            throw DataError.unableToDecode
        }
    }
}
