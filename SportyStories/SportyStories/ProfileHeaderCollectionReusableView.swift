//
//  ProfileHeaderCollectionReusableView.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 7/12/23.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    //actualiza vista, y agrega los datos a los campos
    func updateView() {
        self.username.text = "@" + user!.username!
        guard let profileImageUrl = user!.profileImageUrl else {return}
        self.avatar.loadImage(profileImageUrl)
    }
    
    func setupView() {
        avatar.layer.cornerRadius = 50
        editProfileButton.layer.borderColor = UIColor.lightGray.cgColor
        editProfileButton.layer.borderWidth = 0.8
        editProfileButton.backgroundColor = .white
        editProfileButton.layer.cornerRadius = 5
        favoriteButton.layer.borderColor = UIColor.lightGray.cgColor
        favoriteButton.layer.borderWidth = 0.8
        favoriteButton.backgroundColor = .white
        favoriteButton.layer.cornerRadius = 5
    }
}
