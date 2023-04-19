//
//  CustomDropDown.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 18.04.23.
//

import UIKit
import Combine

class CustomDropDown: UITextField, UITextFieldDelegate {
    
    @Published var selectedValue: String?
    
    var selectionList = [String?]()
    
    let padding = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)
        
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        inputView = pickerView
        
        setupUI()
    }
    
    func setIcon(icon: UIImage?, color: UIColor?) {
        let iconView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = icon
        iconView.tintColor = color

        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)

        leftView = iconContainerView
        leftViewMode = .always
    }
    
    private func setupUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5
        tintColor = UIColor.clear
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}

extension CustomDropDown: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectionList.count
    }
}

extension CustomDropDown: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectionList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedValue = selectionList[row]
        
        text = selectedValue
    }
}
