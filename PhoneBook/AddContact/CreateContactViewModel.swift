//
//  CreateContactViewModel.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import Foundation

protocol CreateContactViewModelDelegate: AnyObject {
    func addNewContact(_ contact: ContactData)
}

protocol UpdateContactViewModelDelegate: AnyObject {
    func updateContact(_ contact: ContactData)
    
    func deleteContact(_ contact: ContactData)
}

final class CreateContactViewModel {
    weak var createDelegate: CreateContactViewModelDelegate?
    weak var updateDelegate: UpdateContactViewModelDelegate?
    let contact: ContactData?
    
    init(with contact: ContactData?) {
        self.contact = contact
    }
    
    func addContact(_ contact: ContactData) {
        createDelegate?.addNewContact(contact)
    }
    
    func updateContact(_ contact: ContactData) {
        print("SAVE_VM")
        updateDelegate?.updateContact(contact)
    }
    func deleteContact() {
        guard let contact = contact else { return }
        updateDelegate?.deleteContact(contact)
    }
}

extension String {

    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: self)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
