//
//  StorageService.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 17/10/23.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import ProgressHUD

class StorageService{
    static func savePhoto(username: String, uid: String, data: Data, metadata: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String, Any>,onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void){
        
        storageProfileRef.putData(data,metadata: metadata){ storageMetaData, error in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            storageProfileRef.downloadURL{ url, error in
                if let metaImageUrl = url?.absoluteString{
                    print(metaImageUrl)
                    
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest(){
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges { error in
                            if let error = error {
                                ProgressHUD.showError(error.localizedDescription)
                            }
                        }
                    }
                    
                    var dictTemp = dict
                    dictTemp["profileImageUrl"] = metaImageUrl
                    // creacion de tabla usuario con sus columnas
                    //Database.database().reference().child("users").child(uid)
                    Ref().databaseSpesificUser(uid: uid).updateChildValues(dictTemp) {error, ref in
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
