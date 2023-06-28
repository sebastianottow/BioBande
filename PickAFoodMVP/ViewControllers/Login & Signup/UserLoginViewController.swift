//
//  UserLoginViewController.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 15.05.23.
//

import Foundation
import Combine
import CombineCocoa
import TinyConstraints
import UIKit


class UserLoginViewController: UIViewController {
    
    private let _headerView = AuthHeaderView(title: "Sign In", subTitle: "Sign in to your account")
    
    private let _signUserInButton = CustomButton(title: "Sign In",hasBackground: true, fontSize: .big)
    private let _registerUserButton = CustomButton(title: "New User? Create Account", fontSize: .med)
    private let _forgotPasswordButton = CustomButton(title: "Forgot Password", fontSize: .small)
    
    private var _emailInputTextField = CustomAuthTextField(fieldType: .email)
    private var _passwordInputTextField = CustomAuthTextField(fieldType: .password)
    
    private let _viewModel = LoginUserViewModel()
    
    private var _cancellables: Set<AnyCancellable> = []
    
    private let _holderStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPublishers()
        
        self._signUserInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        self._registerUserButton.addTarget(self, action: #selector(didTapCreateNewUser), for: .touchUpInside)
        self._forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupPublishers() {
        
        _emailInputTextField.textPublisher
            .map { "\($0 ?? "")" }
            .assign(to: \.emailaddress, on: _viewModel)
            .store(in: &_cancellables)
        
        _passwordInputTextField.textPublisher
            .map { "\($0 ?? "")" }
            .assign(to: \.userpassword, on: _viewModel)
            .store(in: &_cancellables)
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(_headerView)
        _headerView.edgesToSuperview(excluding: .bottom)
        _headerView.height(222)
        
        view.addSubview(_holderStackView)
        _holderStackView.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 500, right: 10))
        _holderStackView.topToBottom(of: _headerView, offset: 20)

        _holderStackView.addArrangedSubview(_emailInputTextField)
        _emailInputTextField.height(55)
        
        _holderStackView.addArrangedSubview(_passwordInputTextField)
        _passwordInputTextField.height(55)
                        
        view.addSubview(_signUserInButton)
        view.addSubview(_registerUserButton)
        view.addSubview(_forgotPasswordButton)
        
        _headerView.translatesAutoresizingMaskIntoConstraints = false
        _holderStackView.translatesAutoresizingMaskIntoConstraints = false
        _signUserInButton.translatesAutoresizingMaskIntoConstraints = false
        _registerUserButton.translatesAutoresizingMaskIntoConstraints = false
        _forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false

        _signUserInButton.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 10, right: 10))
        _signUserInButton.topToBottom(of: _holderStackView, offset: 30)
        _signUserInButton.height(55)

        _registerUserButton.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 10, right: 10))
        _registerUserButton.topToBottom(of: _signUserInButton)
        _registerUserButton.height(44)

        _forgotPasswordButton.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 10, right: 10))
        _forgotPasswordButton.topToBottom(of: _registerUserButton)
        _registerUserButton.height(44)
    }
    
    @objc func didTapSignIn() {
        
        let loginRequest = LoginUserRequest(
            email: _viewModel.emailaddress,
            password: _viewModel.userpassword
        )
        
        //Email check
        if !CustomValidator.isValidEmail(for: loginRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        //Password check
        if !CustomValidator.isPasswordValid(for: loginRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        AuthServices.shared.signIn(with: loginRequest) { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showSignInErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            } else {
                AlertManager.showSignInErrorAlert(on: self)
            }
        }
    }
    
    @objc func didTapCreateNewUser() {
        let registerUserViewController = RegisterUserViewController()
        self.navigationController?.pushViewController(registerUserViewController, animated: true)
    }
    
    @objc func didTapForgotPassword() {
        // MARK: create new VC for forgot Password!
        let forgotPasswordViewController = UserForgotPasswordViewController()
        self.navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
}
