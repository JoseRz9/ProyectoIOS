//
//  ProfileViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 31/10/23.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //accion del boton cerrar sesion profil
    @IBAction func logoutAction(_ sender: Any) {
        Api.User.logOut() //mandamos a traer la funcion de UserApi
    }
    
}
