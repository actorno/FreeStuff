//
//  User.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
// import FirebaseFirestore

struct User: Identifiable, Codable {
    var id: String?
    let uid: String
    let name: String
    let email: String
    var joinDate: Date
    let city: String
    
    init(uid: String, name: String, email: String, city: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.joinDate = Date()
        self.city = city
    }
}

// MARK: - Firestore Extensions
extension User {
    static let collection = "users"
    
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "email": email,
            "joinDate": joinDate,
            "city": city
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> User? {
        guard let uid = data["uid"] as? String,
              let name = data["name"] as? String,
              let email = data["email"] as? String,
              let joinDate = data["joinDate"] as? Date,
              let city = data["city"] as? String else {
            return nil
        }
        
        var user = User(uid: uid, name: name, email: email, city: city)
        user.joinDate = joinDate
        return user
    }
}
