//
//  RegistrationViewController.swift
//  PixaFeed
//
//  Created by Irakli Shelia on 27.10.23.
//

import UIKit
import Combine

class RegistrationViewController: UIViewController {
    
    private let viewModel: RegistrationViewModel
    private var viewModelCancellables: Set<AnyCancellable> = []

    var coordinator: RegistrationCoordinator?
    
    private lazy var emailTextField = createTextField(placeholder: "Email", keyboardType: .emailAddress)
    private lazy var ageTextField = createTextField(placeholder: "Age", keyboardType: .numberPad)
    private lazy var passwordTextField = createTextField(placeholder: "Password", isSecure: true)
    
    private lazy var emailErrorLabel = createErrorLabel()
    private lazy var ageErrorLabel = createErrorLabel()
    private lazy var passwordErrorLabel = createErrorLabel()
    
    private lazy var registerButton: UIButton = {
        let button = createMainButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        return button
    }()
    
    init(viewModel: RegistrationViewModel) {
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
    }
}

// MARK: Setup UI
extension RegistrationViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        [emailTextField, ageTextField, passwordTextField, emailErrorLabel, ageErrorLabel, passwordErrorLabel, registerButton].forEach(view.addSubview)
    }
    
    private func setupConstraints() {
        let marginGuide = view.layoutMarginsGuide

        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 60),
            emailTextField.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),

            emailErrorLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8),
            emailErrorLabel.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            emailErrorLabel.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor),

            ageTextField.topAnchor.constraint(equalTo: emailErrorLabel.bottomAnchor, constant: 20),
            ageTextField.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            ageTextField.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -20),
            ageTextField.heightAnchor.constraint(equalToConstant: 44),

            ageErrorLabel.topAnchor.constraint(equalTo: ageTextField.bottomAnchor, constant: 8),
            ageErrorLabel.leadingAnchor.constraint(equalTo: ageTextField.leadingAnchor),
            ageErrorLabel.trailingAnchor.constraint(equalTo: ageTextField.trailingAnchor),

            passwordTextField.topAnchor.constraint(equalTo: ageErrorLabel.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),

            passwordErrorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8),
            passwordErrorLabel.leadingAnchor.constraint(equalTo: passwordTextField.leadingAnchor),
            passwordErrorLabel.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor),

            registerButton.topAnchor.constraint(equalTo: passwordErrorLabel.bottomAnchor, constant: 40),
            registerButton.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
}

// MARK: Setup bindings
extension RegistrationViewController {
    private func setupViewModelBindings() {
        //        viewModel.statePublisher
        //            .receive(on: DispatchQueue.main)
        //            .sink { [weak self] state in
        //                self?.handle(state: state)
        //            }
        //            .store(in: &viewModelCancellables)
        
        viewModel.navigateToAction
            .receive(on: DispatchQueue.main)
            .sink { [weak self] action in
                self?.handle(action: action)
            }
            .store(in: &viewModelCancellables)
    }
    
    private func handle(action: NavigationAction) {
        switch action {
        case .home:
            coordinator?.navigateToHome()
        default:
            break
        }
    }
}

// MARK: Actions and Error Handling
extension RegistrationViewController {
    @objc private func didTapRegisterButton() {
        resetErrorLabels()
        do {
            try viewModel.register(email: emailTextField.text ?? "",
                                   age: Int(ageTextField.text ?? "") ?? 0,
                                   password: passwordTextField.text ?? "")
            // Success handling can be added here
        } catch let error as ValidationError {
            displayValidationError(error)
        } catch {
            // Handle other generic errors if needed
        }
    }

    private func resetErrorLabels() {
        emailErrorLabel.text = ""
        ageErrorLabel.text = ""
        passwordErrorLabel.text = ""
    }

    private func displayValidationError(_ error: ValidationError) {
        switch error {
        case .invalidEmail:
            emailErrorLabel.text = error.errorMessage
            emailErrorLabel.isHidden = false
        case .invalidPasswordLength:
            passwordErrorLabel.text = error.errorMessage
            passwordErrorLabel.isHidden = false
        case .invalidAgeRange:
            ageErrorLabel.text = error.errorMessage
            ageErrorLabel.isHidden = false
        default:
            break
        }
    }
}

// MARK: UI Helper methods
extension RegistrationViewController {
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
        return label
    }
    
    private func createMainButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold) // Increase font size and weight for better appearance
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.tintColor = .white
        return button
    }
}
