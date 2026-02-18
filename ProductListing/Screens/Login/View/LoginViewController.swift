//
//  LoginViewController.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 18/02/26.
//

import Combine
import UIKit

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        return tf
    }()

    private let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .none
        return tf
    }()

    private let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.isEnabled = false
        return btn
    }()

    private let errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .red
        lbl.font = .systemFont(ofSize: 14)
        lbl.numberOfLines = 0
        return lbl
    }()

    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPink
        setupUI()
        bindViewModel()
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton, activityIndicator, errorLabel])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    }

    private func bindViewModel() {
        emailField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)

        viewModel.$isLoginButtonEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.errorLabel.text = error
            }
            .store(in: &cancellables)

        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }

    @objc
    private func didTapLogin() {
        Task {
            await viewModel.login()
        }
    }

    @objc
    fileprivate func emailChanged() {
        viewModel.email = emailField.text ?? ""
    }

    @objc
    fileprivate func passwordChanged() {
        viewModel.password = passwordField.text ?? ""
    }
}
