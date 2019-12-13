//
//  MainTableViewController.swift
//  ListApp
//
//  Created by Pavel Ivanov on 12/11/19.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    //MARK: - Variable
    var userArray = [User]()
    var isChecked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "userCell")
        fetch()
    }
    
    //Load data
    func fetch() {
        FetchData.fetch { (data) in
            DispatchQueue.main.async {
                self.userArray = data.data
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell {
            
            let user = userArray[indexPath.row]
            if DataWork.checkConsistUser(userId: user.id) {
                let imageFill = UIImage(systemName: "star.fill")
                cell.favoriteButton.setImage(imageFill, for: .normal)
                isChecked = true
            } else {
                let imageNotFill = UIImage(systemName: "star")
                cell.favoriteButton.setImage(imageNotFill, for: .normal)
                isChecked = false
            }
            cell.saveDelegate = self
            cell.removeDelegate = self
            cell.user = user
            return cell
        }
        return UserTableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewVC = DetailViewController()
        detailViewVC.user = userArray[indexPath.row]
        self.navigationController?.pushViewController(detailViewVC, animated: true)
    }
}
//MARK: - removeUserFromFavoriteDelegate
extension MainTableViewController: removeUserFromFavoriteDelegate {
    
    func removeUserFromFavorite(idCell: IndexPath) {
        let user = userArray[idCell.row]
        DataWork.deleteUser(userId: user.id)
        tableView.reloadData()
    }
}

//MARK: - saveUserToFavoriteDelegate
extension MainTableViewController: saveUserToFavoriteDelegate {
    func saveUserToFavorite(idCell: IndexPath) {
        let user = userArray[idCell.row]
        DataWork.createData(newUser: user)
    }
}
