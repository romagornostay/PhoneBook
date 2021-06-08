//
//  CreateContactViewController.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit
import SnapKit


class CreateContactViewController: UIViewController {
    private let viewModel: CreateContactViewModel
    
    init(viewModel: CreateContactViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let ringtones = ["Apex","Cosmic","Crystals","Popcorn","Pulse","Twinkle"]
    
    private let textFieldName: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizationConstants.AddContact.firstName
        textField.returnKeyType = .next
        textField.becomeFirstResponder()
        textField.backgroundColor = .white
        return textField
    }()
    private let textFieldLastName: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizationConstants.AddContact.lastName
        textField.returnKeyType = .next
        textField.backgroundColor = .white
        return textField
    }()
    
    private let phoneField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizationConstants.AddContact.mobilePhone
        //textField.textContentType = .telephoneNumber
        textField.keyboardType = .phonePad
        textField.returnKeyType = .next
        textField.backgroundColor = .white
        return textField
    }()
    
    private let ringtoneLabel: UILabel = {
        var label = UILabel()
        label.text = LocalizationConstants.AddContact.ringtone
        label.font = .base1
        return label
    }()
    
    private let ringtoneField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizationConstants.AddContact.defaultRingtone
        textField.backgroundColor = .white
        textField.returnKeyType = .next
        //textField.inputAccessoryView =
        return textField
    }()
    
    private let notesLabel: UILabel = {
        var label = UILabel()
        label.text = LocalizationConstants.AddContact.notes
        label.font = .base1
        return label
    }()
    
    private let notesField: UITextField = {
        let textField = UITextField()
        textField.placeholder = LocalizationConstants.AddContact.someNotes
        textField.backgroundColor = .white
        textField.returnKeyType = .done
        return textField
    }()
    
    private let ringtonePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .systemBackground
        return picker
    }()
    
    private let imagePicker = UIImagePickerController()
    
    private let divider1 = UILabel()
    private let divider2 = UILabel()
    private let divider3 = UILabel()
    private let divider4 = UILabel()
    private let divider5 = UILabel()
    
    
    private lazy var newContact: ContactData = {
        
        let name = textFieldName.text!
        let lastName = textFieldLastName.text ?? ""
        
        var phone = ""
        if let text = phoneField.text {
            phone = text.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacmentCharacter: "#")
        }
        
        let ringtone = ringtoneField.text ?? "Default"
        let notes = notesField.text ?? "Wake up, Neo…"
        let contact = ContactData(id: nil, firstName: name, lastName: lastName, phone: phone, ringtone: ringtone, notes: notes, avatar: avatarView.image)
        return contact
    }()
    
    private let avatarView: UIImageView = {
        let image = UIImageView()
        image.image = Images.userImage
        image.tintColor = .lightGray
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 45
        image.backgroundColor = .white
        return image
    }()
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationConstants.AddContact.addPhotoButton, for: .normal)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationConstants.EditContact.deleteButton, for: .normal)
        return button
    }()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        setupLayout()
        setupTextFields()
        setupRingtonePicker()
        setupMissKeyboardTapGesture()
        setupContactData()
    }
    
    private func setupContactData() {
        if let currentContact = viewModel.contact {
            textFieldName.text = currentContact.firstName
            textFieldLastName.text =  currentContact.lastName
            phoneField.text = currentContact.phone
            ringtoneField.text = currentContact.ringtone
            notesField.text = currentContact.notes
            avatarView.image = currentContact.avatar
            avatarView.layer.masksToBounds = true
        }
    }
    
    
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }
    
    @objc
    private func doneTapped() {
        if var currentContact = viewModel.contact {
            currentContact.firstName = textFieldName.text!
            currentContact.lastName = textFieldLastName.text ?? ""
            currentContact.phone = phoneField.text!
            currentContact.ringtone = ringtoneField.text ?? "Default"
            currentContact.notes = notesField.text ?? "Wake up, Neo…"
            currentContact.avatar = avatarView.image
            viewModel.updateContact(currentContact)
        } else {
            print("--NewAdd---")
            viewModel.addContact(newContact)
           
        }
    }
    
    @objc
    private func cancelTapped() {
        navigationController?.popViewControllerToBottom()
    }
    
    private func setupTextFields() {
        textFieldName.delegate = self
        textFieldLastName.delegate = self
        phoneField.delegate = self
        ringtoneField.delegate = self
        notesField.delegate = self
        addInputAccessoryForTextFields([phoneField,ringtoneField, notesField])
    }
    
    func addInputAccessoryForTextFields(_ textFields: [UITextField]) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            let nextButton = UIBarButtonItem(title: LocalizationConstants.AddContact.nextButton, style: .plain, target: nil, action: nil)
            if textField == textFields.last {
                nextButton.isEnabled = false
            } else {
                nextButton.target = textFields[index + 1]
                nextButton.action = #selector(UITextField.becomeFirstResponder)
            }
            items.append(contentsOf: [nextButton])
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: LocalizationConstants.AddContact.doneButton, style: .plain, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            toolbar.setItems(items, animated: false)
            if textField == textFields.last {
                toolbar.isHidden = true
            } else {
                textField.inputAccessoryView = toolbar
            }
        }
    }
    
    
    private func setupRingtonePicker() {
        ringtonePicker.delegate = self
        ringtonePicker.dataSource = self
        ringtoneField.inputView = ringtonePicker
    }
    
    private func setupMissKeyboardTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(missTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func missTapped() {
        view.endEditing(true)
    }
    
    
    @objc
    private func imageTapped(sender: UIImageView) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openPhotos()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPhotos() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setupLayout() {
        
        view.backgroundColor = .white
        view.addSubview(avatarView)
        
        avatarView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        avatarView.addGestureRecognizer(tapRecognizer)
        
        avatarView.center = view.center
        avatarView.snp.makeConstraints { make in
            make.topMargin.equalTo(16)
            make.leading.equalTo(16)
            make.width.height.equalTo(90)
        }
        
        view.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom).inset(8)
            make.leading.equalTo(25)
        }
        addPhotoButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        
        view.addSubview(textFieldName)
        textFieldName.snp.makeConstraints { make in
            make.topMargin.equalTo(25)
            make.leading.equalTo(avatarView.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
            make.height.equalTo(22)
        }
        
        view.addSubview(divider1)
        divider1.layer.backgroundColor = UIColor.base1.cgColor
        divider1.snp.makeConstraints { make in
            make.top.equalTo(textFieldName.snp.bottom).offset(3)
            make.leading.trailing.equalTo(textFieldName)
            make.height.equalTo(1)
        }
        
        view.addSubview(textFieldLastName)
        textFieldLastName.snp.makeConstraints { make in
            make.top.equalTo(textFieldName.snp.bottom).offset(25)
            make.leading.trailing.equalTo(textFieldName)
            make.height.equalTo(22)
        }
        
        view.addSubview(divider2)
        divider2.layer.backgroundColor = UIColor.base1.cgColor
        divider2.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldLastName.snp.bottom).offset(3)
            make.leading.trailing.equalTo(textFieldLastName)
            make.height.equalTo(1)
        }
        
        view.addSubview(phoneField)
        phoneField.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldLastName.snp.bottom).offset(40)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview()
            make.height.equalTo(22)
        }
        
        view.addSubview(divider3)
        divider3.layer.backgroundColor = UIColor.base1.cgColor
        divider3.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp.bottom).offset(3)
            make.leading.trailing.equalTo(phoneField)
            make.height.equalTo(1)
        }
        
        view.addSubview(ringtoneLabel)
        ringtoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(phoneField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(phoneField)
            make.height.equalTo(22)
        }
        
        view.addSubview(ringtoneField)
        ringtoneField.snp.makeConstraints { (make) in
            make.top.equalTo(ringtoneLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(ringtoneLabel)
            make.height.equalTo(22)
        }
        
        view.addSubview(divider4)
        divider4.layer.backgroundColor = UIColor.base1.cgColor
        divider4.snp.makeConstraints { (make) in
            make.top.equalTo(ringtoneField.snp.bottom).offset(3)
            make.leading.trailing.equalTo(ringtoneField)
            make.height.equalTo(1)
        }
        
        
        view.addSubview(notesLabel)
        notesLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ringtoneField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(ringtoneField)
            make.height.equalTo(22)
        }
        
        view.addSubview(notesField)
        notesField.snp.makeConstraints { (make) in
            make.top.equalTo(notesLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(notesLabel)
            make.height.equalTo(22)
        }
        view.addSubview(divider5)
        divider5.layer.backgroundColor = UIColor.base1.cgColor
        divider5.snp.makeConstraints { (make) in
            make.top.equalTo(notesField.snp.bottom).offset(3)
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
    @objc
    private func deleteTapped() {
        viewModel.deleteContact()
    }
}

//MARK:-- UITextFieldDelegate
extension CreateContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textFieldName:
            textFieldLastName.becomeFirstResponder()
        case textFieldLastName:
            phoneField.becomeFirstResponder()
        case phoneField:
            ringtoneField.becomeFirstResponder()
        case ringtoneField:
            notesField.becomeFirstResponder()
        case notesField:
            notesField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
//MARK:-- UIPickerViewDelegate
extension CreateContactViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ringtones[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ringtoneField.text = ringtones[row]
    }
}
//MARK:-- UIPickerViewDataSource
extension CreateContactViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ringtones.count
    }
}

//MARK:-- ImagePicker delegate
extension CreateContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            avatarView.image = pickedImage
            avatarView.layer.masksToBounds = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

