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
    
    private let firstNameView = ContactSomeDetailCellView()
    private let lastNameView = ContactSomeDetailCellView()
    private let phoneView = ContactSomeDetailCellView()
    private let ringtoneView = ContactSomeDetailCellView()
    private let notesView = ContactSomeDetailCellView()
    
    private let ringtonePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .systemBackground
        return picker
    }()
    
    private let imagePicker = UIImagePickerController()
    private let chosenImageFromPicker = UIImageView()
    private let disclosure = UIImageView(image: Images.chevronRight)
    private let scrollView = UIScrollView()
    private let containerView = UIView()
    
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
        button.setTitle(LocalizationConstants.Contact.addPhotoButton, for: .normal)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LocalizationConstants.Contact.deleteButton, for: .normal)
        return button
    }()
    
    private lazy var newContact: ContactData = {
        let name = firstNameView.textField.text
        let lastName = lastNameView.textField.text ?? ""
        let phone = phoneView.textField.text
        let ringtone = ringtoneView.textField.text
        let notes = notesView.textField.text
        let contact = ContactData(id: nil, firstName: name, lastName: lastName, phone: phone, ringtone: ringtone, notes: notes, avatar: chosenImageFromPicker.image)
        return contact
    }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupScrollView()
        setupNavigationItems()
        setupContactImage()
        setupFirstNameView()
        setupLastNameView()
        setupPhoneNumberView()
        setupRingtoneView()
        setupNotesView()
        setupDeleteButton()
        setupTextFields()
        setupRingtonePicker()
        setupMissKeyboardTapGesture()
        setupContactData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //clear navigation bar
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        doneButton.isEnabled = firstNameView.textField.text == nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigation bar back to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        
        NotificationCenter.default.removeObserver(self)
       
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        scrollView.frame = view.bounds
        scrollView.contentSize = view.bounds.size
        containerView.frame.size = view.bounds.size
    }
    
    private func setupContactImage() {
        containerView.addSubview(avatarView)
        avatarView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        avatarView.addGestureRecognizer(tapRecognizer)
        
        avatarView.snp.makeConstraints { make in
            make.topMargin.equalTo(16)
            make.leading.equalTo(16)
            make.width.height.equalTo(90)
        }
        
        containerView.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(avatarView.snp.bottom)
            make.centerX.equalTo(avatarView.snp.centerX)
        }
        addPhotoButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
    }
    
    private func setupFirstNameView() {
        containerView.addSubview(firstNameView)
        firstNameView.textField.placeholder = LocalizationConstants.Contact.firstName
        firstNameView.textField.becomeFirstResponder()

        firstNameView.snp.makeConstraints { make in
            make.topMargin.equalTo(10)
            make.leading.equalTo(avatarView.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }
    }
    private func setupLastNameView() {
        containerView.addSubview(lastNameView)
        lastNameView.textField.placeholder = LocalizationConstants.Contact.lastName

        lastNameView.snp.makeConstraints { make in
            make.top.equalTo(firstNameView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(firstNameView)
        }
    }

    private func setupPhoneNumberView() {
        containerView.addSubview(phoneView)
        phoneView.textField.placeholder = LocalizationConstants.Contact.mobilePhone
        phoneView.textField.keyboardType = .phonePad

        phoneView.snp.makeConstraints { make in
            make.top.equalTo(lastNameView.snp.bottom).offset(30)
            make.leading.equalTo(20)
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupRingtoneView() {
        containerView.addSubview(ringtoneView)
        ringtoneView.titleLabel.text = LocalizationConstants.Contact.ringtone
        ringtoneView.textField.placeholder = LocalizationConstants.Contact.defaultRingtone

        ringtoneView.snp.makeConstraints { make in
            make.top.equalTo(phoneView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(phoneView)
        }
        containerView.addSubview(disclosure)
        disclosure.tintColor = .base1
        disclosure.snp.makeConstraints { make in
            make.centerY.equalTo(ringtoneView.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupNotesView() {
        containerView.addSubview(notesView)
        notesView.titleLabel.text = LocalizationConstants.Contact.notes
        notesView.textField.returnKeyType = .done

        notesView.snp.makeConstraints { (make) in
            make.top.equalTo(ringtoneView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(ringtoneView)
        }
    }
    
    private func setupDeleteButton() {
        guard viewModel.contact != nil else { return }
        containerView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(notesView.snp.bottom).offset(10)
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
            firstNameView.textField.text = currentContact.firstName
            lastNameView.textField.text =  currentContact.lastName
            phoneView.textField.text = currentContact.phone
            ringtoneView.textField.text = currentContact.ringtone
            notesView.textField.text = currentContact.notes
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
            currentContact.firstName = firstNameView.textField.text
            currentContact.lastName = lastNameView.textField.text ?? " "
            currentContact.phone = phoneView.textField.text
            currentContact.ringtone = ringtoneView.textField.text
            currentContact.notes = notesView.textField.text
            currentContact.avatar = chosenImageFromPicker.image
            viewModel.updateContact(currentContact)
        } else {
            viewModel.addContact(newContact)
        }
    }
    
    @objc
    private func cancelTapped() {
        viewModel.cancelContact()
    }
    
    
    @objc
    private func keyboardWillShow(notification:NSNotification) {
        let userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardWillHide(notification:NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    
    private func setupTextFields() {
        firstNameView.textField.delegate = self
        lastNameView.textField.delegate = self
        phoneView.textField.delegate = self
        ringtoneView.textField.delegate = self
        notesView.textField.delegate = self
        addInputAccessoryForTextFields([phoneView.textField, ringtoneView.textField, notesView.textField])
    }
    
    private func addInputAccessoryForTextFields(_ textFields: [UITextField]) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            let nextButton = UIBarButtonItem(title: LocalizationConstants.Contact.nextButton, style: .plain, target: nil, action: nil)
            if textField == textFields.last {
                nextButton.isEnabled = false
            } else {
                nextButton.target = textFields[index + 1]
                nextButton.action = #selector(UITextField.becomeFirstResponder)
            }
            items.append(contentsOf: [nextButton])
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(title: LocalizationConstants.Contact.doneButton, style: .plain, target: view, action: #selector(UIView.endEditing))
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
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: LocalizationConstants.Contact.takePhoto, style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: LocalizationConstants.Contact.choosePhoto, style: .default, handler: { _ in
            self.openPhotos()
        }))
        alert.addAction(UIAlertAction.init(title: LocalizationConstants.Contact.cancelAction, style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: LocalizationConstants.Contact.warningAlert, message: LocalizationConstants.Contact.noCamera, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizationConstants.Contact.okAction, style: .default, handler: nil))
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
            let alert  = UIAlertController(title:LocalizationConstants.Contact.warningAlert, message: LocalizationConstants.Contact.noPermission, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizationConstants.Contact.okAction, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK:-- UITextFieldDelegate
extension ContactViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var isPhoneHasValue = false
        var isNameHasValue = false
        if textField == phoneView.textField {
            let fullString = (phoneView.textField.text ?? "") + string
            textField.text = viewModel.formatNumber(phoneNumber: fullString, shouldRemoveLastDigit: range.length == 1)
            
            let phoneLength = (textField.text?.count ?? 0) - range.length + string.count
            isPhoneHasValue = phoneLength > 0
            doneButton.isEnabled = isPhoneHasValue
            return false
        }
        if textField == firstNameView.textField {
            let nameLength = (textField.text?.count ?? 0) - range.length + string.count
            isNameHasValue = nameLength > 0
            doneButton.isEnabled = isNameHasValue
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameView.textField:
            lastNameView.textField.becomeFirstResponder()
        case lastNameView.textField:
            phoneView.textField.becomeFirstResponder()
        case phoneView.textField:
            ringtoneView.textField.becomeFirstResponder()
        case ringtoneView.textField:
            notesView.textField.becomeFirstResponder()
        case notesView.textField:
            notesView.textField.resignFirstResponder()
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
            chosenImageFromPicker.image = pickedImage
            avatarView.image = chosenImageFromPicker.image
            avatarView.layer.masksToBounds = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
