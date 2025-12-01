//
//  ProductViewController.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 02/12/25.
//

import UIKit

class ProductViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        APIManager.shared.fetchProducts { (result) in
            switch result {
                case .success(let products):
                print(products)
                case .failure(let error):
                print(error)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
