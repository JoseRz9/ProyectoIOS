//
//  UserApi.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 17/10/23.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD

class UserApi{
    
    func signIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            print(authData?.user.uid)
            onSuccess()
        }
    }
    
    
    func signUp(withUsername username: String, email: String, password: String, image: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        
        guard let imageSelected = image else {
            //print("Avatar es null")
            ProgressHUD.showError("Por favor ingrese un avatar de perfil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        
        Auth.auth().createUser(withEmail: email, password: password){ authDataResult, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
             
            //columnas que llevara la tabla usuario
            if let authData = authDataResult {
                print(authData.user.email)
                
                //Llena las variables de la clase Ref
                var dict: Dictionary<String, Any> = [
                    UID: authData.user.uid,
                    EMAIL: authData.user.email as Any,
                    USER_NAME: username,
                    PROFILE_IMAGE_URL: "",
                    STATUS: ""
                ]
                
                // asignando ruta de donde se guardaran las imagenes
                //let storageRef = Storage.storage().reference(forURL: "gs://sportystories-910e8.appspot.com")
                //let storageProfileRef = storageRef.child("profile").child(authData.user.uid)
                
                let storageProfileRef = Ref().storagespesificProfile(uid: authData.user.uid)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                StorageService.savePhoto(username: username, uid: authData.user.uid, data: imageData, metadata: metadata, storageProfileRef: storageProfileRef, dict: dict) {
                    onSuccess()
                } onError: { errorMessage in
                    onError(errorMessage)
                }

            }
        }
    }
    
    func saveUserProfile(dict: Dictionary<String,Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Ref().databaseRoot.child("users").child(uid).updateChildValues(dict){ error, dataRef in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    //muestra informacion del usuariop
    func observeUser(withId uid: String, completion: @escaping (User) -> Void) {
        Ref().databaseRoot.child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    //llenando campos de usuario al cargar ventana user (Obtiene)
    func observeProfileUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Ref().databaseRoot.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    func observeUsers(completion: @escaping (User) -> Void) {
        Ref().databaseRoot.child("users").observe(.childAdded) { snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        }
    }
    
    func logOut(){
        do{
            try Auth.auth().signOut()
        }catch{
            ProgressHUD.showError(error.localizedDescription)
            return
        }
        let scene = UIApplication.shared.connectedScenes.first
        if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate){
            sd.configureInitialViewController()
        }
    }
    
    func deleteAccount(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let storage = Ref().storageRoot
        let ref = Ref().databaseRoot
        
        ref.child("users").child(uid).removeValue { error, ref in
            if error != nil {
                ProgressHUD.showError()
            }
        }
        Auth.auth().currentUser?.delete { error in
            if error != nil {
                ProgressHUD.showError()
            }
        }
        let profileRef = storage.child("profile").child(uid)
        profileRef.delete { error in
            if error != nil {
                ProgressHUD.showError()
            } else {
                ProgressHUD.showSuccess()
            }
        }
    }
}
