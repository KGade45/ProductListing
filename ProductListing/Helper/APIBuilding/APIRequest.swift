//
//  APIRequest.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 22/02/26.
//

import Foundation

protocol APIRequest {
    var path: String { get }
    var method: HTTPMethods { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryItems: [URLQueryItem]? { get }
    var baseURL: String { get }
}

extension APIRequest {
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: baseURL)!
        var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems

        guard let validUrl = components?.url else {
            throw DataError.invalidURL
        }

        var request = URLRequest(url: validUrl)
        request.httpMethod = method.rawValue
        request.httpBody = body

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
