//
//  ContactDetailTableViewCell.swift
//  PhoneBook
//
//  Created by SalemMacPro on 3.6.21.
//

import UIKit

class ContactDetailTableViewCell: UITableViewCell {
    
    static var identifier = "ContactDetailTableViewCell"
    
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.font = .base1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = .base2
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
       
    }
    
    func configure(title: String, description: String, textColor: UIColor) {
        titleLabel.text = title
        descriptionLabel.text = description
        descriptionLabel.textColor = textColor
    }
    
    private func setup() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.leading.equalTo(16)
            
        }
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel)
            make.bottom.equalTo(-9)
        }
    }
}
