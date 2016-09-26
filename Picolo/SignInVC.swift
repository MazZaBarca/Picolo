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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        
        if UserDefaults.standard.value(forKey: "uid") != nil {
            self.performSegue(withIdentifier: "goToFeed", sender: nil)
            
            
        }
    }
    
    

    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("User auth with Firebase")
                    UserDefaults.standard.setValue(user!.uid, forKey: "uid")
                    self.performSegue(withIdentifier: "goToFeed", sender: nil)
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("Unable to auth with Firebase")
                        } else {
                            print("Successfully auth with Firebase")
                            UserDefaults.standard.setValue(user!.uid, forKey: "uid")
                            self.performSegue(withIdentifier: "goToFeed", sender: nil)
                        }
                    })
                }
            })
        }
    }
    

}

