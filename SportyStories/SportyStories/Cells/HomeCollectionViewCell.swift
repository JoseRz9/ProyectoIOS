//
//  HomeCollectionViewCell.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 5/12/23.
//

import UIKit
import AVFoundation

protocol HomeCollectionViewCellDelegate {
    func goToProfileUserVC(userId: String)
}

class HomeCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var postVideo: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var queuePlayer: AVQueuePlayer?
    var playerLayer: AVPlayerLayer?
    var playbackLooper: AVPlayerLooper?
    var isPlaying = false
    var delegate: HomeCollectionViewCellDelegate?
    
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
        let tapGestureForAvatar = UITapGestureRecognizer(target: self, action:  #selector(avatar_TouchUpInside))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tapGestureForAvatar)
        avatar.clipsToBounds = true
    }
    
    @objc func avatar_TouchUpInside() {
        if let id = user?.uid {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        queuePlayer?.pause()
    }
    
    func updateView(){
        descriptionLabel.text = post?.description
        if let videoUrlString = post?.videoUrl, let videoUrl = URL(string: videoUrlString) {
            let playerItem = AVPlayerItem(url: videoUrl)
            self.queuePlayer = AVQueuePlayer(playerItem: playerItem)
            self.playerLayer = AVPlayerLayer(player: self.queuePlayer)
            
            guard let playerLayer = self.playerLayer else {return}
            guard let queuePlayer = self.queuePlayer else {return}
            
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = contentView.bounds
            postVideo.layer.insertSublayer(playerLayer, at: 3)
            queuePlayer.play()
        }
    }
    
    func setupUserInfo() {
        usernameLabel.text = user?.username
        guard let profileImageUrl = user?.profileImageUrl else {return}
        avatar.loadImage(profileImageUrl)
    }
    
    func replay() {
        if !isPlaying {
            self.queuePlayer?.seek(to: .zero)
            self.queuePlayer?.play()
            play()
        }
    }
    
    func play() {
        if !isPlaying {
            self.queuePlayer?.play()
            isPlaying = true
        }
    }
    
    func pause() {
        if isPlaying {
            self.queuePlayer?.pause()
            isPlaying = false
        }
    }
    
    func stop() {
        self.queuePlayer?.pause()
        self.queuePlayer?.seek(to: CMTime.init(seconds: 0, preferredTimescale: 1))
    }
}
