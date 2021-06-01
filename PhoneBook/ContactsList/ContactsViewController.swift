//
//  ContactsViewController.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

class ContactsViewController: UIViewController {
    private let viewModel: ContactsViewModel
    
    private let tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "ContactsTableViewCell")
        return table
    }()
    
    private let searchController: UISearchController = {
      let searchController = UISearchController()
      searchController.searchBar.autocapitalizationType = .none
      searchController.obscuresBackgroundDuringPresentation = false
      return searchController
    }()
    
    init(viewModel: ContactsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contactIndexTitles = ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.createContactsDict()
        setupNavigationItems()
        setupLayout()
        setupSearchController()
        binding()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func binding() {
        viewModel.onDidUpdateData = { [weak self] in
        DispatchQueue.main.async {
          self?.tableView.reloadData()
        }
      }
    }
    
    private func setupNavigationItems() {
        title = "Contacts"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc
    private func addTapped(){
        viewModel.openViewAddContact()
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
      navigationItem.searchController = self.searchController
      searchController.searchResultsUpdater = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.obtainContactsList()
        tableView.reloadData()
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
    
}

// MARK: UISearchResultsUpdating
extension ContactsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    viewModel.updateSearchResults(searchController: searchController)
  }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let selectedContact = viewModel.savedEntities[indexPath.row]
        let character = viewModel.contactsSectionTitles[indexPath.section]
        if let contactValues = viewModel.contactsDict[character] {
            let contact = contactValues[indexPath.row]
        viewModel.showContactDetails(for: contact)
        }
        
    }
}

extension ContactsViewController: UITableViewDataSource {
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
        return 16
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//      40
//    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let headerView = view as! UITableViewHeaderFooterView
        //headerView.backgroundView?.backgroundColor = UIColor(red: 0.953, green: 0.953, blue: 0.953, alpha: 1)
        headerView.textLabel?.textColor = .black
        headerView.textLabel?.font = .base4
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let character = viewModel.contactsSectionTitles[section]
        guard let contactValues = viewModel.contactsDict[character] else { return 0 }
        
        return contactValues.count
       //return viewModel.savedEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsTableViewCell", for: indexPath) as! ContactsTableViewCell
        
        let character = viewModel.contactsSectionTitles[indexPath.section]
        if let contactValues = viewModel.contactsDict[character] {
            let contact = contactValues[indexPath.row]
            cell.set(contact.firstName, contact.lastName)
            //cell.textLabel?.text = contact.firstName! + " " + (contact.lastName ?? "")
            //cell.imageView?.image = contact.avatar
        }
        //let entity = viewModel.savedEntities[indexPath.row]
        //cell.textLabel?.text = entity.firstName! + " " + (entity.lastName ?? "")
        return cell
    }
}
