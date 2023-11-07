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
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var flipCameraLabel: UILabel!
    
    
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
        
        flipCameraButton.layer.zPosition = 1
        flipCameraLabel.layer.zPosition = 1
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
  
    
    //Accion Boton de Voltear Camara
    @IBAction func flipButtonDidTapped(_ sender: Any) {
        captureSesion.beginConfiguration()
        
        let currentInput = captureSesion.inputs.first as? AVCaptureDeviceInput
        let newCameraDevice = currentInput?.device.position == .back ? getDeviceFront(position: .front) : getDeviceBack(position: .back)
        
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        
        if let inputs = captureSesion.inputs as? [AVCaptureDeviceInput]{
            for input in inputs {
                captureSesion.removeInput(input)
            }
        }
        
        if captureSesion.inputs.isEmpty{
            captureSesion.addInput(newVideoInput!)
        }
        
        captureSesion.commitConfiguration()
    }
    
    //Obteniene la camara frontal del dispositivo
    func getDeviceFront(position: AVCaptureDevice.Position) -> AVCaptureDevice?{
        AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
    }
    
    
    //Regresa a la camara principal
    func getDeviceBack(position: AVCaptureDevice.Position) -> AVCaptureDevice?{
        AVCaptureDevice.default(.builtInWideAngleCamera, for:  .video, position: .back)
    }
    
    //Accion Boton de Cancelar X
    @IBAction func handleDismiss(_ sender: Any) {
        tabBarController?.selectedIndex = 0
    }
    
    
}
