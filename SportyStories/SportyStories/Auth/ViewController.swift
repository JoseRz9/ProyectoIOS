//
//  ViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 25/8/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //funcion para aplicar las esquinas redonditas de los botones
    func setupView(){
        facebookButton.layer.cornerRadius = 18
        signButton.layer.cornerRadius = 18
        googleButton.layer.cornerRadius = 18
        loginButton.layer.cornerRadius = 18
    }

    // evento al puchear el boton de ingresar con e-mail
    @IBAction func singUpDidTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @IBAction func signInDitTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

