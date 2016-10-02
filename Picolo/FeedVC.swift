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
    @IBOutlet weak var feedBtn: UIButton!
    @IBOutlet weak var drawBtn: UIButton!
    @IBOutlet weak var profileBtn: UIButton!
    
    
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            self.posts = []
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let id = snap.key
                        let post = Post(postId: id, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        feedBtn.setImage(UIImage(named: "newsfeedclicked.png"), for: UIControlState.normal)       
        drawBtn.setImage(UIImage(named: "draw.png"), for: UIControlState.normal)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }  

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {            
            
            let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString)
            cell.configureCell(post: post, img: img)
            
            return cell
        } else {
            return PostCell()
        }
    }
    
    
    @IBAction func feedTapped(_ sender: AnyObject) {        
        feedBtn.setImage(UIImage(named: "newsfeedclicked.png"), for: UIControlState.normal)
        profileBtn.setImage(UIImage(named: "profile.png"), for: UIControlState.normal)
        drawBtn.setImage(UIImage(named: "draw.png"), for: UIControlState.normal)
        
    }
    
    @IBAction func pencilTapped(_ sender: AnyObject) {
        drawBtn.setImage(UIImage(named: "drawclicked.png"), for: UIControlState.normal)
        feedBtn.setImage(UIImage(named: "newsfeed.png"), for: UIControlState.normal)
        profileBtn.setImage(UIImage(named: "profile.png"), for: UIControlState.normal)
        
        self.performSegue(withIdentifier: "goToDraw", sender: nil)
        //self.performSegue(withIdentifier: "goToDrwNav", sender: nil)
    }
    
    
    @IBAction func profileTapped(_ sender: AnyObject) {
        profileBtn.setImage(UIImage(named: "profileclicked.png"), for: UIControlState.normal)
        drawBtn.setImage(UIImage(named: "draw.png"), for: UIControlState.normal)
        feedBtn.setImage(UIImage(named: "newsfeed.png"), for: UIControlState.normal)
        
    }

    @IBAction func signOutTapped(_ sender: AnyObject) {
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
}
