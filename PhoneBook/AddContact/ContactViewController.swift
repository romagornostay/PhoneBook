//
//  ContactViewController.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit
import SnapKit


class ContactViewController: UIViewController {
    private let viewModel: ContactViewModel
    
    init(viewModel: ContactViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let nameView = ContactSomeDetailCellView()
    private let lastNameView = ContactSomeDetailCellView()
    private let phoneView = ContactSomeDetailCellView()
    private let ringtoneView = ContactSomeDetailCellView()
    private let notesV = ContactSomeDetailCellView()
    
    
    private let ringtonePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .systemBackground
        return picker
    }()
    
    private let imagePicker = UIImagePickerController()
    
    private let chosenImage = UIImageView()
    
    
    
    private let avatarView: UIImageView = {
        let image = UIImageView()
        image.image = Images.addImage
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 45
        image.backgroundColor = .white
        return image
    }()
    
    private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
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
    
    private lazy var newContact: ContactData = {
        let name = nameView.textField.text
        let lastName = lastNameView.textField.text ?? ""
        let phone = phoneView.textField.text
        let ringtone = ringtoneView.textField.text
        let notes = notesV.textField.text
        let contact = ContactData(id: nil, firstName: name, lastName: lastName, phone: phone, ringtone: ringtone, notes: notes, avatar: chosenImage.image)
        return contact
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        
        setupContactImage()
        setupFirstNameView()
        setupLastNameView()
        setupPhoneNumberView()
        setupRingtoneView()
        setupNotesView()
        
        setupTextFields()
        setupRingtonePicker()
        setupMissKeyboardTapGesture()
        setupContactData()
        setupDeleteButton()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doneButton.isEnabled = nameView.textField.text == nil
    }
    
    private func setupContactImage() {
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
            make.top.equalTo(avatarView.snp.bottom)//.inset(8)
            make.leading.equalTo(25)
        }
        addPhotoButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
    }
    
    private func setupFirstNameView() {
        view.addSubview(nameView)
        nameView.textField.placeholder = LocalizationConstants.AddContact.firstName
        nameView.textField.becomeFirstResponder()

        nameView.snp.makeConstraints { make in
            make.topMargin.equalTo(15)
            make.leading.equalTo(avatarView.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }
    }
    private func setupLastNameView() {
        view.addSubview(lastNameView)
        lastNameView.textField.placeholder = LocalizationConstants.AddContact.lastName

        lastNameView.snp.makeConstraints { make in
            make.top.equalTo(nameView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(nameView)
        }
    }

    private func setupPhoneNumberView() {
        view.addSubview(phoneView)
        phoneView.textField.placeholder = LocalizationConstants.AddContact.mobilePhone
        phoneView.textField.keyboardType = .phonePad

        phoneView.snp.makeConstraints { make in
            make.top.equalTo(lastNameView.snp.bottom).offset(40)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupRingtoneView() {
        view.addSubview(ringtoneView)
        ringtoneView.titleLabel.text = LocalizationConstants.AddContact.ringtone
        ringtoneView.textField.placeholder = LocalizationConstants.AddContact.defaultRingtone

        ringtoneView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(phoneView)
        }
    }
    
    private func setupNotesView() {
        view.addSubview(notesV)
        notesV.titleLabel.text = LocalizationConstants.AddContact.notes
        notesV.textField.returnKeyType = .done

        notesV.snp.makeConstraints { (make) in
            make.top.equalTo(ringtoneView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(ringtoneView)
        }
    }
    

    
    private func setupDeleteButton() {
        guard viewModel.contact != nil else { return }
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(notesV.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            
        }
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    @objc
    private func deleteTapped() {
        viewModel.deleteContact()
    }
    
    
    private func setupContactData() {
        if let currentContact = viewModel.contact {
            nameView.textField.text = currentContact.firstName
            lastNameView.textField.text =  currentContact.lastName
            phoneView.textField.text = currentContact.phone
            ringtoneView.textField.text = currentContact.ringtone
            notesV.textField.text = currentContact.notes
            if let contactImage = currentContact.avatar {
                avatarView.image = contactImage
            } else {
                avatarView.image = Images.addImage
            }
            avatarView.layer.masksToBounds = true
        }
    }
    
    
    private func setupNavigationItems() {
        doneButton.target = self
        doneButton.action = #selector(doneTapped)
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        
    }
    
    @objc
    private func doneTapped() {
        if var currentContact = viewModel.contact {
            currentContact.firstName = nameView.textField.text
            currentContact.lastName = lastNameView.textField.text ?? " "
            currentContact.phone = phoneView.textField.text
            currentContact.ringtone = ringtoneView.textField.text
            currentContact.notes = notesV.textField.text
            currentContact.avatar = chosenImage.image
            viewModel.updateContact(currentContact)
        } else {
            viewModel.addContact(newContact)
        }
    }
    
    @objc
    private func cancelTapped() {
        navigationController?.popViewControllerToBottom()
    }
    
    private func setupTextFields() {
        nameView.textField.delegate = self
        lastNameView.textField.delegate = self
        phoneView.textField.delegate = self
        ringtoneView.textField.delegate = self
        notesV.textField.delegate = self
        addInputAccessoryForTextFields([phoneView.textField, ringtoneView.textField, notesV.textField])
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
        ringtoneView.textField.inputView = ringtonePicker
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
}

//MARK:-- UITextFieldDelegate
extension ContactViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneView.textField {
            let fullString = (phoneView.textField.text ?? "") + string
            textField.text = viewModel.formatNumber(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
            return false
        }
        if textField == nameView.textField {
           let nameLength = (textField.text?.count ?? 0) - range.length + string.count
            doneButton.isEnabled = nameLength > 0
        }
       
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameView.textField:
            lastNameView.textField.becomeFirstResponder()
        case lastNameView.textField:
            phoneView.textField.becomeFirstResponder()
        case phoneView.textField:
            ringtoneView.textField.becomeFirstResponder()
        case ringtoneView.textField:
            notesV.textField.becomeFirstResponder()
        case notesV.textField:
            notesV.textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}
//MARK:-- UIPickerViewDelegate
extension ContactViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.ringtones[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ringtoneView.textField.text = Constants.ringtones[row]
    }
}
//MARK:-- UIPickerViewDataSource
extension ContactViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Constants.ringtones.count
    }
}

//MARK:-- ImagePicker delegate
extension ContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            chosenImage.image = pickedImage
            avatarView.image = chosenImage.image
            avatarView.layer.masksToBounds = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
