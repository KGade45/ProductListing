//
//  LoginViewModel.swift
//  ProductListing
//
//  Created by Kaustubh kailas gade on 18/02/26.
//

import Combine
import Foundation

class LoginViewModel {

    // Input
    @Published var email: String = ""
    @Published var password: String = ""

    // Output
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: String? = nil
    @Published private(set) var isLoginButtonEnabled: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    init() {
        validate()
    }

    private func validate() {
        Publishers.CombineLatest($email, $password)
            .map { email, password in
                return self.isValidEmail(email) && password.count >= 6
        }
            .assign(to: \.isLoginButtonEnabled, on: self)
            .store(in: &cancellables)
    }

    func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    func login() async {
        if !isLoginButtonEnabled { return }
        isLoading = true
        error = nil

        defer {
            isLoading = false
        }

        do {
            let success = try await performLogin(self.email, self.password)
            if !success {
                error = "Invalid credentials"
            }
        } catch {
            self.error = "Login failed"
        }
    }

    private func performLogin(_ email: String, _ password: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return email=="kaustubh@gmail.com" && password=="password"
    }
}
