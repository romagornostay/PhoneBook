//
//  MainCoordinator.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set}
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init() {
        self.navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
    }
    
    private let contactsViewModel = ContactsViewModel()
    
    func showContacts() {
        contactsViewModel.delegate = self
        let contactsViewController = ContactsViewController(viewModel: contactsViewModel)
        contactsViewController.navigationItem.largeTitleDisplayMode = .always
        navigationController.pushViewController(contactsViewController, animated: false)
    }
}


extension MainCoordinator: AddContactViewModelDelegate {
    func addNewContact(_ contact: ContactData) {
        contactsViewModel.addContact(contact)
        navigationController.popViewController(animated: false)
    }
}

extension MainCoordinator: EditViewModelDelegate {
    func saveContact(_ contact: ContactData) {
        contactsViewModel.updateContact(contact)
        navigationController.popViewController(animated: false)
        contactsViewModel.obtainContactsList()
    }
    
    func deleteContact(_ contact: ContactData) {
        contactsViewModel.deleteContact(contact)
        navigationController.popToRootViewController(animated: true)
    }
}


extension MainCoordinator: ContactsViewModelDelegate {
    func showContactDetails(_ contact: ContactData) {
        let viewModel = ContactDetailsViewModel(with: contact)
        viewModel.delegate = self
        let viewController = ContactDetailsViewController(viewModel: viewModel)
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func addContact() {
        let viewModel = AddContactViewModel()
        viewModel.delegate = self
        let viewController = AddContactViewController(viewModel: viewModel)
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(viewController, animated: false)
    }
}


extension MainCoordinator: ContactDetailsViewModelDelegate {
    func editContact(_ contact: ContactData) {
        let viewModel = EditViewModel(with: contact)
        viewModel.delegate = self
        let viewController = EditViewController(viewModel: viewModel)
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(viewController, animated: false)
    }
}
