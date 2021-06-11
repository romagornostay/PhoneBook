//
//  ContactListViewController.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

class ContactListViewController: UIViewController {
    private let viewModel: ContactListViewModel
    
    private let tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .plain)
        table.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.autocapitalizationType = .words
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private lazy var dataSource : DataSource = DataSource()
    
    init(viewModel: ContactListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupSearchController()
        setupTableView()
        binding()
        viewModel.createModels()
    }
    
    private func binding() {
        viewModel.onDidUpdateData = { [weak self] in
                self?.tableView.reloadData()
        }
    }
    
    private func setupNavigationItems() {
        title = LocalizationConstants.ContactList.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: LocalizationConstants.ContactList.title, style: .plain, target: self, action: nil)
    }
    
    @objc
    private func addTapped(){
        viewModel.addContact()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self.dataSource
        dataSource.viewModel = viewModel
    }
    
    private func setupSearchController() {
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
}

// MARK: UISearchResultsUpdating
extension ContactListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.updateSearchResults(for: searchController)
    }
}
// MARK: UITableViewDelegate
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let character = viewModel.contactsSectionTitles[indexPath.section]
        let filteredModels = viewModel.models.filter {$0.character == character}
        if let contacts = filteredModels.first?.contacts {
            let contact = contacts[indexPath.row]
            viewModel.showContactDetails(for: contact)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
