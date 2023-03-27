//
//  NewAnnotationEntryViewController.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 26.03.23.
//

import UIKit

class NewAnnotationEntryViewController: UIViewController {

    private enum Constants {
        static let defaultIcon = UIImage(systemName: "square.and.pencil")
    }

    let dismissButton = UIButton()
    
    private let _viewModel = NewEntryFormViewModel()

    private let _streetNameTextField: CustomTextField = {
        let textField = CustomTextField()

        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "Straße & Hausnummer..."
        
        textField.setIcon(icon: Constants.defaultIcon, color: .lightGray)

        return textField
    }()

    private let _postalCodeTextField: CustomTextField = {
        let textField = CustomTextField()

        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "Postleitzahl..."

        textField.setIcon(icon: Constants.defaultIcon, color: .lightGray)
        textField.isSelected = true

        return textField
    }()

    private let _cityTextField: CustomTextField = {
        let textField = CustomTextField()

        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "Stadt..."

        textField.setIcon(icon: Constants.defaultIcon, color: .lightGray)

        return textField
    }()
    
    private let _scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let _formHolderStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        
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
        _scrollView.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        _scrollView.bottomToSuperview(usingSafeArea: true)
        _scrollView.topToSuperview(usingSafeArea: true)

        _scrollView.addSubview(_formHolderStackView)
        _formHolderStackView.edgesToSuperview(excluding: [.top, .bottom])
        _formHolderStackView.width(to: _scrollView)

        _formHolderStackView.addArrangedSubview(_streetNameTextField)

        _formHolderStackView.addArrangedSubview(_postalCodeTextField)
        _formHolderStackView.addArrangedSubview(_cityTextField)

        _scrollView.contentInset = .init(top: 10, left: 0, bottom: 20, right: 0)
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
