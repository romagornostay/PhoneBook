//
//  ContactDetailsViewController.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    
    private let viewModel: ContactDetailsViewModel
    
    
    init(viewModel: ContactDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let phoneView = ContactDetailView()
    private let ringtoneView = ContactDetailView()
    private let notesView = ContactDetailView()
    
    private let divider1 = UILabel()
    private let divider2 = UILabel()
    private let divider3 = UILabel()
       
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .base3
        label.layer.masksToBounds = true
        return label
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 45
        return image
    }()
    
    private let extendedView: UIView = {
        let view = UIView()
        view.backgroundColor = .base2
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationItems()
    }
    
    private func setupLayout() {
        let currentContact = viewModel.contact
        image.image = currentContact.avatar
        nameLabel.text = currentContact.firstName! + " " + currentContact.lastName!
        phoneView.configure(title: LocalizationConstants.ContactDetails.phone, description: currentContact.phone)
        ringtoneView.configure(title: LocalizationConstants.ContactDetails.ringtone, description: currentContact.ringtone)
        notesView.configure(title: LocalizationConstants.ContactDetails.notes, description: currentContact.notes)
        
        view.addSubview(extendedView)
        extendedView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        extendedView.addSubview(image)
        image.layer.masksToBounds = true
        image.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.width.height.equalTo(90)
            make.centerX.equalToSuperview()
            
        }
        
        extendedView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(200)
            make.leading.trailing.equalToSuperview()
        }
        
        view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(extendedView.snp.bottom).offset(3)
            make.leading.equalTo(16)
        }
        
        view.addSubview(divider1)
        divider1.layer.backgroundColor = UIColor.base1.cgColor
        divider1.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(phoneView.snp.bottom).offset(1)
            make.leading.equalTo(16)
            make.trailing.equalToSuperview()
        }
        
        view.addSubview(ringtoneView)
        ringtoneView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(10)
            make.leading.equalTo(phoneView)
        }
        
        view.addSubview(divider2)
        divider2.layer.backgroundColor = UIColor.base1.cgColor
        divider2.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(ringtoneView.snp.bottom).offset(1)
            make.leading.equalTo(16)
            make.trailing.equalToSuperview()
        }
        
        view.addSubview(notesView)
        notesView.snp.makeConstraints { make in
            make.top.equalTo(ringtoneView.snp.bottom).offset(10)
            make.leading.equalTo(ringtoneView)
        }
        
        view.addSubview(divider3)
        divider3.layer.backgroundColor = UIColor.base1.cgColor
        divider3.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(notesView.snp.bottom).offset(1)
            make.leading.equalTo(16)
            make.trailing.equalToSuperview()

        }
    }
    
    private func setupNavigationItems() {
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
    }
    
    @objc
    private func editTapped(){
        let currentContact = viewModel.contact
        viewModel.editContact(currentContact)
    }
}

