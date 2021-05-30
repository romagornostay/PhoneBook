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
    
    private let divider: UILabel = {
        let divider = UILabel()
        divider.layer.backgroundColor = UIColor.black.cgColor
        return divider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .base2
        label.textAlignment = .center
        label.font = .base3
        label.layer.masksToBounds = true
        return label
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 45
        //image.backgroundColor = .lightGray
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupNavigationItems()
    }
    
    private func setupLayout() {
        let currentContact = viewModel.contact
        image.image = currentContact.avatar
        nameLabel.text = currentContact.firstName + " " + currentContact.lastName
        phoneView.configure(title: "Phone", description: currentContact.phone)
        ringtoneView.configure(title: "Ringtone", description: currentContact.ringtone)
        notesView.configure(title: "Notes", description: currentContact.notes)
        
        view.addSubview(image)
        image.layer.masksToBounds = true
        image.snp.makeConstraints { make in
            make.topMargin.equalTo(20)
            make.width.height.equalTo(90)
            make.centerX.equalToSuperview()
            
        }
        
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(120)
            make.leading.trailing.equalToSuperview()
            
        }
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(nameLabel.snp.bottom).offset(1)
            make.leading.equalTo(16)
            make.trailing.equalToSuperview()

        }
        
        view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(3)
            make.leading.equalTo(16)
        }
        view.addSubview(ringtoneView)
        ringtoneView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(3)
            make.leading.equalTo(phoneView)
        }
        view.addSubview(notesView)
        notesView.snp.makeConstraints { make in
            make.top.equalTo(ringtoneView.snp.bottom).offset(3)
            make.leading.equalTo(ringtoneView)
        }
    }
    
    private func setupNavigationItems() {
        title = "Contact Details"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
    }
    
    @objc
    private func editTapped(){
        let currentContact = viewModel.contact
        viewModel.editContact(currentContact)
    }
}

