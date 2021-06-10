//
//  DataSource.swift
//  PhoneBook
//
//  Created by SalemMacPro on 5.6.21.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {
    
    var viewModel: ContactListViewModel?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel?.contactsSectionTitles.count)!
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return Constants.contactIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = viewModel?.contactsSectionTitles.firstIndex(of: title) else { return -1 }
        return index
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.contactsSectionTitles[section]
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
        let character = viewModel?.contactsSectionTitles[section]
        let filteredModels = viewModel?.models.filter {$0.character == character}
        guard let contacts = filteredModels?.first?.contacts else { return 0 }
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        let character = viewModel?.contactsSectionTitles[indexPath.section]
        let filteredModels = viewModel?.models.filter {$0.character == character}
        if let contacts = filteredModels?.first?.contacts {
            let contact = contacts[indexPath.row]
            cell.set(contact.firstName, contact.lastName)
        }
        return cell
    }
    
    
}




