//
//  HomeCollectionViewCell.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 5/12/23.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var avatar: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.layer.cornerRadius = 55/2
    }
}
