//
//  ContactDetailView.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

//class ContactDetailView: UIView {
//    private let titleLabel: UILabel = {
//        var label = UILabel()
//        label.font = .base1
//        return label
//    }()
//    
//    private let descriptionLabel: UILabel = {
//        var label = UILabel()
//        label.font = .base2
//        return label
//    }()
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    func configure(title: String, description: String) {
//        titleLabel.text = title
//        descriptionLabel.text = description
//    }
//    
//    private func setup() {
//        addSubview(titleLabel)
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(6)
//            make.leading.equalToSuperview()
//            
//        }
//        addSubview(descriptionLabel)
//        descriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(titleLabel.snp.bottom).offset(2)
//            make.leading.equalTo(titleLabel)
//            make.bottom.equalToSuperview()
//        }
//    }
//}
//
