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
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = Images.userImage
        image.tintColor = .gray
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .base3
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
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
        nameLabel.text = (name ?? "") + " " + (lastName ?? "")
        if let contactImage = avatar {
            image.image = contactImage
        } else {
            image.image = Images.userImage
        }
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
            make.centerX.equalToSuperview()
            
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom)
            make.centerX.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview().inset(16)
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
