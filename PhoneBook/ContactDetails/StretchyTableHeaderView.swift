//
//  StretchyTableHeaderView.swift
//  PhoneBook
//
//  Created by SalemMacPro on 2.6.21.
//

import UIKit
import SnapKit

final class StretchyTableHeaderView: UIView {

//    let avatarView: UIImageView = {
//        let image = UIImageView()
//        image.clipsToBounds = true
//        image.contentMode = .scaleAspectFit
//        //image.layer.cornerRadius = 45
//        //image.layer.masksToBounds = true
//        return image
//    }()
    let image: UIImageView = {
        let image = UIImageView()
        image.image = Images.userImage
        image.tintColor = .gray
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Thomas"
        label.textAlignment = .center
        label.font = .base3
        label.layer.masksToBounds = true
        return label
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Anderson"
        label.textAlignment = .center
        label.font = .base3
        label.layer.masksToBounds = true
        return label
    }()
    
    let avatarView: UIView = {
        let view = UIView()
        view.backgroundColor = .base2
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .base2
        return view
    }()
    
    
    func configure(name: String?, lastName: String?, avatar: UIImage?) {
        nameLabel.text = name
        lastNameLabel.text = lastName
        image.image = avatar
    }
    
    
    private var avatarViewHeight = NSLayoutConstraint()
    private var avatarViewBottom = NSLayoutConstraint()
    private var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setupLayout() {
        addSubview(containerView)
        containerView.addSubview(avatarView)
        avatarView.addSubview(image)
//        image.layer.cornerRadius = 43.33
//        image.layer.masksToBounds = true
        image.snp.makeConstraints { make in
            make.centerY.equalTo(avatarView.snp.centerY)
            make.size.equalTo(avatarView.snp.height).multipliedBy(0.4)
            make.bottom.equalTo(-80)
            make.centerX.equalToSuperview()
            
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.trailing.equalTo(containerView.snp.centerX).inset(10)
        }
        
        containerView.addSubview(lastNameLabel)
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.leading.equalTo(nameLabel.snp.trailing).offset(10)
        }
        
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: avatarView.widthAnchor).isActive = true
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerViewHeight.isActive = true
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarViewHeight = avatarView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        avatarViewHeight.isActive = true
        avatarViewBottom = avatarView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        avatarViewBottom.isActive = true
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        avatarViewBottom.constant = offsetY >= 0 ? 0 : -offsetY/2
        avatarViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
        
        image.layer.cornerRadius = image.bounds.height/2
        print(image.bounds.height/2)
        print(image.frame.size.height/2)
    }
}
