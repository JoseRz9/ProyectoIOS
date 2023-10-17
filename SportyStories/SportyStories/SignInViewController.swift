//
//  SignInViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 16/10/23.
//

import UIKit

class SignInViewController: UIViewController {

    
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfiel: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupEmailTextfield()
        setupPaswwordTextfield()
        setupView()

    }
    
    // Creando un titulo para la nueva pestaña de crear cuenta
    func setupNavigationBar(){
        navigationItem.title = "Ingresar"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    // Areglando diseño del textbox de email
    func setupEmailTextfield(){
        emailContainerView.layer.borderWidth = 1
        emailContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        emailContainerView.layer.cornerRadius = 20
        emailContainerView.clipsToBounds = true
        emailTextfield.borderStyle = .none
    }
    
    // Areglando diseño del textbox de password
    func setupPaswwordTextfield(){
        passwordContainerView.layer.borderWidth = 1
        passwordContainerView.layer.borderColor = CGColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 0.8)
        passwordContainerView.layer.cornerRadius = 20
        passwordContainerView.clipsToBounds = true
        passwordTextfiel.borderStyle = .none
    }
    
    func setupView(){
        signInButton.layer.cornerRadius = 18
    }
}
