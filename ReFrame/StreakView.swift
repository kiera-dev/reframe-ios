//
//  StreakView.swift
//  ReFrame
//
//  A calm, themed summary of practice consistency: streak, weekly count,
//  and a row of glowing orbs — one per day.
//

import SwiftUI

struct StreakView: View {
    @ObservedObject private var store = SessionStore.shared
    let theme: AppTheme

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .top) {
                StatColumn(value: store.currentStreak,
                           label: store.currentStreak == 1 ? "day streak" : "day streak",
                           alignment: .leading,
                           theme: theme)
                Spacer()
                StatColumn(value: store.sessionsThisWeek,
                           label: "this week",
                           alignment: .trailing,
                           theme: theme)
            }

            HStack(spacing: 10) {
                ForEach(store.recentDays(7)) { day in
                    DayOrb(day: day, theme: theme)
                }
            }
        }
        .padding(20)
        .background(theme.cardFill)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(theme.cardStroke, lineWidth: 1)
        )
    }
}

private struct StatColumn: View {
    let value: Int
    let label: String
    let alignment: HorizontalAlignment
    let theme: AppTheme

    var body: some View {
        VStack(alignment: alignment, spacing: 2) {
            Text("\(value)")
                .font(.system(size: 34, weight: .light, design: .rounded))
                .foregroundStyle(theme.textPrimary)
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(theme.textSecondary)
        }
    }
}

private struct DayOrb: View {
    let day: DayStatus
    let theme: AppTheme

    private var weekdayLetter: String {
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("EEEEE") // single-letter weekday, localized
        return f.string(from: day.date)
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if day.isCompleted {
                    Circle()
                        .fill(RadialGradient(
                            colors: [theme.accent.opacity(0.65), theme.accent.opacity(0)],
                            center: .center,
                            startRadius: 1,
                            endRadius: 19
                        ))
                        .frame(width: 38, height: 38)
                    Circle()
                        .fill(theme.accent.opacity(0.9))
                        .frame(width: 15, height: 15)
                } else {
                    Circle()
                        .stroke(theme.textSecondary.opacity(0.35), lineWidth: 1)
                        .frame(width: 15, height: 15)
                }
            }
            .frame(width: 38, height: 38)
            .overlay(
                Circle()
                    .stroke(theme.textPrimary.opacity(day.isToday ? 0.5 : 0), lineWidth: 1)
                    .frame(width: 32, height: 32)
            )

            Text(weekdayLetter)
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundStyle(day.isToday ? theme.textPrimary : theme.textSecondary.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
    }
}
