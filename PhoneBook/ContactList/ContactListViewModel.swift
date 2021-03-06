//
//  ContactListViewModel.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit


protocol ContactListViewModelDelegate: AnyObject {
    func contactListViewModelDidRequestShowContactDetails(_ contact: ContactData)
    func contactListViewModelDidRequestAddContact()
}

final class ContactListViewModel {
    private let manager = CoreDataManager()
    weak var delegate: ContactListViewModelDelegate?
    var models: [ContactsModel] = []
    var contactsSectionTitles = [String]()
    var onDidUpdateData: (() -> Void)?
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        var filteredContacts = [ContactData]()
        filteredContacts = manager.savedContacts.filter({text.isEmpty ? true : "\($0)".lowercased().contains(text.lowercased())})
        filteredContacts = filteredContacts.sorted(by: { $0.lastName < $1.lastName })
        if text.isEmpty {
            models.removeAll()
            contactsSectionTitles.removeAll()
            createModels()
        } else {
            models.removeAll()
            contactsSectionTitles.removeAll()
            contactsSectionTitles = ["TOP NAME MATCHES"]
            if let character = contactsSectionTitles.first {
            models = [ContactsModel(character: character, contacts: filteredContacts)]
            }
        }
        onDidUpdateData?()
    }
    
    func showContactDetails(for contact: ContactData) {
        delegate?.contactListViewModelDidRequestShowContactDetails(contact)
    }
    
    func addContact() {
        delegate?.contactListViewModelDidRequestAddContact()
    }
    
    func addContact(_ contact: ContactData) {
        manager.addEntity(with: contact)
        createModels()
        onDidUpdateData?()
    }
    
    func updateContact(_ contact: ContactData) {
        manager.updateEntity(with: contact)
        createModels()
        onDidUpdateData?()
    }
    
    func deleteContact(_ contact: ContactData) {
        manager.deleteEntity(with: contact)
        createModels()
        onDidUpdateData?()
    }
    
    func createModels() {
        let set = Set(manager.savedContacts.map {$0.lastName.first})
        models = set.map { letter -> ContactsModel in
            var character = ""
            if let char = letter {
                character = String(describing: char)
            }
            var contacts = manager.savedContacts.filter {$0.lastName.first == letter}
            contacts = contacts.sorted(by: { $0 < $1 })
            let model = ContactsModel(character: character, contacts: contacts)
            return model
        }
        
        contactsSectionTitles = [String](models.compactMap { $0.character })
        contactsSectionTitles = contactsSectionTitles.sorted(by: { $0 < $1 })
    }
}

