//
//  ProductRequest.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 22/02/26.
//

import Foundation

class ProductRequest: APIRequest {

    var productID: String?
    var methodType: HTTPMethods
    var header: [String: String]?
    var queryParam: [URLQueryItem]?
    var bodyData: Data?
    
    init(productID: String? = nil, methodType: HTTPMethods = .get, header: [String: String]? = nil, queryParam: [URLQueryItem]? = nil, bodyData: Data? = nil) {
        self.productID = productID
        self.methodType = methodType
        self.header = header
        self.queryParam = queryParam
        self.bodyData = bodyData
    }

    var baseURL: String {
        "https://fakestoreapi.com"
    }

    var path: String {
        if let productID {
            return "/products/\(productID)"
        }
        else { return "/products" }
    }

    var method: HTTPMethods {
        methodType
    }

    var headers: [String : String]? {
        header
    }

    var queryItems: [URLQueryItem]? {
        queryParam
    }

    var body: Data? {
        bodyData
    }
}
