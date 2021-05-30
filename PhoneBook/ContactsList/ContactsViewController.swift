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
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    init(viewModel: ContactsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let names = ["John Smith", "Roman Smith", "Mary Smith", "Kate Smith", "Billy Smith", "Jason Smith",
                 "Bohn Bermith", "Yohman Smith", "Rosemary Smith", "Satie Smith", "Ailly Gith", "Drayson Smith",
                 "Vohn Bermith", "Zohman Smith", "Vosemary Smith", "Latie Smith", "Tilly Gith", "Sraymon Smith"]
    let contactIndexTitles = ["#", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var contactsDict = [String: [String]]()
    var sectionTitles = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupLayout()
        
        tableView.delegate = self
        tableView.dataSource = self
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.obtainContacts()
        createContactsDict()
        tableView.reloadData()
    }
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
    
    // MARK: - Helper method
    
    func createContactsDict() {
        for entity in viewModel.savedEntities {
            // Get the first letter of the contact name and build the dictionary
            let fullName = entity.firstName! //+ " " + (entity.lastName ?? "")
            let firstLetterIndex = fullName.index(fullName.startIndex, offsetBy: 1)
            let key = String(fullName[..<firstLetterIndex])
            
            if var contactValues = contactsDict[key] {
                contactValues.append(fullName)
                contactsDict[key] = contactValues
            } else {
                contactsDict[key] = [fullName]
            }
        }
        
        // Get the section titles from the dictionary's keys and sort them in ascending order
        sectionTitles = [String](contactsDict.keys)
        sectionTitles = sectionTitles.sorted(by: { $0 < $1 })
        print(contactsDict)
        print(sectionTitles)
    }
}

extension ContactsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedContact = viewModel.savedEntities[indexPath.row]
//        viewModel.showContactDetails(for: selectedContact)
        
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = sectionTitles.firstIndex(of: title) else { return -1 }
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = sectionTitles[section]
        guard let contactValues = contactsDict[key] else { return 0 }
        return contactValues.count
      // return viewModel.savedEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let contactKey = sectionTitles[indexPath.section]
        if let contactValues = contactsDict[contactKey] {
            cell.textLabel?.text = contactValues[indexPath.row]
        }
//
//        let entity = viewModel.savedEntities[indexPath.row]
//        cell.textLabel?.text = entity.firstName! + " " + (entity.lastName ?? "")
        return cell
    }
}
