//
//  RegisterUserViewModel.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 15.05.23.
//

import Foundation
import UIKit
import Combine

class RegisterUserViewModel: ObservableObject {
    
    enum RegistrationState {
        case isLoading
        case failed(Error)
        case loaded
    }
    
    @Published var registrationState: RegistrationState = .isLoading
    
    @Published var username: String = ""
    @Published var emailaddress: String = ""
    @Published var userpassword: String = ""
    
    @Published var errorMessage: String = ""
        
//    func registerNewUser(username: String, emailaddress: String, userpassword: String) {
//        
//        let userName = username.trimmingCharacters(in: .whitespacesAndNewlines)
//        let emailAddress = emailaddress.trimmingCharacters(in: .whitespacesAndNewlines)
//        let userPassword = userpassword.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        let userRequest = RegisterUserRequest(
//            username: userName,
//            email: emailAddress,
//            password: userPassword
//        )
//        
//        AuthServices.shared.registerUser(with: userRequest) { wasRegistered, error in
//            if let error = error {
//                print(error.localizedDescription)
//                self.errorMessage = error.localizedDescription
//                self.registrationState = .failed(error)
//                return
//            }
//            print("was registered", wasRegistered)
//            self.registrationState = .loaded
//        }
//    }
}
