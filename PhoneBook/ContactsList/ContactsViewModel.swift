//
//  ContactsViewModel.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

protocol ContactsViewModelDelegate: AnyObject {
    func showContactDetails(_ contact: ContactData)
    
    func addContact()
}

final class ContactsViewModel {
    private let manager = CoreDataManager()
    weak var delegate: ContactsViewModelDelegate?
    var savedEntities: [ContactEntity] = []
    
    func showContactDetails(for entity: ContactEntity) {
        let contact = manager.convertEntityToContact(by: entity)
        delegate?.showContactDetails(contact)
    }
    func openViewAddContact() {
        delegate?.addContact()
    }
    func addContact(_ contact: ContactData) {
        manager.addEntity(with: contact)
        print("1--add1:---\(savedEntities)")
    }
    func updateContact(_ contact: ContactData) {
        manager.updateEntity(with: contact)
        print("1--update1:---\(savedEntities)")
    }
    func deleteContact(_ contact: ContactData) {
        manager.deleteEntity(with: contact)
        print("1--delete1:---\(savedEntities)")
    }
    
    func obtainContacts() {
        manager.fetchUsers()
        savedEntities = manager.savedEntities
    }
}

