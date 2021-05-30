//
//  CoreDataManager.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit
import CoreData

final class CoreDataManager {
    private let container: NSPersistentContainer
    private let imageStorage = try! ImageStorage(name: "CoreDataImages")
    var savedEntities: [ContactEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "ContactContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR LOADING CORE DATA. \(error)")
            } else {
                print("Successfuly loaded core data!!!")
            }
        }
        fetchUsers()
    }
    
    
    func fetchUsers () {
        let request = NSFetchRequest<ContactEntity>(entityName: "ContactEntity")
        do {
            savedEntities =  try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
    }
    
    func addEntity(with contact: ContactData) {
        let newUser = insert(ContactEntity.self, into: container.viewContext)
        newUser.storage = imageStorage
        
        newUser.firstName = contact.firstName
        newUser.lastName = contact.lastName
        newUser.phone = contact.phone
        newUser.ringtone = contact.ringtone
        newUser.notes = contact.notes
        newUser.image = contact.avatar
        saveContext()
    }
    
    func convertEntityToContact(by entity: ContactEntity) -> ContactData {
        entity.storage = imageStorage
        let contact = ContactData(id: entity.id,
                                  firstName: entity.firstName!,
                                  lastName: entity.lastName!,
                                  phone: entity.phone!,
                                  ringtone: entity.ringtone!,
                                  notes: entity.notes!,
                                  avatar: entity.image)
        return contact
    }
    
    func updateEntity(with contact: ContactData) {
        for entity in savedEntities {
            if entity.id == contact.id {
                entity.image = contact.avatar
                entity.firstName = contact.firstName
                entity.lastName = contact.lastName
                entity.phone = contact.phone
                entity.ringtone = contact.ringtone
                entity.notes = contact.notes
            }
        }
        saveContext()
    }
    
    func deleteEntity(with contact: ContactData) {
        for entity in savedEntities {
            if entity.id == contact.id {
                container.viewContext.delete(entity)
            }
        }
        saveContext()
    }
    
    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
                fetchUsers()
            } catch let error {
                print("Error saving. \(error)")
            }
        }
    }
    
    private func insert<T>(_ type: T.Type, into context: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as! T
    }
}
