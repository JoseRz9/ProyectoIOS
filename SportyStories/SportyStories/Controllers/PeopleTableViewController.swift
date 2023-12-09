//
//  PeopleTableViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 8/12/23.
//

import UIKit

class PeopleTableViewController: UITableViewController {

    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()
    }
    
    func fetchUser() {
        Api.User.observeUsers { user in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 10
        return self.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PeopleTableViewCell
        
        //cell.usernameLabel.text = "Usuario 1"
        //cell.avatar.image = UIImage(named: "profile_imagen")
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

}
