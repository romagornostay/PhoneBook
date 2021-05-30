//
//  AddContactViewModel.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import Foundation

protocol AddContactViewModelDelegate: AnyObject {
    func addNewContact(_ contact: ContactData)
}

final class AddContactViewModel {
    weak var delegate: AddContactViewModelDelegate?
    
    func addContact(_ contact: ContactData) {
        delegate?.addNewContact(contact)
    }
}
