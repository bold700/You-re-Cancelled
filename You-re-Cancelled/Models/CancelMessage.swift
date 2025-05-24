import SwiftUI

struct CancelMessage {
    let message: String
    
    var formattedMessage: String {
        "🙈 Sorry, I can't make it...\n\n\(message)\n\n💝"
    }
}

// Vooraf gedefinieerde emoji's voor snelle selectie
enum CancelEmoji: String, CaseIterable {
    case sick = "🤒"
    case tired = "😴"
    case busy = "😅"
    case family = "👨‍👩‍👧‍👦"
    case other = "🙏"
    
    var description: String {
        switch self {
        case .sick: return "I'm sick"
        case .tired: return "Too tired"
        case .busy: return "Super busy"
        case .family: return "Family matters"
        case .other: return "Other"
        }
    }
    
    var suggestedMessage: String {
        switch self {
        case .sick: return "I'm not feeling well today, need to rest and recover. Let's catch up when I'm better!"
        case .tired: return "I'm completely exhausted from work. Need to recharge my batteries. Rain check?"
        case .busy: return "Things are crazy busy right now. Can we reschedule for next week?"
        case .family: return "Something came up with the family. I'll text you later with more details!"
        case .other: return "I'm so sorry, but I won't be able to make it. Can we reschedule?"
        }
    }
} 