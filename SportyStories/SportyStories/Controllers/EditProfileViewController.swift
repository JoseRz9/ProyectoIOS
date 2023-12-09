//
//  EditProfileViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 8/12/23.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class EditProfileViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        observeData()
    }
    
    func setupView() {
        avatar.layer.cornerRadius = 50
        logoutButton.layer.cornerRadius = 35/2
        avatar.contentMode = .scaleAspectFill
    }
    
    func observeData() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Api.User.observeUser(withId: uid) { user in
            self.usernameTextfield.text = user.username
            self.avatar.loadImage(user.profileImageUrl)
        }
    }
    
    @IBAction func saveButtonDidTapped(_ sender: Any) {
        var dict = Dictionary<String,Any>()
        if let username = usernameTextfield.text, !username.isEmpty {
            dict["username"] = username
        }
        Api.User.saveUserProfile(dict: dict) {
            ProgressHUD.showSuccess()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
        } onError: { errorMessage in
            ProgressHUD.showError(errorMessage)
        }

    }
    
    @IBAction func deleteAccountDidTapped(_ sender: Any) {
        Api.User.deleteAccount()
        Api.User.logOut()
    }
    @IBAction func logoutButtonDidTapped(_ sender: Any) {
        Api.User.logOut()
    }
}
