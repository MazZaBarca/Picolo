//
//  PostCell.swift
//  Picolo
//
//  Created by Filip Mazic on 9/28/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    
    var likeRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
    }

    
    func configureCell(post: Post, img: UIImage!) {
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postId)
        
        
        DataService.ds.REF_USER_CURRENT.child("username").observeSingleEvent(of: .value, with: { (snapshot) in
            if let username = snapshot.value as! String? {
                self.usernameLbl.text = username
            }
        })
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else  {
            
            let ref = FIRStorage.storage().reference(forURL: post.imageUrl)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Maza: Unable to download image from firebase storage")
                } else {
                    print("Maza: Image downloaded from firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.postImg.image = img
                            FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            
            })
            
        }
        
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart_stroke")
            } else {
                self.likeImg.image = UIImage(named: "heart_fill")
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        likeImg.isUserInteractionEnabled = false
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "heart_fill")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "heart_stroke")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
        likeImg.isUserInteractionEnabled = true
    }
    

}
