//
//  EditViewModel.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

protocol EditViewModelDelegate: AnyObject {
    func saveContact(_ contact: ContactData)
    
    func deleteContact(_ contact: ContactData)
}

final class EditViewModel {
    weak var delegate: EditViewModelDelegate?
    let contact: ContactData
    
    init(with contact: ContactData) {
        self.contact = contact
    }
    
    func saveContact(_ contact: ContactData) {
        delegate?.saveContact(contact)
    }
    func deleteContact() {
        delegate?.deleteContact(contact)
    }
    
}
