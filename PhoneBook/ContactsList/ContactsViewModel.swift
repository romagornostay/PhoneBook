//
//  ContactsViewModel.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

struct Model {
    let character: String
    var contacts: [ContactData]
}

protocol ContactsViewModelDelegate: AnyObject {
    func showContactDetails(_ contact: ContactData)
    
    func addContact()
}

final class ContactsViewModel {
    private let manager = CoreDataManager()
    
    weak var delegate: ContactsViewModelDelegate?
    
    //var savedEntities: [ContactEntity] = []
    
    var models: [Model] = []
    
    var contactsDict = [String: [ContactData]]()
    var contactsSectionTitles = [String]()
    
    
    func showContactDetails(for contact: ContactData) {
        delegate?.showContactDetails(contact)
    }
    
    func openViewAddContact() {
        delegate?.addContact()
    }
    
    func addContact(_ contact: ContactData) {
        manager.addEntity(with: contact)
    }
    
    func updateContact(_ contact: ContactData) {
        manager.updateEntity(with: contact)
    }
    
    func deleteContact(_ contact: ContactData) {
        manager.deleteEntity(with: contact)
    }
    
    func obtainContactsList() {
        manager.fetchUsers()
        //savedEntities = manager.savedEntities
        contactsDict = [:]
        createContactsDict()
    }
    
    func createContactsDict() {
        for entity in manager.savedEntities {
            var character = ""
            let contact = manager.convertEntityToContact(by: entity)
            if let lastName = contact.lastName , !contact.lastName!.isEmpty {
                let firstLetterIndex = lastName.index(lastName.startIndex, offsetBy: 1)
                character = String(lastName[..<firstLetterIndex])
            }  else if let firstName = contact.firstName, !contact.firstName!.isEmpty {
                let firstLetterIndex = firstName.index(firstName.startIndex, offsetBy: 1)
                character = String(firstName[..<firstLetterIndex])
            }
            
            if var contactValues = contactsDict[character] {
                contactValues.append(contact)
                contactsDict[character] = contactValues
            } else {
                contactsDict[character] = [contact]
            }
            for var model in models {
                if model.character == character {
                    model.contacts.append(contact)
                } else {
                    let newModel = Model(character: character, contacts: [contact])
                    models.append(newModel)
                }
                
            }
            
        }
        contactsSectionTitles = [String](contactsDict.keys)
        contactsSectionTitles = contactsSectionTitles.sorted(by: { $0 < $1 })
    }
}

