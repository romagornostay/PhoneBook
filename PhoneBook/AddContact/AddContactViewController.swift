//
//  AddContactViewController.swift
//  PhoneBook
//
//  Created by SalemMacPro on 31.5.21.
//

import UIKit
import SnapKit


class AddContactViewController: UIViewController {
    private let viewModel: AddContactViewModel
    
    init(viewModel: AddContactViewModel) {
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
        textField.returnKeyType = .done
        textField.becomeFirstResponder()
        textField.backgroundColor = .white
        return textField
    }()
    private let textFieldLastName: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Last name"
        textField.returnKeyType = .done
        textField.becomeFirstResponder()
        textField.backgroundColor = .white
        return textField
    }()
    
    private let phoneField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "mobile"
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
    
    
    private lazy var newContact: ContactData = {
        let name = textFieldName.text!
        let lastName = textFieldLastName.text ?? ""
        let phone = phoneField.text!
        let ringtone = ringtoneField.text ?? "Default"
        let notes = notesField.text ?? "Wake up, Neo…"
        let contact = ContactData(id: nil, firstName: name, lastName: lastName, phone: phone, ringtone: ringtone, notes: notes, avatar: image.image)
        return contact
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle.fill")
        //image.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 45
        image.backgroundColor = .white
        return image
    }()
    
    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Photo", for: .normal)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldName.delegate = self
        textFieldLastName.delegate = self
        ringtoneField.delegate = self
        setupNavigationItems()
        setupPicker()
        setupLayout()
        
    }
    
    
    private func setupNavigationItems() {
        title = "New Contact"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
    }
    
    @objc
    private func doneTapped() {
        
        viewModel.addContact(newContact)
        
    }
    
    @objc
    private func cancelTapped() {
        navigationController?.popViewController(animated: false)
        print("CANCEL!!!")
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
    
    @objc
    private func imageTapped(sender: UIImageView) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
        print("Choose image!!!")
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
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
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
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
        
        
        view.addSubview(image)
        
        image.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tapRecognizer)
        
        image.center = view.center
        image.snp.makeConstraints { make in
            make.topMargin.equalTo(16)
            make.leading.equalTo(16)
            make.width.height.equalTo(90)
        }
        
        view.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).inset(12)
            make.leading.equalTo(25)
        }
        addPhotoButton.addTarget(self, action: #selector(imageTapped), for: .touchUpInside)
        
        
        
        view.addSubview(textFieldName)
        textFieldName.snp.makeConstraints { make in
            make.topMargin.equalTo(25)
            make.leading.equalTo(image.snp.trailing).offset(16)
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
            make.top.equalTo(textFieldLastName.snp.bottom).offset(30)
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
    }
}


extension AddContactViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.addContact(newContact)
        return true
    }
}

extension AddContactViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ringtones[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ringtoneField.text = ringtones[row]
        ringtoneField.resignFirstResponder()
    }
}

extension AddContactViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        ringtones.count
    }
}

//MARK:-- ImagePicker delegate
extension AddContactViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            image.image = pickedImage
            image.layer.masksToBounds = true
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

