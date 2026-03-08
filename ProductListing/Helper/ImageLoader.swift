//
//  ImageLoader.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 08/03/26.
//

import Foundation
import UIKit

protocol ImageLoading {
    func loadImage(from urlString: String) async throws -> UIImage
}

actor ImageLoader: ImageLoading {

    static let shared = ImageLoader()
    private let cache = NSCache<NSURL, UIImage>()
    private var runningTasks: [URL: Task<UIImage, Error>] = [:]

    internal func loadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else { throw DataError.invalidURL }
        if let imageFromCache = cache.object(forKey: url as NSURL) {
            return imageFromCache
        }
        if let existingTask = runningTasks[url] {
            return try await existingTask.value
        }
        let task = Task {
            let (data, response) = try await URLSession.shared.data(from: url)

            guard let response = response as? HTTPURLResponse,
                  200...299 ~= response.statusCode else {
                throw DataError.serverError(500)
            }

            guard let image =  UIImage(data: data) else { throw DataError.message("Invalid Image") }
            return image
        }
        
        runningTasks[url] = task
        do {
            let image = try await task.value
            cache.setObject(image, forKey: url as NSURL)
            runningTasks.removeValue(forKey: url)
            return image
        } catch {
            runningTasks.removeValue(forKey: url)
            throw error
        }
    }
}
