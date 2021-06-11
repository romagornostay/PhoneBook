//
//  ContactData.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit


struct ContactData: Comparable {
    static func < (lhs: ContactData, rhs: ContactData) -> Bool {
        lhs.lastName < rhs.lastName
    }
    
    let id: UUID?
    var firstName: String?
    var lastName: String
    var phone: String?
    var ringtone: String?
    var notes: String?
    var avatar: UIImage?
}
