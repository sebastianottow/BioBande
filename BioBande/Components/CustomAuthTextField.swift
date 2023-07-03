//
//  CustomAuthTextField.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 31.05.23.
//

import UIKit

class CustomAuthTextField: UITextField {
    
    enum CustomAuthTextFieldType {
        case username
        case email
        case password
        case search
    }
    
    private let authFieldType: CustomAuthTextFieldType
    
    init(fieldType: CustomAuthTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email Address"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
            
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true

        case .search:
            self.placeholder = "Enter destination"
            self.leftViewMode = .always
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
