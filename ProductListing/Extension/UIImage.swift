//
//  UIImage.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 03/12/25.
//

import UIKit

let imageCache = NSCache<NSURL, UIImage>()

extension UIImageView {
//    func load(from urlString: String) {
//        guard let url = URL(string: urlString) else { return }
//
//        if let imageFromCache = imageCache.object(forKey: url as NSURL) {
//            self.image = imageFromCache
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let data = data, let image = UIImage(data: data), error == nil {
//                imageCache.setObject(image, forKey: url as NSURL)
//                DispatchQueue.main.async {
//                    self.image = image
//                }
//            }
//        }.resume()
//    }
}
