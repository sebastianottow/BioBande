//
//  LoginUserViewModel.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 15.05.23.
//

import Foundation
import UIKit

class LoginUserViewModel {
    
    enum RegistrationState {
        case isLoading
        case failed(Error)
        case loaded
    }
    
    @Published var registrationState: RegistrationState = .isLoading
    
    @Published var username: String = ""
    @Published var emailaddress: String = ""
    @Published var userpassword: String = ""
}
