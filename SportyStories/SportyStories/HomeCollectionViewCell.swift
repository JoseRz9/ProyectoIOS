//
//  HomeCollectionViewCell.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 5/12/23.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var postVideo: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = 55/2
    }
    
    func updateView(){
        descriptionLabel.text = post?.description
    }
    
    func setupUserInfo() {
        usernameLabel.text = user?.username
        guard let profileImageUrl = user?.profileImageUrl else {return}
        avatar.loadImage(profileImageUrl)
    }
}
