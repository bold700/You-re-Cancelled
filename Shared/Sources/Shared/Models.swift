import SwiftUI
import Foundation

public struct Appointment: Identifiable {
    public let id = UUID()
    public let description: String
    public let date: Date
    
    public init(description: String, date: Date) {
        self.description = description
        self.date = date
    }
}

public struct CancelRequest: Identifiable {
    public let id = UUID()
    public let appointmentDescription: String
    public var status: CancelStatus
    
    public init(appointmentDescription: String, status: CancelStatus = .pending) {
        self.appointmentDescription = appointmentDescription
        self.status = status
    }
}

public enum CancelStatus {
    case pending
    case accepted
    case rejected
    
    public var description: String {
        switch self {
        case .pending: return "Waiting for response..."
        case .accepted: return "Request accepted"
        case .rejected: return "Request declined"
        }
    }
    
    public var icon: String {
        switch self {
        case .pending: return "hourglass"
        case .accepted: return "checkmark.circle.fill"
        case .rejected: return "xmark.circle.fill"
        }
    }
    
    public var color: Color {
        switch self {
        case .pending: return .orange
        case .accepted: return .green
        case .rejected: return .red
        }
    }
}

public struct FeedbackMessage {
    public let emoji: String
    public let title: String
    public let message: String
    
    public init(emoji: String, title: String, message: String) {
        self.emoji = emoji
        self.title = title
        self.message = message
    }
} 