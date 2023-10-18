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
                var dict: Dictionary<String, Any> = [
                    "uid": authData.user.uid,
                    "email": authData.user.email,
                    "username": username,
                    "profileImageUrl": "",
                    "status": ""
                ]
                
                // asignando ruta de donde se guardaran las imagenes
                let storageRef = Storage.storage().reference(forURL: "gs://sportystories-910e8.appspot.com")
                let storageProfileRef = storageRef.child("profile").child(authData.user.uid)
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                storageProfileRef.putData(imageData,metadata: metadata){ storageMetaData, error in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    storageProfileRef.downloadURL{ url, error in
                        if let metaImageUrl = url?.absoluteString{
                            print(metaImageUrl)
                            dict["profileImageUrl"] = metaImageUrl
                            
                            // creacion de tabla usuario con sus columnas
                            Database.database().reference().child("users").child(authData.user.uid).updateChildValues(dict) {error, ref in
                                if error == nil {
                                    onSuccess()
                                }else{
                                    onError(error!.localizedDescription)
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
}
