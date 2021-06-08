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
        //table.separatorStyle = .none
        table.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.autocapitalizationType = .words
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    init(viewModel: ContactListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contactIndexTitles = ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupLayout()
        setupSearchController()
        
        binding()
        viewModel.createModels()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func binding() {
        viewModel.onDidUpdateData = { [weak self] in
                self?.tableView.reloadData()
                //print("----Binding!!!----")
        }
    }
    
    private func setupNavigationItems() {
        title = LocalizationConstants.Contacts.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.backBarButtonItem = UIBarButtonItem(title: LocalizationConstants.Contacts.title, style: .plain, target: self, action: nil)
    }
    
    @objc
    private func addTapped(){
        viewModel.openViewAddContact()
        print("AddContact---1--")
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupSearchController() {
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //tableView.reloadData()
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
            print("OPEN---1--")
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
// MARK: UITableViewDataSource
extension ContactListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.contactsSectionTitles.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = viewModel.contactsSectionTitles.firstIndex(of: title) else { return -1 }
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.contactsSectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        headerView.textLabel?.textColor = .black
        headerView.textLabel?.font = .base4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let character = viewModel.contactsSectionTitles[section]
        let filteredModels = viewModel.models.filter {$0.character == character}
        guard let contacts = filteredModels.first?.contacts else { return 0 }
        
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        
        let character = viewModel.contactsSectionTitles[indexPath.section]
        let filteredModels = viewModel.models.filter {$0.character == character}
        if let contacts = filteredModels.first?.contacts {
            let contact = contacts[indexPath.row]
            cell.set(contact.firstName, contact.lastName)
        }
//        let character = viewModel.contactsSectionTitles[indexPath.section]
//        if let contactValues = viewModel.contactsDict[character] {
//            let contact = contactValues[indexPath.row]
//            cell.set(contact.firstName, contact.lastName)
//        }
        return cell
    }
}