//
//  ViewController.swift
//  FoodMe
//
//  Created by Sebastian Ottow on 20.03.23.
//

import UIKit
import TinyConstraints


class ViewController: UIViewController {
        
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
        
        view.addSubview(_accessMapButton)
        
        _accessMapButton.centerXToSuperview()
        _accessMapButton.centerYToSuperview(offset: 100)
        _accessMapButton.addTarget(self, action: #selector(self.navigateToMapViewController), for: .touchUpInside)
    }
    
    @objc func navigateToMapViewController(_ sender: UIButton) {
        let mapViewController = MapViewController()
        navigationController?.pushViewController(mapViewController, animated: true)
    }
}
