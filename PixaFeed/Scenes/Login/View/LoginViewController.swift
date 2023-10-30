//
//  LoginViewController.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 29.10.23.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private let viewModel: LoginViewModel
    private var viewModelCancellables: Set<AnyCancellable> = []
    
    var coordinator: LoginCoordinator?
    
    private lazy var emailTextField = createTextField(placeholder: "Email", keyboardType: .emailAddress)
    private lazy var passwordTextField = createTextField(placeholder: "Password", isSecure: true)
    private lazy var emailErrorLabel = createErrorLabel()
    private lazy var passwordErrorLabel = createErrorLabel()
    private lazy var loadingIndicator = createLoadingIndicator()
    private lazy var loginButton = createLoginButton()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(navigateToRegistration), for: .touchUpInside)
        return button
    }()
    
    // Initializer
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModelBindings()
        
        // Simplify Login
        emailTextField.text = "test@example.com"
        passwordTextField.text = "TestPass123"
    }
}

// MARK: Handle taps

extension LoginViewController {
    @objc private func didTapLoginButton() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        viewModel.didTapLogin(with: email, password: password)
        
    }
    
    @objc func navigateToRegistration() {
        viewModel.didTapRegistrataion()
    }
}

// MARK: Setup UI

extension LoginViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        [loadingIndicator, emailTextField, passwordTextField, emailErrorLabel, passwordErrorLabel, loginButton, registerButton].forEach(view.addSubview)
    }
    
    private func setupConstraints() {
        let marginGuide = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 60),
            emailTextField.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44), // Increase height for better touch target
            
            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            emailErrorLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailErrorLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),
            
            passwordTextField.topAnchor.constraint(equalTo: emailErrorLabel.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordErrorLabel.bottomAnchor, constant: 40),
            loginButton.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 52), // Increase height for better touch target
            
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 100),
            loadingIndicator.heightAnchor.constraint(equalToConstant: 100),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20), // Increased spacing for clarity
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

// MARK: Setup Bindings

extension LoginViewController {
    private func setupViewModelBindings() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }
            .store(in: &viewModelCancellables)
        
        viewModel.navigateToAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.handle(action: action)
            }
            .store(in: &viewModelCancellables)
    }
    
    private func handle(state: LoginViewModel.ViewModelState) {
        switch state {
        case .loading:
            loadingIndicator.startAnimating()
        case .success:
            loadingIndicator.stopAnimating()
            coordinator?.navigateToHome()
        case .failure(let error):
            loadingIndicator.stopAnimating()
            handleLoginError(error)
        case .idle:
            loadingIndicator.stopAnimating()
        }
    }
    
    private func handle(action: NavigationAction) {
        switch action {
        case .registration:
            coordinator?.navigateToRegistration()
        default:
            break
        }
    }
}

// MARK: Error Handling

extension LoginViewController {
    private func handleLoginError(_ error: Error) {
        if let validationError = error as? ValidationError {
            displayValidationError(validationError)
        } else {
            // MARK: TODO Handle network or other error here
        }
    }
    
    private func displayValidationError(_ error: ValidationError) {
        switch error {
        case .invalidEmail:
            emailErrorLabel.text = error.errorMessage
            emailErrorLabel.isHidden = false
        case .invalidPasswordLength:
            passwordErrorLabel.text = error.errorMessage
            passwordErrorLabel.isHidden = false
        default:
            break
        }
    }
}

// MARK: UI Helper methods

extension LoginViewController {
    private func createTextField(placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.keyboardType = keyboardType
        textField.isSecureTextEntry = isSecure
        textField.borderStyle = .roundedRect
        return textField
    }
    
    private func createErrorLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.systemRed.withAlphaComponent(0.8)
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }
    
    private func createLoadingIndicator() -> LoadingIndicatorView {
        let indicator = LoadingIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }
    
    private func createLoginButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold) // Increase font size and weight for better appearance
        button.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.tintColor = .white
        return button
    }
}
