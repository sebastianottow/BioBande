//
//  LoginViewController.swift
//  FoodMe
//
//  Created by Sebastian Ottow on 20.03.23.
//

import UIKit
import TinyConstraints

class HomeViewController: UIViewController {
        
    private let _accessMapButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setTitle("show Map", for: .normal)
        button.backgroundColor = .systemRed
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor

        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupUI()
        
        view.addSubview(_accessMapButton)
        
        _accessMapButton.centerXToSuperview()
        _accessMapButton.centerYToSuperview(offset: 100)
        _accessMapButton.addTarget(self, action: #selector(self.navigateToMapViewController), for: .touchUpInside)
        
        AuthServices.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            
            if let error = error {
                AlertManager.showFetchingUserError(on: self, with: error)
                return
            }
            
            if let user = user {
                print("\(user.email)\n\(user.username)\n\(user.userUID)")
            }
        }
    }
    
    private func setupUI() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(didTapLogout))
    }
    
    @objc func didTapLogout() {
        AuthServices.shared.signOut { [weak self] error in
            guard let self = self else { return }
            
            if let error = error {

                let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
                    alert.view.alpha = 0.6
                    alert.view.layer.cornerRadius = 15
                    
                    present(alert, animated: true)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                        alert.dismiss(animated: true)
                    }
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as?
                SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
    
    @objc func navigateToMapViewController(_ sender: UIButton) {
        let mapViewController = MapViewController()
        navigationController?.pushViewController(mapViewController, animated: true)
    }
}
