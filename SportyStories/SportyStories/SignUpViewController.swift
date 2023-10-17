//
//  SignUpViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 28/8/23.
//

import UIKit
import FirebaseAuth

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
    }
    
    
    @IBAction func signUpDidTapped(_ sender: Any) {
        Auth.auth().createUser(withEmail: "davidramirez04@mail.com", password: "Utec001"){ authDataResult, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            //HOLA PRUEBA
            if let authData = authDataResult {
                print(authData.user.email)
            }
        }
    }
}

