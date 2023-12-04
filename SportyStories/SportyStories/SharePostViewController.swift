//
//  SharePostViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 4/12/23.
//

import UIKit
import AVFoundation

class SharePostViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    let originalVideoUrl : URL
    var selectedPhoto: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init?(coder: NSCoder, videoUrl: URL){
        self.originalVideoUrl = videoUrl
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
