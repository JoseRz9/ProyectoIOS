//
//  ProfileViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 31/10/23.
//

import UIKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        fetchUser() //Ejecuta la funcion
    }
    
    //funcion que obtiene datos de usuario
    func fetchUser() {
        Api.User.observeProfileUser { user in
            self.user = user
            self.collectionView.reloadData()
        }
    }
    
    //accion del boton cerrar sesion profil
    @IBAction func logoutAction(_ sender: Any) {
        Api.User.logOut() //mandamos a traer la funcion de UserApi
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCollectionViewCell", for: indexPath) as! PostProfileCollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerViewCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileHeaderCollectionReusableView", for: indexPath) as!ProfileHeaderCollectionReusableView
            if let user = self.user {
                headerViewCell.user = user
            }
            headerViewCell.setupView()
            return headerViewCell
        }
        return UICollectionReusableView()
    }
    
}
