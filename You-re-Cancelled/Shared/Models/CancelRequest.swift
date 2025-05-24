import SwiftUI

struct CancelRequest: Identifiable {
    let id = UUID()
    let appointmentDescription: String
    var status: CancelStatus = .pending
}

enum CancelStatus {
    case pending
    case accepted
    case rejected
    
    var description: String {
        switch self {
        case .pending: return "Waiting for response..."
        case .accepted: return "Request accepted"
        case .rejected: return "Request declined"
        }
    }
    
    var icon: String {
        switch self {
        case .pending: return "hourglass"
        case .accepted: return "checkmark.circle.fill"
        case .rejected: return "xmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .pending: return .orange
        case .accepted: return .green
        case .rejected: return .red
        }
    }
} 