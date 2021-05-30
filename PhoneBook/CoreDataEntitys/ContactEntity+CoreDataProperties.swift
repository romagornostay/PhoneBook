//
//  ContactEntity+CoreDataProperties.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//
//

import Foundation
import CoreData


extension ContactEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactEntity> {
        return NSFetchRequest<ContactEntity>(entityName: "ContactEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var phone: String?
    @NSManaged public var ringtone: String?
    @NSManaged public var notes: String?

}

extension ContactEntity : Identifiable {

}
