//
//  ContactSomeDetailCellView.swift
//  PhoneBook
//
//  Created by SalemMacPro on 10.6.21.
//

import UIKit

class ContactSomeDetailCellView: UIView {
    let titleLabel: UILabel = {
        var label = UILabel()
        label.font = .base1
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type here..."
        textField.backgroundColor = .white
        textField.returnKeyType = .next
        return textField
    }()
    
    private let divider1 = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalToSuperview()
            
        }
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
        }
        addSubview(divider1)
        divider1.layer.backgroundColor = UIColor.base1.cgColor
        divider1.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(9)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
