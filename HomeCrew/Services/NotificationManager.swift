//
//  NotificationManager.swift
//  HomeCrew
//
//  Created by William Albinsson on 2026-06-11.
//

import UserNotifications

struct NotificationManager {

    static let shared = NotificationManager()

    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    func scheduleTaskReminder(taskID: String, title: String, dueDate: Date) {
        let reminderDate = dueDate.addingTimeInterval(-10 * 60)

        guard reminderDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "\(title) is due in 10 minutes"
        content.sound = .default

        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: reminderDate
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(
            identifier: taskID,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }

    func cancelTaskReminder(taskID: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [taskID]
        )
    }
}
