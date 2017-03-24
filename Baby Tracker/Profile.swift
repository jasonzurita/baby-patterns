//
//  Profile.swift
//  Baby Tracker
//
//  Created by Jason Zurita on 11/7/16.
//  Copyright © 2016 Jason Zurita. All rights reserved.
//

import Foundation
import UIKit

struct Profile {
    var babyName:String
    var parentName:String
    var babyDOB:Date
    var email:String
    let userID:String
    var serverKey:String?
    var profilePicture:UIImage?

    init(babyName:String, parentName:String, babyDOB:Date, email:String, userID:String, serverKey:String? = nil, profilePicture:UIImage? = nil) {
        self.babyName = babyName
        self.parentName = parentName
        self.profilePicture = profilePicture
        self.babyDOB = babyDOB
        self.email = email
        self.userID = userID
        self.serverKey = serverKey
    }
    
    func json() -> [String:Any] {
        return [K.JsonFields.BabyName:babyName,
                K.JsonFields.ParentName:parentName,
                K.JsonFields.BabyDOB:babyDOB.timeIntervalSince1970,
                K.JsonFields.Email:email,
                K.JsonFields.UserID:userID]
    }
}
