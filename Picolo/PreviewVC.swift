//
//  PreviewVC.swift
//  Picolo
//
//  Created by Filip Mazic on 9/29/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import UIKit
import Firebase

class PreviewVC: UIViewController {
    
    
    @IBOutlet weak var previewImg: UIImageView!
    @IBOutlet weak var caption: UITextField!
    
    
    
    var img: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()

        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        previewImg.image = img
    }   

    override var shouldAutorotate: Bool {
        return false
    }

    @IBAction func postTapped(_ sender: AnyObject) {
        var cp = true
        guard let cap = caption.text, cap != "" else {
            cp = false
            return
        }
        
        guard let i = previewImg.image else {
            print("Draw image!")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(i, 0.2) {
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("Unable to upload image to Firebase storage!")
                } else {
                    print("Successfully uploaded image to Firebase storage!")
                    let downloadUrl = metadata?.downloadURL()?.absoluteString
                    if let url = downloadUrl {
                        self.postToFirebase(imgUrl: url)
                    }
                }
                
            }
            
        }
        
    }
    
    func postToFirebase(imgUrl: String) {
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let post: Dictionary<String, AnyObject> = [
        "caption" : caption.text! as AnyObject,
        "imageUrl" : imgUrl as AnyObject,
        "likes" : 0 as AnyObject,
        "timestamp" : timestamp as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        let idPost = firebasePost.key
        let userPost = DataService.ds.REF_USER_POSTS.child(idPost)
        userPost.setValue(true)
    }
    
    
}
