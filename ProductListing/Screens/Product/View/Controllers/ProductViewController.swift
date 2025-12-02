//
//  ProductViewController.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 02/12/25.
//

import UIKit

class ProductViewController: UIViewController {

    private let productViewModel = ProductViewModel()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension ProductViewController {
    private func configure() {
        initiateViewModel()
        obersevedEvent()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func initiateViewModel() {
        productViewModel.fetchProducts()
    }

    private func obersevedEvent() {
        productViewModel.handler = { [weak self] event in
            guard let self else { return }
            switch event {
            case .loading:
                print("Loading")
            case .dataLoaded:
                print(productViewModel.products)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .error(let error):
                print(error?.localizedDescription ?? "Unknown Error")
            }
        }
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        cell.config(with: productViewModel.products[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
