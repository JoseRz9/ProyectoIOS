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
}
