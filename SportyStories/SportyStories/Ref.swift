//
//  Ref.swift
//  SportyStories
//
//  Created by JOSE DAVID RAMIREZHERNANDEZ on 17/10/23.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

let REF_USER = "users"
let STORAGE_PROFILE = "profile"
let URL_STORAGE_ROOT = "gs://sportystories-910e8.appspot.com"

let EMAIL = "email"
let UID = "uid"
let USER_NAME = "username"
let PROFILE_IMAGE_URL = "profileImageUrl"
let STATUS = "status"


class Ref {
    let databaseRoot = Database.database().reference()
    
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpesificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    
    //Storage Ref
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    
    
    func storagespesificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
}
