//
//  PostProfileCollectionViewCell.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 7/12/23.
//

import UIKit

class PostProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImage: UIImageView!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        guard let postThumbnailImageUrl = post!.imageUrl else {return}
        self.postImage.loadImage(postThumbnailImageUrl)
    }
}
