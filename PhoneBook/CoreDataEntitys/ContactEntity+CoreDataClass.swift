//
//  ContactEntity+CoreDataClass.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//
//

import UIKit
import CoreData

@objc(ContactEntity)
public class ContactEntity: NSManagedObject {
    lazy var image: UIImage? = {
        if let id = id?.uuidString {
            return try? storage?.image(forKey: id)
        }
        return nil
    }()
    
    var storage: ImageStorage?
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }
    
    override public func didSave() {
        super.didSave()
        
        if let image = image, let id = id?.uuidString {
            try? storage?.setImage(image, forKey: id)
        }
    }
}
