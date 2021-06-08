//
//  ContactListCoordinator.swift
//  PhoneBook
//
//  Created by SalemMacPro on 7.6.21.
//

import UIKit


final class ContactListCoordinator: Coordinator {
    
    private let presenter: UINavigationController
    private var coordinator: ContactDetailsCoordinator?
    weak var contactListViewModel: ContactListViewModel?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        let contactListViewModel = ContactListViewModel()
        self.contactListViewModel = contactListViewModel
        let contactListViewController = ContactListViewController(viewModel: contactListViewModel)
        contactListViewController.navigationItem.largeTitleDisplayMode = .always
        contactListViewModel.delegate = self
        presenter.pushViewController(contactListViewController, animated: false)
    }
}


// MARK: ContactListViewModelDelegate
extension ContactListCoordinator: ContactListViewModelDelegate {
    func showContactDetails(_ contact: ContactData) {
        let coordinator = ContactDetailsCoordinator(presenter: presenter, contact: contact, viewModel: contactListViewModel)
        coordinator.start()
        self.coordinator = coordinator
    }
    
    func addContact() {
        let viewModel = CreateContactViewModel(with: nil)
        viewModel.createDelegate = self
        let viewController = CreateContactViewController(viewModel: viewModel)
        viewController.navigationItem.largeTitleDisplayMode = .never
        presenter.moveViewControllerFromBottom(viewController)
    }
}
// MARK: CreateContactViewModelDelegate
extension ContactListCoordinator: CreateContactViewModelDelegate {
    func addNewContact(_ contact: ContactData) {
        contactListViewModel?.addContact(contact)
        presenter.popViewControllerToBottom()
    }
}


