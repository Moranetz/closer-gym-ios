import Foundation
import UserNotifications

/// Daily Drill local notification scheduler.
/// Persists toggle + time-of-day to UserDefaults. Schedules a repeating
/// local notification on the user's chosen hour:minute.
@MainActor
public enum DailyNotifications {
    private static let enabledKey = "framefork:notif:dailyEnabled:v1"
    private static let hourKey    = "framefork:notif:hour:v1"
    private static let minuteKey  = "framefork:notif:minute:v1"
    private static let identifier = "framefork.dailyDrill"

    public static var isEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: enabledKey) }
        set { UserDefaults.standard.set(newValue, forKey: enabledKey) }
    }

    public static var hour: Int {
        get { (UserDefaults.standard.object(forKey: hourKey) as? Int) ?? 9 }
        set { UserDefaults.standard.set(newValue, forKey: hourKey) }
    }

    public static var minute: Int {
        get { (UserDefaults.standard.object(forKey: minuteKey) as? Int) ?? 0 }
        set { UserDefaults.standard.set(newValue, forKey: minuteKey) }
    }

    /// Request system permission, return whether granted.
    public static func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    /// Authorization status snapshot.
    public static func status() async -> UNAuthorizationStatus {
        await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
    }

    /// Schedule a daily-repeating Daily Drill reminder at the configured time.
    public static func schedule() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])

        guard isEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = "Daily Drill"
        content.body  = "30 seconds to solve. Keep your streak alive."
        content.sound = .default

        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request)
    }

    public static func cancel() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
