import Foundation
import SwiftUI

struct Appointment: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let description: String
    
    init(id: UUID = UUID(), description: String) {
        self.id = id
        self.description = description
    }
}

struct CancelRequest: Identifiable, Codable, Equatable, Sendable {
    let id: UUID
    let appointmentDescription: String
    let fromUserId: String
    let toUserId: String
    var status: CancelStatus
    
    init(appointmentDescription: String, fromUserId: String, toUserId: String, status: CancelStatus = .pending) {
        self.id = UUID()
        self.appointmentDescription = appointmentDescription
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.status = status
    }
}

struct FeedbackMessage {
    let emoji: String
    let title: String
    let message: String
}

enum CancelStatus: Codable, Equatable {
    case pending
    case accepted
    case rejected
    case none
}

// MARK: - UI Extensions
extension CancelStatus {
    var icon: String {
        switch self {
        case .pending: return "clock.fill"
        case .accepted: return "heart.fill"
        case .rejected: return "heart.slash.fill"
        case .none: return "questionmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .accepted: return .green
        case .rejected: return .red
        case .none: return .gray
        }
    }
    
    var description: String {
        switch self {
        case .pending: return "Waiting for response"
        case .accepted: return "Understood"
        case .rejected: return "Was disappointed"
        case .none: return "Unknown status"
        }
    }
} 