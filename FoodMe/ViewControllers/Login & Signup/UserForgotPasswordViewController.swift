//
//  UserForgotPasswordViewController.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 09.06.23.
//

import Combine
import CombineCocoa
import Foundation
import UIKit


class UserForgotPasswordViewController: UIViewController {
    
    private let _viewModel = ForgotPasswordViewModel()
    
    private let _headerView = AuthHeaderView(title: "Forgot Password", subTitle: "Reset your password")
    
    private let _emailField = CustomAuthTextField(fieldType: .email)
    
    private let _resetPasswordButton = CustomButton(title: "Reset Password", hasBackground: true, fontSize: .big)
    
    private let _holderStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private var _cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPublishers()
        
        self._resetPasswordButton.addTarget(self, action: #selector(didTapResetPasswordButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupPublishers() {
        
        _emailField.textPublisher
            .map { "\($0 ?? "")" }
            .assign(to: \.emailaddress, on: _viewModel)
            .store(in: &_cancellables)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        _headerView.translatesAutoresizingMaskIntoConstraints = false
        _emailField.translatesAutoresizingMaskIntoConstraints = false
        _resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(_headerView)
        _headerView.edgesToSuperview(excluding: .bottom)
        _headerView.height(222)
        
        view.addSubview(_holderStackView)
        _holderStackView.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 500, right: 10))
        _holderStackView.topToBottom(of: _headerView, offset: 20)
        
        _holderStackView.addArrangedSubview(_emailField)
        _emailField.height(55)
        
        view.addSubview(_resetPasswordButton)
        _resetPasswordButton.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 10, right: 10))
        _resetPasswordButton.topToBottom(of: _emailField, offset: 30)
        _resetPasswordButton.height(55)
    }
    
    @objc func didTapResetPasswordButton() {
        
        let forgotPasswordRequest = ForgotPasswordRequest(email: _viewModel.emailaddress)
        
        if !CustomValidator.isValidEmail(for: forgotPasswordRequest.email) {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        
        AuthServices.shared.forgotPassword(with: forgotPasswordRequest.email) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                AlertManager.showErrorSendingPasswordReset(on: self, with: error)
                return
            }
            
            AlertManager.showPasswordResetSent(on: self)
        }
    }
    
}
