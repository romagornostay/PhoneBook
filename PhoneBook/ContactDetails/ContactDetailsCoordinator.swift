//
//  ContactDetailsCoordinator.swift
//  PhoneBook
//
//  Created by SalemMacPro on 7.6.21.
//

import UIKit



final class ContactDetailsCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var contact: ContactData
    private weak var contactListViewModel: ContactListViewModel?
  

    init(presenter: UINavigationController, contact: ContactData, viewModel: ContactListViewModel?) {
        self.presenter = presenter
        self.contact = contact
        self.contactListViewModel = viewModel
      }
    
    func start() {
        let viewModel = ContactDetailsViewModel(with: contact)
        viewModel.delegate = self
        let contactDetailsviewController = ContactDetailsViewController(viewModel: viewModel)
        contactDetailsviewController.navigationItem.largeTitleDisplayMode = .never
        presenter.pushViewController(contactDetailsviewController, animated: true)
    }
}

// MARK: ContactDetailsViewModelDelegate
extension ContactDetailsCoordinator: ContactDetailsViewModelDelegate {
    func contactDetailsViewModelDidRequestEditContact(_ contact: ContactData) {
        let viewModel = ContactViewModel(with: contact)
        viewModel.updateDelegate = self
        let viewController = CreateContactViewController(viewModel: viewModel)
        viewController.navigationItem.largeTitleDisplayMode = .never
        presenter.pushViewController(viewController, animated: false)
    }
}


extension ContactDetailsCoordinator: UpdateContactViewModelDelegate {
    func contactViewModelDidRequestUpdateContact(_ contact: ContactData) {
        if let viewModel = contactListViewModel {
            viewModel.updateContact(contact)
            presenter.popToRootViewController(animated: true)
        }
    }
    
    func contactsViewModelDidRequestDeleteContact(_ contact: ContactData) {
        if let viewModel = contactListViewModel {
            viewModel.deleteContact(contact)
            presenter.popToRootViewController(animated: true)
        }
    }
}




