//
//  ReportView.swift
//  FreeStuff
//
//  Created by Aerhelle Torno on 9/9/25.
//

import SwiftUI

struct ReportView: View {
    let targetId: String
    let targetType: ReportTarget
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedReportType: ReportType = .spam
    @State private var description = ""
    @State private var isSubmitting = false
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Image(systemName: "flag")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("Report \(targetType.rawValue.capitalized)")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Help us keep the community safe")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
                
                // Report Type Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("What's the issue?")
                        .font(.headline)
                    
                    ForEach(ReportType.allCases, id: \.self) { reportType in
                        Button(action: {
                            selectedReportType = reportType
                        }) {
                            HStack {
                                Image(systemName: "circle")
                                    .foregroundColor(selectedReportType == reportType ? .blue : .gray)
                                
                                Text(reportType.rawValue.capitalized)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedReportType == reportType {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Additional Details (Optional)")
                        .font(.headline)
                    
                    TextField("Provide more details...", text: $description, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                }
                
                Spacer()
                
                // Submit Button
                Button(action: submitReport) {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        Text("Submit Report")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(isSubmitting)
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Report Submitted", isPresented: $showingSuccess) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Thank you for your report. We'll review it and take appropriate action.")
        }
    }
    
    private func submitReport() {
        guard let currentUserId = getCurrentUserId() else { return }
        
        isSubmitting = true
        
        let report = Report(
            reporterId: currentUserId,
            targetId: targetId,
            targetType: targetType,
            reportType: selectedReportType,
            description: description.isEmpty ? nil : description
        )
        
        Task {
            do {
                try await FirebaseService.shared.createReport(report)
                await MainActor.run {
                    isSubmitting = false
                    showingSuccess = true
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    // Handle error
                }
            }
        }
    }
    
    private func getCurrentUserId() -> String? {
        // This should be injected or accessed through a shared authentication state
        return nil
    }
}

#Preview {
    ReportView(targetId: "test", targetType: .item)
}
