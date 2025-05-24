import SwiftUI

struct StatsCardView: View {
    let value: Int
    let subtitle: String
    let color: Color
    let icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(value)")
                    .font(.system(size: 34, weight: .medium))
                    .foregroundStyle(color)
                    .contentTransition(.numericText())
                
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
} 