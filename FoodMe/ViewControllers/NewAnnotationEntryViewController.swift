//
//  NewAnnotationEntryViewController.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 26.03.23.
//

import UIKit

class NewAnnotationEntryViewController: UIViewController {
    
    let dismissButton = UIButton()
//    let mapViewController = SearchAnnotationsViewController()
    
    private let _viewModel = NewEntryFormViewModel()
    
    
    private let _streetNameTextField = UITextField()
    private let _postalCodeTextField = UITextField()
    private let _cityTextField = UITextField()
    
    private let _scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let _formHolderStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .systemRed
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "ADD NEW ENTRY"
        
        let navigationBar = navigationController?.navigationBar
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = .darkGray
        navigationBarAppearance.backgroundColor = .systemIndigo
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        navigationBar?.scrollEdgeAppearance = navigationBarAppearance

        addDismissButton()

        let closeButton = UIBarButtonItem(customView: dismissButton)
        navigationItem.setRightBarButton(closeButton, animated: true)
        
        view.addSubview(_scrollView)
        
        _scrollView.addSubview(_formHolderStackView)
        _formHolderStackView.top(to: view, offset: 20)


        _formHolderStackView.addArrangedSubview(_streetNameTextField)
        _formHolderStackView.addArrangedSubview(_postalCodeTextField)
        _formHolderStackView.addArrangedSubview(_cityTextField)
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
