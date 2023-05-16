//
//  UserRegistrationViewController.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 15.05.23.
//

import Combine
import CombineCocoa
import TinyConstraints
import UIKit


class RegisterUserViewController: UIViewController {
    
    private let _headerView = AuthHeaderView(title: "Sign Up", subTitle: "Create your account")
    
    private let _registerUserButton = CustomButton(title: "Sign Up", hasBackground: true, fontSize: .big)
    private let _signUserInButton = CustomButton(title: "Already have an account? Sign In.", fontSize: .med)
    
    private var _usernameInputTextField = CustomAuthTextField(fieldType: .username)
    private var _emailInputTextField = CustomAuthTextField(fieldType: .email)
    private var _passwordInputTextField = CustomAuthTextField(fieldType: .password)
    
    private let _termsTextView: UITextView = {
            let attributedString = NSMutableAttributedString(string: "By creating an account, you agree to our Terms & Conditions and you acknowledge that you have read our Privacy Policy.")
            
            attributedString.addAttribute(.link, value: "terms://termsAndConditions", range: (attributedString.string as NSString).range(of: "Terms & Conditions"))
            
            attributedString.addAttribute(.link, value: "privacy://privacyPolicy", range: (attributedString.string as NSString).range(of: "Privacy Policy"))
            
            let tv = UITextView()
            tv.linkTextAttributes = [.foregroundColor: UIColor.systemBlue]
            tv.backgroundColor = .clear
            tv.attributedText = attributedString
            tv.textColor = .label
            tv.isSelectable = true
            tv.isEditable = false
            tv.delaysContentTouches = false
            tv.isScrollEnabled = false
            return tv
        }()
    
    private let _viewModel = RegisterUserViewModel()
    
    private var _cancellables: Set<AnyCancellable> = []
    
    private let _holderStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(_headerView)
        _headerView.edgesToSuperview(excluding: .bottom)
        _headerView.height(222)
                
        view.addSubview(_holderStackView)
        _holderStackView.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        _holderStackView.topToBottom(of: _headerView, offset: 20)
        
        _holderStackView.addArrangedSubview(_usernameInputTextField)
        _usernameInputTextField.height(55)
        
        _holderStackView.addArrangedSubview(_emailInputTextField)
        _emailInputTextField.height(55)
        
        _holderStackView.addArrangedSubview(_passwordInputTextField)
        _passwordInputTextField.height(55)
        
        view.addSubview(_registerUserButton)
        
        view.addSubview(_termsTextView)
        
        view.addSubview(_signUserInButton)
        
        _headerView.translatesAutoresizingMaskIntoConstraints = false
        _holderStackView.translatesAutoresizingMaskIntoConstraints = false
        _registerUserButton.translatesAutoresizingMaskIntoConstraints = false
        _termsTextView.translatesAutoresizingMaskIntoConstraints = false
        _signUserInButton.translatesAutoresizingMaskIntoConstraints = false
        
        _registerUserButton.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        _registerUserButton.topToBottom(of: _holderStackView, offset: 30)
        _registerUserButton.height(55)
        
        _termsTextView.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        _termsTextView.topToBottom(of: _registerUserButton)

        _signUserInButton.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        _signUserInButton.topToBottom(of: _termsTextView)
        _signUserInButton.height(44)
    }
    
    private func setupPublishers() {

        _usernameInputTextField.textPublisher
            .map { "\($0 ?? "")" }
            .assign(to: \.username, on: _viewModel)
            .store(in: &_cancellables)
        
        _emailInputTextField.textPublisher
            .map { "\($0 ?? "")" }
            .assign(to: \.emailaddress, on: _viewModel)
            .store(in: &_cancellables)
        
        _passwordInputTextField.textPublisher
            .map { "\($0 ?? "")" }
            .assign(to: \.userpassword, on: _viewModel)
            .store(in: &_cancellables)
        
//        _viewModel.isSignupButtonEnabled
//            .assign(to: \.isEnabled, on: _registerUserButton)
//            .store(in: &_cancellables)
        
    }
    
//    private func bind(viewModel: UserRegistrationViewModel) {
//
//        viewModel.$registrationState
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] state in
//
//                guard let self = self else { return }
//
//                switch state {
//                case .isLoading:
//                    print("is loading)")
//
//                    //MARK: show loading Spinner before moving on to the next case
//
//                case .failed(_):
//                    print("error")
//
//                    self.showErrorMessage(viewModel.errorMessage)
//                    //MARK: Display error message in activity indicator
//
//                case .loaded:
//                    print("was registered successfully")
//
//                    //MARK: show registration was successful before moving to homeViewController
//
//                    let homeViewController = HomeViewController()
//
//                    self.navigationController?.pushViewController(homeViewController, animated: true)
//                }
//            }
//            .store(in: &_cancellables)
//
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPublishers()
        
//        self._termsTextView.delegate = self
        
//        bind(viewModel: _viewModel)
        
        self._registerUserButton.addTarget(self, action: #selector(didTapRegisterUser), for: .touchUpInside)
        self._signUserInButton.addTarget(self, action: #selector(didTapSignInUser), for: .touchUpInside)
    }
    
    @objc func didTapRegisterUser(_ sender: Any) {
        
        let registerUserRequest = RegisterUserRequest(
            username: _viewModel.username,
            email: _viewModel.emailaddress,
            password: _viewModel.userpassword
        )
        
        //Email check
        if !CustomValidator.isValidEmail(for: registerUserRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        //Password check
        if !CustomValidator.isPasswordValid(for: registerUserRequest.password) {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        //Username check
        if !CustomValidator.isValidUsername(for: registerUserRequest.username) {
            AlertManager.showInvalidUsernameAlert(on: self)
            return
        }
    
        AuthServices.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showRegistrationErrorAlert(on: self, with: error)
                return
            }
            
            if wasRegistered {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                    sceneDelegate.checkAuthentication()
                }
            } else {
                AlertManager.showRegistrationErrorAlert(on: self)
            }
        }
    }
    
    @objc func didTapSignInUser() {
        let userLoginViewController = UserLoginViewController()
        self.navigationController?.pushViewController(userLoginViewController, animated: true)
    }
}

extension RegisterUserViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "terms" {
            self.showWebViewerController(with: "https://policies.google.com/terms?hl=en")
        } else if URL.scheme == "privacy" {
            self.showWebViewerController(with: "https://policies.google.com/privacy?hl=en")
        }
        
        return true
    }
    
    private func showWebViewerController(with urlString: String) {
        let vc = WebViewerController(with: urlString)
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.delegate = nil
        textView.selectedTextRange = nil
        textView.delegate = self
    }
}
