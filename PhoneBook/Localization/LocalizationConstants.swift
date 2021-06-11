//
//  LocalizationConstants.swift
//  PhoneBook
//
//  Created by SalemMacPro on 1.6.21.
//

import Foundation

struct LocalizationConstants {
    
    struct ContactList {
        static let title = NSLocalizedString("CONTACTS.TITLE", comment: "")
    }
    
    struct ContactDetails {
        static let phone = NSLocalizedString("PHONE.TITLE", comment: "")
        static let ringtone = NSLocalizedString("RINGTONE.TITLE", comment: "")
        static let notes = NSLocalizedString("NOTES.TITLE", comment: "")
        
    }
    struct Contact {
        static let firstName = NSLocalizedString("FIRST.NAME", comment: "")
        static let lastName = NSLocalizedString("LAST.NAME", comment: "")
        static let mobilePhone = NSLocalizedString("MOBILE.PHONE", comment: "")
        static let ringtone = NSLocalizedString("RINGTONE", comment: "")
        static let defaultRingtone = NSLocalizedString("DEFAULT", comment: "")
        static let notes = NSLocalizedString("NOTES.TITLE", comment: "")
        static let someNotes = NSLocalizedString("TYPE.SOME.NOTES", comment: "")
        static let addPhotoButton = NSLocalizedString("ADD.PHOTO.BUTTON", comment: "")
        static let nextButton = NSLocalizedString("NEXT.BUTTON", comment: "")
        static let doneButton = NSLocalizedString("DONE.BUTTON", comment: "")
        static let deleteButton = NSLocalizedString("DELETE.BUTTON", comment: "")
        static let takePhoto = NSLocalizedString("TAKE.PHOTO", comment: "")
        static let choosePhoto = NSLocalizedString("CHOOSE.PHOTO", comment: "")
        static let cancelAction = NSLocalizedString("CANCEL.ACTION", comment: "")
        static let okAction = NSLocalizedString("OK.ACTION", comment: "")
        static let warningAlert = NSLocalizedString("WARNING.ALERT", comment: "")
        static let noCamera = NSLocalizedString("NO.CAMERA", comment: "")
        static let noPermission = NSLocalizedString("NO.PERMISSION", comment: "")
    }
    
}

