//
//  ContactViewModel.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import Foundation

protocol CreateContactViewModelDelegate: AnyObject {
    func contactViewModelDidRequestAddNewContact(_ contact: ContactData)
}

protocol UpdateContactViewModelDelegate: AnyObject {
    func contactViewModelDidRequestUpdateContact(_ contact: ContactData)
    func contactsViewModelDidRequestDeleteContact(_ contact: ContactData)
}

final class ContactViewModel {
    weak var createDelegate: CreateContactViewModelDelegate?
    weak var updateDelegate: UpdateContactViewModelDelegate?
    let contact: ContactData?
    private let maxNumberCount = 11
    
    init(with contact: ContactData?) {
        self.contact = contact
    }
    
    func addContact(_ contact: ContactData) {
        createDelegate?.contactViewModelDidRequestAddNewContact(contact)
    }
    
    func updateContact(_ contact: ContactData) {
        updateDelegate?.contactViewModelDidRequestUpdateContact(contact)
    }
    
    func deleteContact() {
        guard let contact = contact else { return }
        updateDelegate?.contactsViewModelDidRequestDeleteContact(contact)
    }
    
    func formatNumber(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else {return "+"}
        var number = phoneNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        if number.count > maxNumberCount {
            let endIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<endIndex])
        }
        
        if shouldRemoveLastDigit {
            let endIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<endIndex])
        }
        
        let regRange = number.startIndex..<number.index(number.startIndex, offsetBy: number.count)
        
        if number.count < 7 {
            number = number.replacingOccurrences(of: "(\\d{2})(\\d{2})(\\d+)",
                                                 with: "$1-$2-$3",
                                                 options: .regularExpression, range: regRange)
        } else if number.count < 8 {
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{2})(\\d+)",
                                                 with: "$1-$2-$3",
                                                 options: .regularExpression, range: regRange)
        } else {
            number = number.replacingOccurrences(of: "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)",
                                                 with: "+$1 ($2) $3-$4-$5",
                                                 options: .regularExpression, range: regRange)
        }
        return number
    }
}
