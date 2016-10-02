//
//  RegistrationVC.swift
//  Picolo
//
//  Created by Filip Mazic on 10/2/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var confPassField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    
    @IBAction func registerTapped(_ sender: AnyObject) {
        if let email = emailField.text, email != "", let username = usernameField.text, username != "", let pass = passField.text, pass != "", let confPass = confPassField.text, confPass != "" {
            
            if pass == confPass {
                
            
                FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion:     { (user, error) in
                    if error != nil {
                        if let errCode = FIRAuthErrorCode(rawValue: error!._code), errCode == .errorCodeEmailAlreadyInUse {
                            self.showErrorAlert("Email Error", msg: "Email already in use!")
                        } else {
                            self.showErrorAlert("Error", msg: "Create User Error")
                        }
                    } else {
                        
                        
                        
                        
                        print("Successfully auth with Firebase")
                        if let user = user {
                            let userData = ["provider": user.providerID,
                                            "username": username]
                            self.completeSignIn(id: user.uid, userData: userData)
                        }
                    }
                })
            } else {
                self.showErrorAlert("Password not match", msg: "Please enter valid password")
            }
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        UserDefaults.standard.setValue(id, forKey: KEY_UID)
        self.performSegue(withIdentifier: "goToFeedFromReg", sender: nil)
    }
    
    
    func showErrorAlert(_ title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    

}
