//
//  CreatePostViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 31/10/23.
//

import UIKit
import AVFoundation

class CreatePostViewController: UIViewController {

    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var captureButtonRingView: UIView!
    
    let photoFileOutput = AVCapturePhotoOutput()
    let captureSesion = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if setupCaptureSession(){
            DispatchQueue.global(qos: .background).async {
                self.captureSesion.startRunning()
            }
        }
        setupView()
        
    }
    
    //funciones que cambian el estado a solo toda la ventana cuando capturala iamgen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func setupView(){
        captureButton.backgroundColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 1.0)
        captureButton.layer.cornerRadius = 68/2
        captureButtonRingView.layer.borderColor = UIColor(red: 254/255, green: 44/255, blue: 85/255, alpha: 0.5).cgColor
        captureButtonRingView.layer.borderWidth = 6
        captureButtonRingView.layer.cornerRadius = 85/2
        
        captureButton.layer.zPosition = 1
        captureButtonRingView.layer.zPosition = 1
        cancelButton.layer.zPosition = 1
    }
    
    func setupCaptureSession() -> Bool {
        captureSesion.sessionPreset = AVCaptureSession.Preset.high
        
        //1. Entradas de configuracion
        if let captureVideoDevice = AVCaptureDevice.default(for: AVMediaType.video),
           let captureAudioDevice = AVCaptureDevice.default(for: AVMediaType.audio){
            do{
                let inputVideo = try AVCaptureDeviceInput(device: captureVideoDevice)
                let inputAudio = try AVCaptureDeviceInput(device: captureAudioDevice)
                
                if captureSesion.canAddInput(inputVideo){
                    captureSesion.addInput(inputVideo)
                }
                if captureSesion.canAddInput(inputAudio){
                    captureSesion.addInput(inputAudio)
                }
            } catch let error {
                print("No se pudo configurar la entrada de la camara:", error)
                return false
            }
        }
        //2. salidas de configuracion
        if captureSesion.canAddOutput(photoFileOutput){
            captureSesion.addOutput(photoFileOutput)
        }
        
        // 3. configurar vistas previas de salidas
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSesion)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        return true
    }
  
}
