//
//  Report.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import Foundation
// import FirebaseFirestore

enum ReportType: String, CaseIterable, Codable {
    case spam = "spam"
    case inappropriate = "inappropriate"
    case fake = "fake"
    case harassment = "harassment"
    case other = "other"
}

enum ReportTarget: String, Codable {
    case item = "item"
    case user = "user"
}

struct Report: Identifiable, Codable {
    var id: String?
    var reportId: String
    let reporterId: String
    let targetId: String // itemId or userId
    let targetType: ReportTarget
    let reportType: ReportType
    let description: String?
    var timestamp: Date
    var isResolved: Bool
    
    init(reporterId: String, targetId: String, targetType: ReportTarget, reportType: ReportType, description: String? = nil) {
        self.reportId = UUID().uuidString
        self.reporterId = reporterId
        self.targetId = targetId
        self.targetType = targetType
        self.reportType = reportType
        self.description = description
        self.timestamp = Date()
        self.isResolved = false
    }
}

// MARK: - Firestore Extensions
extension Report {
    static let collection = "reports"
    
    func toDictionary() -> [String: Any] {
        return [
            "reportId": reportId,
            "reporterId": reporterId,
            "targetId": targetId,
            "targetType": targetType.rawValue,
            "reportType": reportType.rawValue,
            "description": description as Any,
            "timestamp": timestamp,
            "isResolved": isResolved
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> Report? {
        guard let reportId = data["reportId"] as? String,
              let reporterId = data["reporterId"] as? String,
              let targetId = data["targetId"] as? String,
              let targetTypeString = data["targetType"] as? String,
              let targetType = ReportTarget(rawValue: targetTypeString),
              let reportTypeString = data["reportType"] as? String,
              let reportType = ReportType(rawValue: reportTypeString),
              let timestamp = data["timestamp"] as? Date,
              let isResolved = data["isResolved"] as? Bool else {
            return nil
        }
        
        let description = data["description"] as? String
        
        var report = Report(reporterId: reporterId, targetId: targetId, targetType: targetType, reportType: reportType, description: description)
        report.reportId = reportId
        report.timestamp = timestamp
        report.isResolved = isResolved
        return report
    }
}
