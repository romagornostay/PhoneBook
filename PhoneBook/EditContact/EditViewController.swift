//
//  EditViewController.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit
import SnapKit


class EditViewController: UIViewController {
    
    private let viewModel: EditViewModel
    
    init(viewModel: EditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let ringtones = ["Apex","Cosmic","Crystals","Popcorn","Pulse","Twinkle"]
    
    private let textFieldName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "First name"
        textField.returnKeyType = .next
        textField.autocapitalizationType = .words
        textField.becomeFirstResponder()
        textField.backgroundColor = .white
        return textField
    }()
    private let textFieldLastName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last name"
        textField.returnKeyType = .next
        textField.autocapitalizationType = .words
        textField.autocorrectionType = .no
        textField.becomeFirstResponder()
        textField.backgroundColor = .white
        return textField
    }()
    
    private let phoneField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "mobile"
        textField.returnKeyType = .next
        textField.keyboardType = .phonePad
        textField.backgroundColor = .white
        return textField
    }()
    
    private let ringtoneLabel: UILabel = {
        var label = UILabel()
        label.text = "Ringtone"
        label.font = .base1
        return label
    }()
    
    private let ringtoneField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Default"
        textField.returnKeyType = .next
        textField.backgroundColor = .white
        return textField
    }()
    
    private let notesLabel: UILabel = {
        var label = UILabel()
        label.text = "Notes"
        label.font = .base1
        return label
    }()
    
    private let notesField: UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.backgroundColor = .white
        return textField
    }()
    
    private let picker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .systemBackground
        return picker
    }()
    
    private let toolbar = UIToolbar()
    
    private let divider1 = UILabel()
    private let divider2 = UILabel()
    private let divider3 = UILabel()
    private let divider4 = UILabel()
    private let divider5 = UILabel()
   
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete Contact", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldName.delegate = self
        setupNavigationItems()
        setupLayout()
        setupPicker()
    }
    
    private func setupPicker() {
        picker.delegate = self
        picker.dataSource = self
        ringtoneField.inputView = picker
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(toolbarDoneTapped))
        toolbar.setItems([doneButton], animated: false)
        ringtoneField.inputAccessoryView = toolbar
    }
    
    @objc
    private func toolbarDoneTapped() {
        self.resignFirstResponder()
    }
    
    private func setupLayout() {
        title = "editing..."
        view.backgroundColor = .systemIndigo
        
        let currentContact = viewModel.contact
        textFieldName.text = currentContact.firstName
        textFieldLastName.text =  currentContact.lastName
        phoneField.text = currentContact.phone
        ringtoneField.text = currentContact.ringtone
        notesField.text = currentContact.notes
        
        view.addSubview(textFieldName)
        textFieldName.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(22)
        }
        
        view.addSubview(divider1)
        divider1.layer.backgroundColor = UIColor.base1.cgColor
        divider1.snp.makeConstraints { make in
            make.top.equalTo(textFieldName.snp.bottom).offset(1)
            make.leading.trailing.equalTo(textFieldName)
            make.height.equalTo(1)
        }
        
        view.addSubview(textFieldLastName)
        textFieldLastName.snp.makeConstraints { make in
            make.top.equalTo(textFieldName.snp.bottom).offset(3)
            make.leading.trailing.equalTo(textFieldName)
            make.height.equalTo(22)
        }
        
        view.addSubview(divider2)
        divider2.layer.backgroundColor = UIColor.base1.cgColor
        divider2.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldLastName.snp.bottom).offset(1)
            make.leading.trailing.equalTo(textFieldLastName)
            make.height.equalTo(1)
        }
        
        view.addSubview(phoneField)
        phoneField.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldLastName.snp.bottom).offset(3)
            make.leading.trailing.equalTo(textFieldLastName)
            make.height.equalTo(22)
        }
        
        view.addSubview(divider3)
        divider3.layer.backgroundColor = UIColor.base1.cgColor
        divider3.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp.bottom).offset(1)
            make.leading.trailing.equalTo(phoneField)
            make.height.equalTo(1)
        }
        
        view.addSubview(ringtoneLabel)
        ringtoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp.bottom).offset(3)
            make.leading.trailing.equalTo(phoneField)
            make.height.equalTo(22)
        }
        
        view.addSubview(ringtoneField)
        ringtoneField.snp.makeConstraints { (make) in
            make.top.equalTo(ringtoneLabel.snp.bottom).offset(3)
            make.leading.trailing.equalTo(ringtoneLabel)
            make.height.equalTo(22)
        }
        
        view.addSubview(divider4)
        divider4.layer.backgroundColor = UIColor.base1.cgColor
        divider4.snp.makeConstraints { (make) in
            make.top.equalTo(ringtoneField.snp.bottom).offset(1)
            make.leading.trailing.equalTo(ringtoneField)
            make.height.equalTo(1)
        }
        
        
        view.addSubview(notesLabel)
        notesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ringtoneField.snp.bottom).offset(3)
            make.leading.trailing.equalTo(ringtoneField)
            make.height.equalTo(22)
        }
        
        view.addSubview(notesField)
        notesField.snp.makeConstraints { (make) in
            make.top.equalTo(notesLabel.snp.bottom).offset(3)
            make.leading.trailing.equalTo(notesLabel)
            make.height.equalTo(22)
        }
        view.addSubview(divider5)
        divider5.layer.backgroundColor = UIColor.base1.cgColor
        divider5.snp.makeConstraints { (make) in
            make.top.equalTo(notesField.snp.bottom).offset(1)
            make.leading.trailing.equalTo(notesField)
            make.height.equalTo(1)
        }
        
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-400)
            make.leading.equalTo(20)
            
        }
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    private func setupNavigationItems() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeTapped))
    }
    
    @objc
    private func doneTapped(){
        var currentContact = viewModel.contact
        currentContact.firstName = textFieldName.text!
        currentContact.lastName = textFieldLastName.text ?? ""
        currentContact.phone = phoneField.text!
        currentContact.ringtone = ringtoneField.text ?? "Default"
        currentContact.notes = notesField.text ?? "Wake up, Neo…"
        viewModel.saveContact(currentContact)
    }
    
    @objc
    private func closeTapped(){
        navigationController?.popViewController(animated: false)
        print("CANCEL!!!")
    }
    @objc
    private func deleteTapped(){
        viewModel.deleteContact()
        print("delete")
    }
}


extension EditViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ringtones[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ringtoneField.text = ringtones[row]
        ringtoneField.resignFirstResponder()
    }
}

extension EditViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ringtones.count
    }
}

extension EditViewController: UITextFieldDelegate {
    
}
