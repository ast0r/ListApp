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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
            
//            cell.favoriteButton.addTarget(self, action: #selector(favoriteState(parametrSender:)), for: .touchUpInside)
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
    
    
//    @objc func favoriteState(parametrSender: UIButton) {
//        let view = parametrSender.self.superview as? UITableView
//        
//        //let indexPath = parametrSender.tag
//        guard let indexPath = view?.indexPath(for: self )else {return}
//        let user = userArray[indexPath]
//        
//        if DataWork.checkConsistUser(userId: user.id) {
//            DataWork.deleteUser(userId: user.id)
//            let imageNotFill = UIImage(systemName: "star")
//            parametrSender.setImage(imageNotFill, for: .normal)
//        } else {
//            //saveDelegate?.saveUserToFavorite(idCell: indexPath)
//            DataWork.createData(newUser: user)
//            let imageFill = UIImage(systemName: "star.fill")
//            parametrSender.setImage(imageFill, for: .normal)
//        }
//    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension MainTableViewController: removeUserFromFavoriteDelegate, saveUserToFavoriteDelegate {
    
    func removeUserFromFavorite(idCell: IndexPath) {
        let user = userArray[idCell.row]
        DataWork.deleteUser(userId: user.id)
        tableView.reloadData()
    }
    
    func saveUserToFavorite(idCell: IndexPath) {
        let user = userArray[idCell.row]
        DataWork.createData(newUser: user)
    }
    
}
