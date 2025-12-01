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

    func fetchProducts(completion: @escaping (Result<[Product], Error>) -> Void) {
        guard let url = URL(string: Constant.API.baseURL) else {
            completion(.failure(DataError.invalideURL))
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data, error == nil else {
                completion(.failure(DataError.noDataReturned))
                return
            }
            guard let response = response as? HTTPURLResponse,
                200 ... 299 ~= response.statusCode else {
                completion(.failure(DataError.invalideResponse))
                return
            }
            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(.success(products))
            } catch {
                completion(.failure(DataError.unableToDecode))
            }
        }.resume()
        
    }
}
