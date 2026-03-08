//
//  APIManager.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 01/12/25.
//

import UIKit

enum DataError: Error {
    case invalidURL
    case network(Error)
    case decoding(Error)
    case encoding(Error)
    case clientError(Int)
    case serverError(Int)
    case unauthorized
    case message(String)
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
            throw DataError.network("error" as! Error)
        }

        do {
            return try JSONDecoder().decode([Product].self, from: data)
        } catch {
            throw DataError.decoding(error)
        }
    }

    func request<T: Decodable>(_ request: APIRequest) async throws -> T {
        let urlRequest = try request.asURLRequest()

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw DataError.network(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw DataError.invalidURL
        }
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw DataError.unauthorized
        case 400..<500:
            throw DataError.clientError(httpResponse.statusCode)
        case 500...599:
            throw DataError.clientError(httpResponse.statusCode)
        default:
            throw DataError.clientError(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw DataError.decoding(error)
        }
    }

    func requestWithRetry<T: Decodable>(_ request: APIRequest, retryCount: Int = 2) async throws -> T {
        do {
            return try await self.request(request)
        } catch DataError.serverError(_) where retryCount > 0 {
            print("Retrying due to server error")
            return try await requestWithRetry(request, retryCount: retryCount - 1)
        } catch DataError.network(_) where retryCount > 0 {
            return try await requestWithRetry(request, retryCount: retryCount - 1)
        } catch {
            throw error
        }
    }
}
