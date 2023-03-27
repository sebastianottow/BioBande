//
//  CustomTextField.swift
//  FoodMeMVP_SO
//
//  Created by Sebastian Ottow on 27.03.23.
//

import UIKit

class CustomTextField: UITextField {

    enum Constants {
        static let textColor = UIColor.systemIndigo
        static let activeTextColor = UIColor.systemBlue

        static let iconColor = UIColor.systemBlue
        static let activeIconColor = UIColor.systemIndigo
        
        static let defaultColor = UIColor.lightGray

    }
    
    let padding = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)

    private var _textColor: UIColor {
        if text!.isEmpty {
            return Constants.textColor
        }

        if isEditing {
            return Constants.activeTextColor
        }

        return Constants.defaultColor
    }

    private var _iconColor: UIColor {
        if isEnabled {
            return Constants.iconColor
        }

        return Constants.defaultColor
    }

    override public var isEnabled: Bool {
        didSet {
            textColor = _textColor
            tintColor = _iconColor
        }
    }

    // MARK: - Initalization --> beide methoden werden in Abhängigkeit voneinander benötigt!
    override public init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
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
        setupSubviews()
    }

//    func underlined(color: UIColor){
//            let border = CALayer()
//            let width = CGFloat(1.0)
//            border.borderColor = color.cgColor
//            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
//            border.borderWidth = width
//            self.layer.addSublayer(border)
//            self.layer.masksToBounds = true
//        }

    public func setupSubviews() {
        textColor = _textColor
    }
}
