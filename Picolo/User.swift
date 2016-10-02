//
//  User.swift
//  Picolo
//
//  Created by Filip Mazic on 10/2/16.
//  Copyright © 2016 Filip Mazic. All rights reserved.
//

import Foundation
import Firebase

class User {
    private var _username: String!
    
    var username: String {
        return _username
    }
    
    init(uid: String) {
        _username = DataService.ds.REF_USERS.child(uid).value(forKey: "username") as! String!
        print(_username)
    }
}
