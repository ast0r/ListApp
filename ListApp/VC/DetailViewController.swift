//
//  DetailViewController.swift
//  ListApp
//
//  Created by Pavel Ivanov on 12/11/19.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //MARK: - Variable
    var user = User()
    var isChecked = false
    
    let avatarImageView: UIImageView = {
        let img = UIImageView(frame: .zero)
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
        label.numberOfLines = 0
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Detail"
        view.backgroundColor = .white
        
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(detailLabel)
        favoriteButton.addTarget(self, action: #selector(favoriteState), for: .touchUpInside)
        view.addSubview(favoriteButton)
        
        constraintView()
        
        initDetail(user: user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initDetail(user: user)
    }
    
    @objc func favoriteState(sender: UIButton!) {
        
        if isChecked == true {
            DataWork.deleteUser(userId: user.id)
            let imageNotFill = UIImage(systemName: "star")
            favoriteButton.setImage(imageNotFill, for: .normal)
            isChecked = false
            
        } else {
            DataWork.createData(newUser: user)
            let imageFill = UIImage(systemName: "star.fill")
            favoriteButton.setImage(imageFill, for: .normal)
            isChecked = true
        }
    }
    
    func initDetail(user: User) {
        guard let first_name = user.first_name else { return }
        guard let last_name = user.last_name else { return }
        
        nameLabel.text = "\(first_name) \(last_name)"
        detailLabel.text = "\(user.email!) textetxtettextetxtettextetxtettextetxtettextetxtettextetxtet"
        
        guard let imageUrl = DataWork.getImageUrl(urlString: user.avatar) else {return}
        DispatchQueue.main.async {
            self.avatarImageView.af_setImage(withURL: imageUrl)
        }
        
        if DataWork.checkConsistUser(userId: user.id) {
            let imageFill = UIImage(systemName: "star.fill")
            favoriteButton.setImage(imageFill, for: .normal)
            isChecked = true
        } else {
            let imageNotFill = UIImage(systemName: "star")
            favoriteButton.setImage(imageNotFill, for: .normal)
            isChecked = false
        }
    }
    
    func constraintView() {
        
        //Avatar
        avatarImageView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        avatarImageView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor, multiplier: 16/9).isActive = true
        //Name
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 90).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        //Detail
        detailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        detailLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        detailLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        //button
        favoriteButton.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: -70).isActive = true
        favoriteButton.rightAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: -10).isActive = true
    }
}
