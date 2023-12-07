//
//  PreviewCapturedViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 1/12/23.
//

import UIKit
import AVKit

class PreviewCapturedViewController: UIViewController {

    var currentlyPlayingVideoClip: VideoClips
    let recordedClips: [VideoClips]
    var viewWillDenitRestarVideoSession: (() -> Void)?
    var player: AVPlayer = AVPlayer()
    var playerLayer: AVPlayerLayer = AVPlayerLayer()
    var urlsForVids:  [URL] = [] {
        didSet {
            print("outputURLunwrapped:", urlsForVids)
        }
    }
    
    var hideStatusBar: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleStartPlayingFirstClip()
        hideStatusBar = true
        recordedClips.forEach { clip in
            urlsForVids.append(clip.videoUrl)
        }
        print("\(recordedClips.count)")
    }
    
    //funciones que cambian el estado a solo toda la ventana cuando capturala iamgen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
        player.play()
        hideStatusBar = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
        player.pause()
        
    }
    
    deinit {
        print("PreviewCaptureVideoVC wa deineted")
        (viewWillDenitRestarVideoSession)?()
    }
    
    
    
    init?(coder: NSCoder, recordedClips: [VideoClips]) {
        self.currentlyPlayingVideoClip = recordedClips.first!
        self.recordedClips = recordedClips
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleStartPlayingFirstClip() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard let firstClip = self.recordedClips.first else {return}
            self.currentlyPlayingVideoClip = firstClip
            self.setupPlayerView(with: firstClip)
        }
    }
    
    func setupView() {
        nextButton.layer.cornerRadius = 2
        nextButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 88/255, alpha: 1.0)
    }
    
    func setupPlayerView(with videoClip: VideoClips){
        let player = AVPlayer(url: videoClip.videoUrl)
        let playerLayer = AVPlayerLayer(player: player)
        self.player = player
        self.playerLayer = playerLayer
        playerLayer.frame = thumbnailImageView.frame
        self.player = player
        self.playerLayer = playerLayer
        thumbnailImageView.layer.insertSublayer(playerLayer, at: 3)
        player.play()
        NotificationCenter.default.addObserver(self, selector: #selector(avPlayerItemDidPlayToEndTime(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        handleMirrorPlayer(cameraPosition: videoClip.cameraPosition)
    }
    
    func removePeriodicTimeObserver() {
        player.replaceCurrentItem(with: nil)
        playerLayer.removeFromSuperlayer()
    }
    
    @objc func avPlayerItemDidPlayToEndTime(notification: Notification) {
        if let currentIndex = recordedClips.firstIndex(of: currentlyPlayingVideoClip) {
            let nextIndex = currentIndex + 1
            if nextIndex > recordedClips.count - 1 {
                removePeriodicTimeObserver()
                guard let firstClip = recordedClips.first else {return}
                setupPlayerView(with: firstClip)
                currentlyPlayingVideoClip = firstClip
            } else {
                for (index,clip) in recordedClips.enumerated(){
                    if index == nextIndex  {
                        removePeriodicTimeObserver()
                        setupPlayerView(with: clip)
                        currentlyPlayingVideoClip = clip
                    }
                }
            }
        }
    }
    
    func handleMirrorPlayer(cameraPosition: AVCaptureDevice.Position) {
        if cameraPosition == .front {
            thumbnailImageView.transform = CGAffineTransform(scaleX: -1, y: -1)
        } else {
            thumbnailImageView.transform = .identity
        }
    }
    

    @IBAction func cancelButtonDidTapped(_ sender: Any) {
        hideStatusBar = true
        navigationController?.popViewController(animated: true)
    }
    
    func handleMargeClips(){
        //ejecutando funcion de clase videoCompositionwrite
        VideoCompositionWriter().mergeMultipleVideo(urls: urlsForVids) { success, outputURL in
            if success {
                guard let outputURLunwrapped = outputURL else {return}
                print("outputURLunwrapped:", outputURLunwrapped)
                
                DispatchQueue.main.async {
                    let player = AVPlayer(url: outputURLunwrapped)
                    let vc = AVPlayerViewController()
                    vc.player = player
                    
                    self.present(vc,animated: true){
                        vc.player?.play()
                    }
                }
            }
        }
    }
    
    @IBAction func nextButtonDidTapped(_ sender: Any) {
        handleMargeClips()
        hideStatusBar = false
        let shareVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "SharePostViewController", creator: { coder -> SharePostViewController? in
            SharePostViewController(coder: coder, videoUrl: self.currentlyPlayingVideoClip.videoUrl)
        })
        shareVC.selectedPhoto = thumbnailImageView.image
        navigationController?.pushViewController(shareVC, animated: true)
        return
    }
}
