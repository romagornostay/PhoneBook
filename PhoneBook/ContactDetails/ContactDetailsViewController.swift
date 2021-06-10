//
//  ContactDetailsViewController.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit

class ContactDetailsViewController: UIViewController {
    private let viewModel: ContactDetailsViewModel
    
    init(viewModel: ContactDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        let table = UITableView.init(frame: .zero, style: .grouped)
        table.register(ContactDetailTableViewCell.self, forCellReuseIdentifier: ContactDetailTableViewCell.identifier)
        return table
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .base3
        label.layer.masksToBounds = true
        return label
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 45
        return image
    }()
    
    private let extendedView: UIView = {
        let view = UIView()
        view.backgroundColor = .base2
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationItems()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        let headerView = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0,
                                                               width: view.frame.size.width,
                                                               height: view.frame.size.width/3))
        let contact = viewModel.contact
        headerView.configure(name: contact.firstName, lastName: contact.lastName, avatar: contact.avatar)
        //print(view.bounds.width)
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupNavigationItems() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editTapped))
    }
    
    @objc
    private func editTapped(){
        let currentContact = viewModel.contact
        viewModel.editContact(currentContact)
    }
}

extension ContactDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 3 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailTableViewCell.identifier, for: indexPath) as! ContactDetailTableViewCell
        let currentContact = viewModel.contact
        switch indexPath.row {
        case 0: cell.configure(title: LocalizationConstants.ContactDetails.phone, description: currentContact.phone , textColor: .base3)
        case 1: cell.configure(title: LocalizationConstants.ContactDetails.ringtone, description: currentContact.ringtone, textColor: .black)
        case 2: cell.configure(title: LocalizationConstants.ContactDetails.notes, description: currentContact.notes , textColor: .black)
        default: break
        }
        return cell
    }
}

extension ContactDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else {return}
        header.scrollViewDidScroll(scrollView: tableView)
    }
}

