//
//  PeopleTableViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 8/12/23.
//

import UIKit

class PeopleTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var users: [User] = []
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    var searchResults: [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUser()
        
        setupSearchController()
    }
    
    // control filtra usuarios
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Busqueda de usuario..."
        searchController.searchBar.barTintColor = UIColor.white
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func fetchUser() {
        Api.User.observeUsers { user in
            self.users.append(user)
            self.tableView.reloadData()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text == nil || searchController.searchBar.text!.isEmpty {
            view.endEditing(true)
        } else {
            let textLowercased = searchController.searchBar.text!.lowercased()
            filterContent(for: textLowercased)
        }
        tableView.reloadData()
    }
    
    func filterContent(for searchText: String) {
        searchResults = self.users.filter{
            return $0.username!.lowercased().range(of: searchText) != nil
        }
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? searchResults.count : self.users.count
        
        //return 10
       // return self.users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath) as! PeopleTableViewCell
        
        //cell.usernameLabel.text = "Usuario 1"
        //cell.avatar.image = UIImage(named: "profile_imagen")
        let user = searchController.isActive ? searchResults[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? PeopleTableViewCell {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileUserVC = storyboard.instantiateViewController(withIdentifier: "ProfileUserViewController") as! ProfileUserViewController
            profileUserVC.userId = cell.user!.uid!
            self.navigationController?.pushViewController(profileUserVC, animated: true)
        }
    }
}
