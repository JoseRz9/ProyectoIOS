//
//  PeopleTableViewCell.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 8/12/23.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    
    var user: User? {
        didSet {
            loadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func loadData() {
        self.usernameLabel.text = user?.username
        guard let profileImageUrl = user?.profileImageUrl else {return}
        avatar.loadImage(profileImageUrl)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        avatar.layer.cornerRadius = 25
    }

}
