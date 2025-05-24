import Foundation

struct Appointment: Identifiable {
    let id = UUID()
    let description: String
    let date: Date
} 