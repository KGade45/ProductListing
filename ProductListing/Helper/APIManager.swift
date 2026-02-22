//
//  APIManager.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 01/12/25.
//

import UIKit

enum DataError: Error {
    case invalidURL
    case invalideResponse
    case noDataReturned
    case unableToDecode
    case networkError(Error)
}
final class APIManager {

    private let session: URLSession
    static let shared = APIManager()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: Constant.API.baseURL) else {
            throw DataError.invalidURL
        }

        let (data, response) = try await self.session.data(from: url)

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

    func get<T: Decodable>(_ request: APIRequest) async throws -> T {
        let urlRequest = try request.asURLRequest()
        let (data, response) = try await session.data(for: urlRequest)

        guard let response = response as? HTTPURLResponse,
              200...299 ~= response.statusCode else {
            throw DataError.invalideResponse
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw DataError.unableToDecode
        }
    }
}
