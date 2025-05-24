import SwiftUI

struct ActivityItem: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
    let title: String
    let subtitle: String
    let timestamp: Date = Date()
}

extension CancelViewModel {
    var allActivityItems: [ActivityItem] {
        var items: [ActivityItem] = []
        
        // Add sent requests
        for request in sentRequests {
            switch request.status {
            case .pending:
                items.append(ActivityItem(
                    icon: "clock.fill",
                    color: .orange,
                    title: "Waiting for \(request.toUserId)'s response",
                    subtitle: request.appointmentDescription
                ))
            case .accepted:
                items.append(ActivityItem(
                    icon: "heart.fill",
                    color: .green,
                    title: "\(request.toUserId) understood your cancellation",
                    subtitle: request.appointmentDescription
                ))
            case .rejected:
                items.append(ActivityItem(
                    icon: "heart.slash.fill",
                    color: .red,
                    title: "You disappointed \(request.toUserId)",
                    subtitle: request.appointmentDescription
                ))
            case .none:
                break
            }
        }
        
        // Add received requests
        for request in receivedRequests {
            switch request.status {
            case .pending:
                items.append(ActivityItem(
                    icon: "bell.fill",
                    color: .orange,
                    title: "\(request.fromUserId) wants to cancel",
                    subtitle: request.appointmentDescription
                ))
            case .accepted:
                items.append(ActivityItem(
                    icon: "heart.fill",
                    color: .green,
                    title: "You understood \(request.fromUserId)",
                    subtitle: request.appointmentDescription
                ))
            case .rejected:
                items.append(ActivityItem(
                    icon: "heart.slash.fill",
                    color: .red,
                    title: "You were disappointed by \(request.fromUserId)",
                    subtitle: request.appointmentDescription
                ))
            case .none:
                break
            }
        }
        
        return items.sorted { $0.id.uuidString > $1.id.uuidString }
    }
} 