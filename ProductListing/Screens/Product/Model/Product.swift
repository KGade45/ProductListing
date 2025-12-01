//
//  Product.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 01/12/25.
//

import Foundation

struct Product: Decodable {
    let id: Int
    let title: String
    let price: Float
    let description: String
    let category: String
    let image: String
    let rating: Rate
}

struct Rate: Decodable {
    let rate: Float
    let count: Int
}
