//
//  ProductRequest.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 22/02/26.
//

import Foundation

struct ProductRequest: APIRequest {

    var productID: String?
    var methodType: HTTPMethods
    var header: [String: String]?
    var queryParam: [URLQueryItem]?
    var bodyData: Data?
    var urlpath: String
    
    init(productID: String? = nil,
         path: String = "",
         methodType: HTTPMethods = .get,
         header: [String: String]? = nil,
         queryParam: [URLQueryItem]? = nil,
         bodyData: Data? = nil) {
        self.urlpath = path
        self.productID = productID
        self.methodType = methodType
        self.header = header
        self.queryParam = queryParam
        self.bodyData = bodyData
    }

    var baseURL: URL {
        URL(string: "https://fakestoreapi.com")!
    }

    var path: String {
        if let productID {
            return "\(urlpath)/\(productID)"
        } else {
            return urlpath
        }
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
