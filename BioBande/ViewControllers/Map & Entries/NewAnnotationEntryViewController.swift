//
//  NewAnnotationEntryViewController.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 26.03.23.
//

import Combine
import CombineCocoa
import FirebaseAuth
import MapKit
import RealmSwift
import UIKit


class NewAnnotationEntryViewController: UIViewController {
    
    private enum Constants {
        static let defaultIcon = UIImage(systemName: "square.and.pencil")
        static let dropDownArrowIcon = UIImage(systemName: "arrowtriangle.down.square")
        
        static let defaultColor = UIColor.systemIndigo
    }
    
    let realm = try! Realm()
    
    private let _categoryList = try! Realm().objects(CategoryModel.self).sorted(byKeyPath: "name", ascending: true)
    
    @Published var selectedEntryCategory: String?
    
    private let _viewModel = LocationViewModel()
    
    private var _cancellables: Set<AnyCancellable> = []
    
    private let _dismissButton = UIButton()
    private let _addNewEntryButton = UIButton()

    private let _isPrivateSwitch = UISwitch()

    private let _isPrivateSwitchLabel: UILabel = {
        let label = UILabel()

        label.text = "für alle Nutzer anzeigen"

        return label
    }()
    
    private let _dropDownEntryType = CustomDropDown()

    private lazy var _searchCompleter: MKLocalSearchCompleter = {
        let searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        return searchCompleter
    }()

    private var _searchDataList: [String]?
    
    private let _streetNameTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "Straße & Hausnummer..."
        
        textField.setIcon(icon: Constants.defaultIcon, color: Constants.defaultColor)
                
        return textField
    }()
    
    private let _postalCodeTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "Postleitzahl..."
        
        textField.setIcon(icon: Constants.defaultIcon, color: Constants.defaultColor)
        textField.isSelected = true
        
        return textField
    }()
    
    private let _cityTextField: CustomTextField = {
        let textField = CustomTextField()
        
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5
        textField.placeholder = "Stadt..."
        
        textField.setIcon(icon: Constants.defaultIcon, color: Constants.defaultColor)
        
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
    
    func setupPublishers() {
        
        _streetNameTextField.textPublisher
            .map { "\($0 ?? "")" }
            .assign(to: \.street , on: _viewModel)
            .store(in: &_cancellables)
        
        _postalCodeTextField.textPublisher
            .map { "\($0 ?? "")" }
            .assign(to: \.postalCode, on: _viewModel)
            .store(in: &_cancellables)
        
        _cityTextField.textPublisher
            .map { "\($0 ?? "")" }
            .assign(to: \.city, on: _viewModel)
            .store(in: &_cancellables)
        
        _viewModel.isAddNewEntryButtonEnabled
            .assign(to: \.isEnabled, on: _addNewEntryButton)
            .store(in: &_cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupPublishers()
        
        _dropDownEntryType.$selectedValue
            .receive(on: DispatchQueue.main)
            .sink { value in
                self.selectedEntryCategory = value
            }
            .store(in: &_cancellables)

        _isPrivateSwitch.addTarget(self, action: #selector(onToggleIsPrivateSwitch), for: .valueChanged)
        _isPrivateSwitch.setOn(false, animated: false)
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "ADD NEW ENTRY"
        
        let navigationBar = navigationController?.navigationBar
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.shadowColor = .darkGray
        navigationBarAppearance.backgroundColor = Constants.defaultColor
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        navigationBar?.scrollEdgeAppearance = navigationBarAppearance
        
        addDismissButton()
        
        let closeButton = UIBarButtonItem(customView: _dismissButton)
        navigationItem.setRightBarButton(closeButton, animated: true)
        
        view.addSubview(_scrollView)
        _scrollView.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        _scrollView.bottomToSuperview(usingSafeArea: true)
        _scrollView.topToSuperview(usingSafeArea: true)
        
        _scrollView.addSubview(_formHolderStackView)
        _formHolderStackView.edgesToSuperview(excluding: [.bottom], insets: .init(top: 10, left: 0, bottom: 0, right: 0))
        _formHolderStackView.width(to: _scrollView)
        
        _dropDownEntryType.createPickerView()
        _formHolderStackView.addArrangedSubview(_dropDownEntryType)
        _dropDownEntryType.selectionList = _categoryList.map { $0.name }
        _dropDownEntryType.placeholder = "Kategorie auswählen"
        _dropDownEntryType.setIcon(icon: Constants.dropDownArrowIcon, color: Constants.defaultColor)
        
        _formHolderStackView.addArrangedSubview(_streetNameTextField)
        
        _formHolderStackView.addArrangedSubview(_postalCodeTextField)
        _formHolderStackView.addArrangedSubview(_cityTextField)

        let switchHolderView = UIView()
        switchHolderView.layer.cornerRadius = 5
        switchHolderView.layer.borderWidth = 1
        switchHolderView.layer.borderColor = UIColor.lightGray.cgColor

        switchHolderView.addSubview(_isPrivateSwitchLabel)
        _isPrivateSwitchLabel.edgesToSuperview(excluding: .right, insets: .init(top: 8, left: 15, bottom: 8, right: 0))
        switchHolderView.addSubview(_isPrivateSwitch)
        _isPrivateSwitch.edgesToSuperview(excluding: .left, insets: .init(top: 8, left: 0, bottom: 8, right: 10))

        _formHolderStackView.addArrangedSubview(switchHolderView)

        addAddNewEntryButton()
        _scrollView.addSubview(_addNewEntryButton)
        _addNewEntryButton.bottomToSuperview(offset: -25, usingSafeArea: true)
        _addNewEntryButton.edgesToSuperview(excluding: [.top, .bottom], insets: .init(top: 0, left: 10, bottom: 0, right: 10))
        
        _scrollView.contentInset = .init(top: 10, left: 0, bottom: 20, right: 0)
    }
    
    private func addAddNewEntryButton() {
        _addNewEntryButton.configuration = .filled()
        _addNewEntryButton.configuration?.baseForegroundColor = .white
        _addNewEntryButton.configuration?.baseBackgroundColor = Constants.defaultColor
        _addNewEntryButton.setTitle("Add new Entry", for: .normal)
        _addNewEntryButton.configuration?.cornerStyle = .capsule
        _addNewEntryButton.translatesAutoresizingMaskIntoConstraints = false
        
        _addNewEntryButton.isEnabled = false
        
        _addNewEntryButton.addTarget(
            self,
            action: #selector(saveNewEntry),
            for: .touchUpInside
        )
    }
    
    private func addDismissButton() {
        _dismissButton.configuration = .filled()
        _dismissButton.configuration?.baseForegroundColor = .systemGray
        _dismissButton.configuration?.baseBackgroundColor = .white
        _dismissButton.configuration?.image = UIImage(
            systemName: "xmark.circle",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .ultraLight
            )
        )
        _dismissButton.configuration?.cornerStyle = .capsule
        
        _dismissButton.isEnabled = true
        
        _dismissButton.addTarget(
            self,
            action: #selector(hideMapDetailViewController),
            for: .touchUpInside
        )
    }
    
    private func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = Constants.defaultColor
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        controller.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    @objc func saveNewEntry(sender: UIButton) {
        let entryID = UUID().uuidString
        guard let userID = Auth.auth().currentUser?.uid, let selectedCategory = selectedEntryCategory else { return }

            _viewModel.forwardGeocoding(
                        street: _viewModel.street,
                        postalCode: _viewModel.postalCode,
                        city: _viewModel.city) { [weak self] wasConverted, error in

                            if let error = error {
                                print("\(error)")

                                self?.showToast(controller: self!, message: "Wir konnten deine Adresse leider nicht finden!", seconds: 3)

                                return
                            }

                            if wasConverted {

                                let newAnnotationEntry = LocationModel(
                                    userID: userID,
                                    isPrivate: self?._viewModel.isPrivate ?? false,
                                    entryType: selectedCategory,
                                    street: self?._viewModel.street ?? "",
                                    postalCode: self?._viewModel.postalCode ?? "",
                                    city: self?._viewModel.city ?? "",
                                    id: entryID,
                                    longCoord: self?._viewModel.longCoord ?? 0.0,
                                    latCoord: self?._viewModel.latCoord ?? 0.0
                                )

                                self?._viewModel.annotationServices.saveAnnotationToDB(with: newAnnotationEntry)

                                self?.resetInputFields()

                                self?.showToast(controller: self!, message: "Entry successfully added!", seconds: 3)

                            } else {
                                print("irgendwas lief falsch!")
                            }

                        }
    }

    private func resetInputFields() {

        _dropDownEntryType.text?.removeAll()
        _streetNameTextField.text?.removeAll()
        _postalCodeTextField.text?.removeAll()
        _isPrivateSwitch.isOn = false
        _cityTextField.text?.removeAll()

    }

    @objc func onToggleIsPrivateSwitch(_ sender: UISwitch) {
        if sender.isOn == true {
            _viewModel.isPrivate = true
        } else {
            _viewModel.isPrivate = false
        }
    }
    
    @objc func hideMapDetailViewController(sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension NewAnnotationEntryViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self._searchDataList = completer.results.map { $0.title }
        DispatchQueue.main.async {
//            self.tableView.reloadData()
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

}
