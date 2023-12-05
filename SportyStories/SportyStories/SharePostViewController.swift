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
