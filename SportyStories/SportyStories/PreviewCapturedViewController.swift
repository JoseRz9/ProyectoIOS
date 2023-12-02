//
//  PreviewCapturedViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 1/12/23.
//

import UIKit

class PreviewCapturedViewController: UIViewController {

    var currentlyPlayingVideoClip: VideoClips
    let recordedClips: [VideoClips]
    var viewWillDenitRestarVideoSession: (() -> Void)?
    
    deinit {
        print("PreviewCaptureVideoVC wa deineted")
        (viewWillDenitRestarVideoSession)?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("\(recordedClips.count)")
    }
    
    init?(coder: NSCoder, recordedClips: [VideoClips]) {
        self.currentlyPlayingVideoClip = recordedClips.first!
        self.recordedClips = recordedClips
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
