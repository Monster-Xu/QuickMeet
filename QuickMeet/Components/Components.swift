import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(LinearGradient(colors: [QMColor.primary, QMColor.secondary], startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }.buttonStyle(.plain)
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(QMColor.textPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(QMColor.border, lineWidth: 1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }.buttonStyle(.plain)
    }
}

struct TagChip: View {
    let title: String
    var selected: Bool = false
    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(selected ? QMColor.primary : QMColor.textSecondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(selected ? QMColor.primary.opacity(0.12) : QMColor.card)
            .overlay(Capsule().stroke(selected ? QMColor.primary.opacity(0.25) : QMColor.border, lineWidth: 1))
            .clipShape(Capsule())
    }
}

struct SectionCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12) { content }
            .padding(16)
            .background(QMColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(color: .black.opacity(0.05), radius: 14, x: 0, y: 8)
    }
}

struct AvatarCircle: View {
    let title: String
    var size: CGFloat = 64
    var body: some View {
        Text(title)
            .font(.system(size: size * 0.28, weight: .bold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(LinearGradient(colors: [QMColor.primary, QMColor.secondary], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(Circle())
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let buttonTitle: String?
    let action: (() -> Void)?
    var body: some View {
        SectionCard {
            Text(title).font(.system(size: 22, weight: .bold))
            Text(subtitle).foregroundStyle(QMColor.textSecondary)
            if let buttonTitle, let action {
                PrimaryButton(title: buttonTitle, action: action).padding(.top, 8)
            }
        }
    }
}
