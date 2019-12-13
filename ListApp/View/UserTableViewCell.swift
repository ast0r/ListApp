//
//  UserTableViewCell.swift
//  ListApp
//
//  Created by Pavel Ivanov on 12/11/19.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

protocol saveUserToFavoriteDelegate {
    func saveUserToFavorite(idCell: IndexPath)
}

protocol removeUserFromFavoriteDelegate {
    func removeUserFromFavorite(idCell: IndexPath)
}

class UserTableViewCell: UITableViewCell {
    
    let avatarImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        //img.image = UIImage(named: "defaultImage")
        
        return img
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let imageNotFill = UIImage(systemName: "star")
        button.tintColor = UIColor(named: "myColor")
        button.setImage(imageNotFill, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    
    //MARK: - Variable
    var saveDelegate: saveUserToFavoriteDelegate?
    var removeDelegate: removeUserFromFavoriteDelegate?
    var isChecked = false
    
    var user : User? {
        
        didSet {
            guard let userItem = user else {return}
            
            if let name = userItem.first_name {
                nameLabel.text = name
            }
            
            if let detail = userItem.email {
                detailLabel.text = "\(detail) texttexttexttexttexttexttexttexttexttexttexttext "
            }
            
            guard let imageUrl = DataWork.getImageUrl(urlString: userItem.avatar) else {return}
            DispatchQueue.main.async {
                self.avatarImageView.af_setImage(withURL: imageUrl)
            }
            
            if DataWork.checkConsistUser(userId: user?.id) {
                let imageFill = UIImage(systemName: "star.fill")
                favoriteButton.setImage(imageFill, for: .normal)
                isChecked = true
            } else {
                let imageNotFill = UIImage(systemName: "star")
                favoriteButton.setImage(imageNotFill, for: .normal)
                isChecked = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(detailLabel)
        favoriteButton.addTarget(self, action: #selector(favoriteState), for: .touchUpInside)
        contentView.addSubview(favoriteButton)
        
        constraintInit()
        
    }
    
    @objc func favoriteState(sender: UIButton!) {
        
        let view = self.superview as? UITableView
        
        guard let indexPath = view?.indexPath(for: self )else {return}
        
        if isChecked {
            removeDelegate?.removeUserFromFavorite(idCell: indexPath)
            let imageNotFill = UIImage(systemName: "star")
            sender.setImage(imageNotFill, for: .normal)
            isChecked = false
        } else {
            saveDelegate?.saveUserToFavorite(idCell: indexPath)
            let imageFill = UIImage(systemName: "star.fill")
            sender.setImage(imageFill, for: .normal)
            isChecked = true
        }
    }
    
    func constraintInit() {
        //Avatar
        avatarImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        avatarImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 4/3).isActive = true
        
        //Name
        nameLabel.topAnchor.constraint(equalTo: self.avatarImageView.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.avatarImageView.rightAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.favoriteButton.leftAnchor, constant: -10).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: self.detailLabel.topAnchor, constant: 8).isActive = true
        
        //Detail
        detailLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 8).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: self.nameLabel.leftAnchor).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: self.nameLabel.rightAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        //button
        favoriteButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        favoriteButton.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        favoriteButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        
        favoriteButton.leftAnchor.constraint(equalTo: self.nameLabel.rightAnchor, constant: 15).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   
}
