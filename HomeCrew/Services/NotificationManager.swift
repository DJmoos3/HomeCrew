//
//  NotificationManager.swift
//  HomeCrew
//
//  Created by Claude on 2026-06-11.
//

import UserNotifications

struct NotificationManager {

    static let shared = NotificationManager()

    /// Request notification permission from the user (call once at app launch)
    func requestPermission() async -> Bool {
        let center = UNUserNotificationCenter.current()
        do {
            return try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    /// Schedule a local notification 1 minute before the task's due date
    func scheduleTaskReminder(taskID: String, title: String, dueDate: Date) {
        let reminderDate = dueDate.addingTimeInterval(-60) // 1 minute before

        guard reminderDate > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = "\(title) is due in 1 minute"
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

    /// Cancel a pending notification for a task
    func cancelTaskReminder(taskID: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [taskID]
        )
    }
}
