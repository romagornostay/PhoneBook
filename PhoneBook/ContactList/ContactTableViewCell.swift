//
//  ContactTableViewCell.swift
//  PhoneBook
//
//  Created by SalemMacPro on 1.6.21.
//

import UIKit
import SnapKit

class ContactTableViewCell: UITableViewCell {
    
    static var identifier = String(describing: ContactTableViewCell.self)
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.font = .base2
        return label
    }()
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = .base4
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(_ withFirstName: String?, _ andLastName: String?) {
        firstNameLabel.text = withFirstName
        lastNameLabel.text = andLastName
    }
    
    private func setupLayout() {
        addSubview(firstNameLabel)
        firstNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(16)
            make.bottom.equalTo(-16)
        }
        addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstNameLabel.snp.trailing).inset(-5)
            make.top.bottom.equalToSuperview()
        }
    }
    
}
