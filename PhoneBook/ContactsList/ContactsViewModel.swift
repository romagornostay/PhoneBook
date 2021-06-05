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
    var models: [Model] = []
    //var contactsDict = [String: [ContactData]]()
    var contactsSectionTitles = [String]()
    var onDidUpdateData: (() -> Void)?
    
    func updateSearchResults(for searchController: UISearchController) {
        //print("----SEARCHING...---")
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
            models = [Model(character: character, contacts: filteredContacts)]
            }
        }
        onDidUpdateData?()
    }
    
    func showContactDetails(for contact: ContactData) {
        delegate?.showContactDetails(contact)
    }
    
    func openViewAddContact() {
        delegate?.addContact()
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
        //let arrayOfFirstLetter = manager.savedContacts.map {$0.lastName.first}
        let set = Set(manager.savedContacts.map {$0.lastName.first})
        models = set.map { letter -> Model in
            var character = ""
            if let char = letter {
                character = String(describing: char)
            }
            let contacts = manager.savedContacts.filter {$0.lastName.first == letter}
            let model = Model(character: character, contacts: contacts)
            return model
        }
        contactsSectionTitles = [String](models.compactMap { $0.character })
        contactsSectionTitles = contactsSectionTitles.sorted(by: { $0 < $1 })
        print("---1---\(contactsSectionTitles)")
    }
}

