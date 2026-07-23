//
//  SessionStore.swift
//  ReFrame
//
//  Tracks completed reset sessions and derives streak / weekly stats.
//

import Foundation
import Combine

struct DayStatus: Identifiable {
    let date: Date
    let isCompleted: Bool
    let isToday: Bool
    var id: Date { date }
}

final class SessionStore: ObservableObject {
    static let shared = SessionStore()

    @Published private(set) var completionDates: [Date] = []

    private let storageKey = "completedSessionDates"
    private let calendar = Calendar.current

    private init() {
        load()
    }

    // MARK: - Recording

    func recordCompletion(date: Date = Date()) {
        completionDates.append(date)
        save()
    }

    // MARK: - Derived stats

    var totalSessions: Int { completionDates.count }

    /// Distinct calendar days (start-of-day) that have at least one completion.
    private var completedDays: Set<Date> {
        Set(completionDates.map { calendar.startOfDay(for: $0) })
    }

    /// Consecutive-day streak ending today (or yesterday, so a streak doesn't
    /// visibly "break" until a full day has been missed).
    var currentStreak: Int {
        let days = completedDays
        guard !days.isEmpty else { return 0 }

        let today = calendar.startOfDay(for: Date())
        var cursor: Date
        if days.contains(today) {
            cursor = today
        } else if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
                  days.contains(yesterday) {
            cursor = yesterday
        } else {
            return 0
        }

        var streak = 0
        while days.contains(cursor) {
            streak += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = prev
        }
        return streak
    }

    /// Number of sessions completed in the current calendar week.
    var sessionsThisWeek: Int {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return 0 }
        return completionDates.filter { week.contains($0) }.count
    }

    /// Completion state for the last `count` days, oldest first, ending today.
    func recentDays(_ count: Int = 7) -> [DayStatus] {
        let days = completedDays
        let today = calendar.startOfDay(for: Date())
        return (0..<count).reversed().map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: today) ?? today
            return DayStatus(date: date,
                             isCompleted: days.contains(date),
                             isToday: offset == 0)
        }
    }

    // MARK: - Persistence

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([Date].self, from: data) {
            completionDates = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(completionDates) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
