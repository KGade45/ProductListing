//
//  UIImage.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 03/12/25.
//

import UIKit

extension UIImageView {
    func load(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, let image = UIImage(data: data), error == nil {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
