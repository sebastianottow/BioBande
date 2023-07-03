//
//  LocationSearchView.swift
//  BioBande
//
//  Created by Sebastian Ottow on 03.07.23.
//

import Foundation
import CoreLocation
import Combine
import CombineCocoa
import UIKit


class LocationSearchView: UIView {

    private let _viewModel = LocationViewModel()

    private let _searchTextField = CustomAuthTextField(fieldType: .search)

    private let _resultListTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "resultCell")
        return table
    }()

    private var locations = [Location]()

    private var _cancellables: Set<AnyCancellable> = []

    func loadLocationSearchView() {

        backgroundColor = .white

        setupUI()

        _searchTextField.delegate = self
    }

    private func setupUI() {
        addSubview(_searchTextField)
        _searchTextField.height(55)
        _searchTextField.edgesToSuperview(excluding: [.bottom], insets: .init(top: 10, left: 10, bottom: 0, right: 10))

        addSubview(_resultListTableView)
        _resultListTableView.delegate = self
        _resultListTableView.dataSource = self
        _resultListTableView.edgesToSuperview(excluding: [.top], insets: .init(top: 0, left: 10, bottom: 10, right: 10))
        _resultListTableView.topToBottom(of: _searchTextField, offset: 5)
        _resultListTableView.backgroundColor = .secondarySystemBackground
        _resultListTableView.layer.cornerRadius = 10
    }
}

extension LocationSearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        _resultListTableView.resignFirstResponder()
        if let value = _searchTextField.text, !value.isEmpty {
            CustomLocationManager.shared.findLocations(with: value) { [weak self] locations in
                DispatchQueue.main.async {
                    self?.locations = locations
                    self?._resultListTableView.reloadData()
                }
            }
        }
        return true
    }
}

extension LocationSearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = _resultListTableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath)
        cell.backgroundColor = .secondarySystemBackground

        var configuration = cell.defaultContentConfiguration()
        configuration.text = locations[indexPath.row].title
        configuration.textProperties.numberOfLines = 0
        configuration.makeContentView().backgroundColor = .secondarySystemBackground

        cell.contentConfiguration = configuration

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _resultListTableView.deselectRow(at: indexPath, animated: true)

        let coordinate = locations[indexPath.row].coordinates

        _resultListTableView.didSelectRowPublisher
            .map { _ in coordinate }
            .assign(to: \.locationSearchResultCoordinates, on: _viewModel)
            .store(in: &_cancellables)
    }
}
