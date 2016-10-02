//
//  Post.swift
//  Picolo
//
//  Created by Filip Mazic on 9/28/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var _caption: String!
    private var _likes: Int!
    private var _imageUrl: String!
    private var _postId: String!
    private var _postRef: FIRDatabaseReference!
    
    var caption: String {
        return _caption
    }
    
    var likes: Int {
        return _likes
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var postId: String {
        return _postId
    }
    
    init(caption: String, likes: Int, imageUrl: String) {
        self._caption = caption
        self._likes = likes
        self._imageUrl = imageUrl
    }
    
    init(postId: String, postData: Dictionary<String, AnyObject>) {
        self._postId = postId
        
        if let caption = postData["caption"] as? String {
            self._caption = caption
        }
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
        
        _postRef = DataService.ds.REF_POSTS.child(_postId)
    }
    
    func adjustLikes(addLike: Bool) {
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        _postRef.child("likes").setValue(_likes)
    }
}
