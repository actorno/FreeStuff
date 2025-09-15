//
//  Claim.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
// import FirebaseFirestore

enum ClaimStatus: String, Codable {
    case pending = "pending"
    case approved = "approved"
    case rejected = "rejected"
    case completed = "completed"
}

struct Claim: Identifiable, Codable {
    var id: String?
    var claimId: String
    let itemId: String
    let claimerId: String
    let ownerId: String
    var timestamp: Date
    var status: ClaimStatus
    let message: String?
    
    init(itemId: String, claimerId: String, ownerId: String, message: String? = nil) {
        self.claimId = UUID().uuidString
        self.itemId = itemId
        self.claimerId = claimerId
        self.ownerId = ownerId
        self.timestamp = Date()
        self.status = .pending
        self.message = message
    }
}

// MARK: - Firestore Extensions
extension Claim {
    static let collection = "claims"
    
    func toDictionary() -> [String: Any] {
        return [
            "claimId": claimId,
            "itemId": itemId,
            "claimerId": claimerId,
            "ownerId": ownerId,
            "timestamp": timestamp,
            "status": status.rawValue,
            "message": message as Any
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Claim? {
        guard let claimId = data["claimId"] as? String,
              let itemId = data["itemId"] as? String,
              let claimerId = data["claimerId"] as? String,
              let ownerId = data["ownerId"] as? String,
              let timestamp = data["timestamp"] as? Date,
              let statusString = data["status"] as? String,
              let status = ClaimStatus(rawValue: statusString) else {
            return nil
        }
        
        let message = data["message"] as? String
        
        var claim = Claim(itemId: itemId, claimerId: claimerId, ownerId: ownerId, message: message)
        claim.claimId = claimId
        claim.timestamp = timestamp
        claim.status = status
        return claim
    }
}
