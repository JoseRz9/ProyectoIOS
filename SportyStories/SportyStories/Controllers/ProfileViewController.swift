//
//  ProfileViewController.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 31/10/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var user: User!
    var posts: [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        fetchUser() //Ejecuta la funcion
        fetchMyPosts()
    }
    
    func fetchMyPosts() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Ref().databaseRoot.child("User-Posts").child(uid).observe(.childAdded) { snapshot in
            Api.Post.observeSinglePost(postId: snapshot.key) { post in
                print(post.postId)
                self.posts.append(post)
                self.collectionView.reloadData()
            }
        }
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

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 1
        return posts.count //muestra los videos que hayan
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostProfileCollectionViewCell", for: indexPath) as! PostProfileCollectionViewCell
        let post = posts[indexPath.item]
        cell.post = post
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width / 3 - 2, height: size.height / 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
