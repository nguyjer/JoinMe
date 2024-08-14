//
//  AuthManager.swift
//  JoinMeApp
//
//  Created by Katherine Liang on 8/14/24.
//

import FirebaseAuth
import FirebaseFirestore

class AuthManager {
    
    func signInOrRegisterUser(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                
                // If sign-in fails, try registering the user
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        print("Error creating user: \(error.localizedDescription)")
                        completion(false, error)
                    } else {
                        self.createUserInFirestore()
                        completion(true, nil)
                    }
                }
            } else {
                self.createUserInFirestore()
                completion(true, nil)
            }
        }
    }

    func createUserInFirestore() {
        guard let user = Auth.auth().currentUser else {
            print("No user is logged in")
            return
        }

        let db = Firestore.firestore()
        let uid = user.uid
        let email = user.email ?? ""
        let username = email.components(separatedBy: "@").first ?? ""
        let name = user.displayName ?? ""

        db.collection("users").document(uid).setData([
            "username": username,
            "email": email,
            "name": name,
            "friendList": []  // Initialize with an empty array
        ]) { error in
            if let error = error {
                print("Error adding user to Firestore: \(error)")
            } else {
                print("User added to Firestore successfully")
            }
        }
    }

}
