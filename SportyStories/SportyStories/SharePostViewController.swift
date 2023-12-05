//
//  SharePostViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 4/12/23.
//

import UIKit
import AVFoundation

class SharePostViewController: UIViewController {
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var draftsButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    
    let originalVideoUrl : URL
    var selectedPhoto: UIImage?
    
    let placeholder = "Please write a description"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        textViewDidChanged()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        if let thumbnailImage = self.thumbnailImageForFileUrl(originalVideoUrl) {
            self.selectedPhoto = thumbnailImage.imageRotated(by: .pi/2)
            thumbnailImageView.image = thumbnailImage.imageRotated(by: .pi/2)
        }
    }
    
    func thumbnailImageForFileUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 7, timescale: 1), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    //funciones que cambian el estado a solo toda la ventana cuando capturala iamgen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    init?(coder: NSCoder, videoUrl: URL){
        self.originalVideoUrl = videoUrl
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        draftsButton.layer.borderColor = UIColor.lightGray.cgColor
        draftsButton.layer.borderWidth = 0.3
    }
    
    
}

extension SharePostViewController: UITextViewDelegate {
    func textViewDidChanged() {
        textView.delegate = self
        textView.text = placeholder
        textView.textColor = .lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
}

extension UIImage {
    func imageRotated(by radian: CGFloat) -> UIImage{
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radian))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radian)
            draw(in: CGRect(x: -origin.y, y: -origin.x, width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return rotatedImage ?? self
        }
        return self
    }
}
