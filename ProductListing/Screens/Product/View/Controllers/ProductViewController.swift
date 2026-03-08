//
//  ProductViewController.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 02/12/25.
//

import UIKit
import Combine

class ProductViewController: UIViewController {

    private var cancellables: Set<AnyCancellable> = []
    private let productViewModel = ProductViewModel()
    private var fetchTask: Task<Void, Never>?
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        configure()
        bindViewModel()
        fetchProducts()
    }

    private func bindViewModel() {
        productViewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                print("Loading changed:", isLoading)
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }

    private func fetchProducts() {
        fetchTask = Task {
            do {
                try await productViewModel.fetchProducts()
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
        setupActivityIndicator()
    }

    private func observedEvent() {
        productViewModel.$products
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.hidesWhenStopped = true
        
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ProductViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productViewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ProductTableViewCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        Task {
            try await cell.config(with: productViewModel.products[indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let product = productViewModel.products[indexPath.row]

        Task {
            try? await productViewModel.addProduct(product)
        }

        let detailViewController = ProductDetailViewController()
        Task {
            try await detailViewController.bind(viewData: product)
        }
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
