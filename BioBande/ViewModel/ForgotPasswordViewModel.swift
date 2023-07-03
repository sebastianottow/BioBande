//
//  ForgotPasswordViewModel.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 09.06.23.
//

import Foundation
import UIKit

class ForgotPasswordViewModel {
    
    enum RegistrationState {
        case isLoading
        case failed(Error)
        case loaded
    }
    
    @Published var registrationState: RegistrationState = .isLoading
    
    @Published var emailaddress: String = ""
}
