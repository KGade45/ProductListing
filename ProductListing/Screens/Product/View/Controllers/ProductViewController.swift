//
//  ProductViewController.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 02/12/25.
//

import UIKit
import Combine

class ProductViewController: UIViewController {

    let productService = ProductService()

    private var cancellables: Set<AnyCancellable> = []
    private let productViewModel = ProductViewModel()
    private var fetchTask: Task<Void, Never>?

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchTask = Task {
            do {
                try await productViewModel.fetchProducts()
                try await productService.loadProduct()
            } catch {
                print("Failed to fetch:", error)
            }
        }
    }

    deinit {
        fetchTask?.cancel()
    }
}

extension ProductViewController {
    private func configure() {
        observedEvent()
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func observedEvent() {
        productViewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
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
