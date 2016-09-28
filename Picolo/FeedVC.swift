//
//  FeedVC.swift
//  Picolo
//
//  Created by Filip Mazic on 9/27/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
    }
    
    @IBAction func pencilTapped(_ sender: AnyObject) {
        print("Pencil!!!")
    }
    
    
    @IBAction func profileTapped(_ sender: AnyObject) {
        
        
    }

    @IBAction func signOutTapped(_ sender: AnyObject) {
        UserDefaults.standard.removeObject(forKey: "uid")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
}
