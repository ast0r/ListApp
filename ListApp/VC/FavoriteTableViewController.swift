//
//  FavoriteTableViewController.swift
//  ListApp
//
//  Created by Pavel Ivanov on 12/11/19.
//  Copyright © 2019 Pavel Ivanov. All rights reserved.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    //MARK: - Variable
    var favoriteUsers : [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "userCell")        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteUsers = DataWork.fetchAllData()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteUsers.count
    }
    
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserTableViewCell {
            cell.removeDelegate = self
            cell.user = favoriteUsers[indexPath.row]
            
            return cell
        }
        return UserTableViewCell()
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewVC = DetailViewController()
        detailViewVC.user = favoriteUsers[indexPath.row]
        self.navigationController?.pushViewController(detailViewVC, animated: true)
    }
}

//MARK: - removeUserFromFavoriteDelegate
extension FavoriteTableViewController: removeUserFromFavoriteDelegate {
    
    func removeUserFromFavorite(idCell: IndexPath) {
        let user = favoriteUsers[idCell.row]
        DataWork.deleteUser(userId: user.id)
        favoriteUsers.remove(at: idCell.row)
        tableView.reloadData()
    }
}
