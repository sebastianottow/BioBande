//
//  MapDetailViewController.swift
//  FoodMe
//
//  Created by Sebastian Ottow on 24.03.23.
//

import UIKit

class MapDetailViewController: UIViewController {
    
    let dismissButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "FOODFINDER"
        
        let navigationBar = navigationController?.navigationBar
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = .darkGray
        navigationBarAppearance.backgroundColor = .systemIndigo
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        navigationBar?.scrollEdgeAppearance = navigationBarAppearance

        addDismissButton()

        let closeButton = UIBarButtonItem(customView: dismissButton)
        navigationItem.setRightBarButton(closeButton, animated: true)
    }
    
    private func addDismissButton() {
        dismissButton.configuration = .filled()
        dismissButton.configuration?.baseForegroundColor = .systemGray
        dismissButton.configuration?.baseBackgroundColor = .white
        dismissButton.configuration?.image = UIImage(
            systemName: "xmark.circle",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .ultraLight
            )
        )
        dismissButton.configuration?.cornerStyle = .capsule

        dismissButton.isEnabled = true

        dismissButton.addTarget(
            self,
            action: #selector(hideMapDetailViewController),
            for: .touchUpInside
        )
    }
    
    @objc func hideMapDetailViewController(sender: UIButton) {
        self.dismiss(animated: true)
    }
}
