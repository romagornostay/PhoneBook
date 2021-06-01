//
//  ContactsTableViewCell.swift
//  PhoneBook
//
//  Created by SalemMacPro on 1.6.21.
//

import UIKit
import SnapKit

class ContactsTableViewCell: UITableViewCell {
    
    var firstNameLabel: UILabel = {
        let label = UILabel()
        //label.textAlignment = .center
        label.font = .base2
        //label.layer.masksToBounds = true
        //label.adjustsFontSizeToFitWidth = true
        return label
    }()
    var lastNameLabel: UILabel = {
        let label = UILabel()
       // label.textAlignment = .center
        label.font = .base5
        //label.layer.masksToBounds = true
        //label.adjustsFontSizeToFitWidth = true
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
            make.leading.top.equalToSuperview()
        }
        addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstNameLabel.snp.trailing)
            make.top.bottom.equalToSuperview()
        }
    }
    
}
