//
//  ProductDetailViewController.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 04/03/26.
//

import UIKit

class ProductDetailViewController: UIViewController {

    let productImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()

    let productName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let decsriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    func bind(viewData: Product) async throws {
        let image = try await ImageLoader.shared.loadImage(from: viewData.image)
        productImage.image = image
        productName.text = viewData.title
        decsriptionLabel.text = viewData.description
        priceLabel.text = "$\(viewData.price)"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    func configureView() {
        navigationItem.title = "Product Details"
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(productImage)
        mainStackView.addArrangedSubview(productName)
        mainStackView.addArrangedSubview(priceLabel)
        mainStackView.addArrangedSubview(decsriptionLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
        ])
    }

    @objc
    private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
}
