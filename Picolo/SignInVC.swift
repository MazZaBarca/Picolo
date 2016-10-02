//
//  ViewController.swift
//  Picolo
//
//  Created by Filip Mazic on 9/26/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        
        if UserDefaults.standard.value(forKey: KEY_UID) != nil {
            self.performSegue(withIdentifier: "goToFeed", sender: nil)
            
            
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }    
    

    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, email != "", let pwd = pwdField.text, pwd != "" {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("User auth with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    self.showErrorAlert("Wrong credential", msg: "Invalid email address and password")
                }
            })
        } else {
            self.showErrorAlert("Email and password required", msg: "Please enter email address and password")
        }
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        UserDefaults.standard.setValue(id, forKey: KEY_UID)
        self.performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
    func showErrorAlert(_ title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    

}

