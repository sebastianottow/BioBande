//
//  LocationSearchViewController.swift
//  BioBande
//
//  Created by Sebastian Ottow on 03.07.23.
//

import Foundation
import CoreLocation
import UIKit


class LocationSearchViewController: UIViewController {

    var locationSearchView = LocationSearchView()

    private let _label: UILabel = {
        let label = UILabel()

        label.text = "Where to?"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.backgroundColor = .systemGreen
        label.textColor = .white
        label.textAlignment = .center

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupUI()
    }

    private func setupUI() {
        view.addSubview(_label)
        _label.height(55)
        _label.edgesToSuperview(excluding: .bottom, insets: .init(top: 0, left: 0, bottom: 0, right: 0))

        locationSearchView.loadLocationSearchView()
        view.addSubview(locationSearchView)
        locationSearchView.topToBottom(of: _label, offset: 10)
        locationSearchView.edgesToSuperview(excluding: .top, insets: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
}
