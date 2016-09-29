//
//  Post.swift
//  Picolo
//
//  Created by Filip Mazic on 9/28/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import Foundation

class Post {
    private var _likes: Int!
    private var _imageUrl: String!
    private var _postId: String!
    
    var likes: Int {
        return _likes
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var postId: String {
        return _postId
    }
    
    init(likes: Int, imageUrl: String) {
        self._likes = likes
        self._imageUrl = imageUrl
    }
    
    init(postId: String, postData: Dictionary<String, AnyObject>) {
        self._postId = postId
        
        if let likes = postData["likes"] as? Int {
            self._likes = likes
        }
        
        if let imageUrl = postData["imageUrl"] as? String {
            self._imageUrl = imageUrl
        }
    }
}
