//
//  ProductTableViewCell.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 02/12/25.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    static let identifier: String = "ProductTableViewCell"
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        return stackView
    }()

    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        return stackView
    }()

    let productName: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    let productPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let productDesc: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        mainStackView.addArrangedSubview(productImageView)
        mainStackView.addArrangedSubview(infoStackView)
        infoStackView.addArrangedSubview(productName)
        infoStackView.addArrangedSubview(productPrice)
        infoStackView.addArrangedSubview(productDesc)
        contentView.addSubview(mainStackView)
        activateConstraints()
    }

    func activateConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            productImageView.widthAnchor.constraint(equalToConstant: 80),
            productImageView.heightAnchor.constraint(equalTo: mainStackView.heightAnchor, multiplier: 0.9),
            infoStackView.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8),
            infoStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 8),
            infoStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 8),
            infoStackView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: -8),
        ])
    }

    func config(with product: Product) {
        productName.text = product.title
        productPrice.text = "$\(product.price)"
        productDesc.text = product.description
        productImageView.load(from: product.image)
    }
}
