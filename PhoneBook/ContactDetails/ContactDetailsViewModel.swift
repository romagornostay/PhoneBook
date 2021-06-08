//
//  ContactDetailsViewModel.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

protocol ContactDetailsViewModelDelegate: AnyObject {
    func contactDetailsViewModelDidRequestEditContact(_ contact: ContactData)
}

final class ContactDetailsViewModel {
    
    weak var delegate: ContactDetailsViewModelDelegate?
    let contact: ContactData
    
    init(with contact: ContactData) {
        self.contact = contact
        
    }
    
    func editContact(_ contact: ContactData) {
        delegate?.contactDetailsViewModelDidRequestEditContact(contact)
    }
    
}
