//
//  StretchyTableHeaderView.swift
//  PhoneBook
//
//  Created by SalemMacPro on 2.6.21.
//

import UIKit
import SnapKit

final class StretchyTableHeaderView: UIView {

    let avatarView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        //image.layer.cornerRadius = 45
        return image
    }()
    
    private var imageViewHeight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        addSubview(containerView)
        containerView.addSubview(avatarView)
    }
    
    func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        
        
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView){
        
    }
    
}
