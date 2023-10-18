//
//  SignUpViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 28/8/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import PhotosUI
import ProgressHUD //mensjaes de validacion

class SignUpViewController: UIViewController {

    @IBOutlet weak var avatar: UIImageView!

    // Textbox Usuario
    @IBOutlet weak var usernameContainerView: UIView!
    @IBOutlet weak var usernameTextfield: UITextField!
    
    // Textbox Email
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextfiel: UITextField!
    
    // Textbox password
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    // Boton de Ingresar
    @IBOutlet weak var signUpButton: UIButton!
    
    //creando variable image
    var image: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUserNameTextfield()
        setupEmailTextfield()
        setupPaswwordTextfield()
        setupView()
    }
    
    // Creando un titulo para la nueva pestaña de crear cuenta
    func setupNavigationBar(){
        navigationItem.title = "Crear Nueva Nuenta"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // Areglando diseño del textbox de usuario
    func setupUserNameTextfield(){
        usernameContainerView.layer.borderWidth = 1
        usernameContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        usernameContainerView.layer.cornerRadius = 20
        usernameContainerView.clipsToBounds = true
        usernameTextfield.borderStyle = .none
    }

    // Areglando diseño del textbox de email
    func setupEmailTextfield(){
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        emailContainerView.layer.cornerRadius = 20
        emailContainerView.clipsToBounds = true
        emailTextfiel.borderStyle = .none
    }
    
    // Areglando diseño del textbox de password
    func setupPaswwordTextfield(){
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        passwordContainerView.layer.cornerRadius = 20
        passwordContainerView.clipsToBounds = true
        passwordTextfield.borderStyle = .none
    }
    
    func setupView(){
        avatar.layer.cornerRadius = 60
        signUpButton.layer.cornerRadius = 18
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    
    //funcion valida campos
    func validateFields(){
        guard let username = self.usernameTextfield.text, !username.isEmpty else{
            //print("Por favor ingrese usuario")
            ProgressHUD.showError("Por favor ingrese usuario")
            return
        }
        
        guard let email = self.emailTextfiel.text, !email.isEmpty else{
            //print("Por favor ingrese email")
            ProgressHUD.showError("Por favor ingrese email")
            return
        }
        
        guard let password = self.passwordTextfield.text, !password.isEmpty else{
            //print("Por favor ingrese password")
            ProgressHUD.showError("Por favor ingrese password")
            return
        }
    }
    
    //Accion boton Inscribirse
    @IBAction func signUpDidTapped(_ sender: Any) {
        self.validateFields()
        self.signUp()
        
    }
}

extension SignUpViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for item in results{
            item.itemProvider.loadObject(ofClass: UIImage.self){image, error in
                if let imageSelected = image as? UIImage{
                    DispatchQueue.main.async {
                        self.avatar.image = imageSelected // asigna la imagen seleccionada al circulo del diseño
                        self.image = imageSelected // asigna imagen seleccionada a la variable image
                    }
                }
            }
        }
        dismiss(animated: true)
    }
    
    @objc func presentPicker(){
        var configuration: PHPickerConfiguration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 1 // Asigna un limite de imagenes que puede seleccionar
        
        let picker: PHPickerViewController = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated:  true)
    }
}

extension SignUpViewController{
    func signUp(){ //ejecuta la clase de la Api y luego ejecuta la funcion que se encuentra en User Api
        Api.User.signUp(withUsername: self.usernameTextfield.text!, email: self.emailTextfiel.text!, password: self.passwordTextfield.text!, image: self.image) {
            print("Correcto")
        } onError: { errorMessage in
            print(errorMessage)
        }

    }
}
