//
//  NotificationsSupport.swift
//  FeelFit
//
//  Created by Константин Малков on 31.01.2024.
//

import UserNotifications


/// Class for asking and getting access status of users allowing to use local notification

class FFSendUserNotifications {
    
    static let shared = FFSendUserNotifications()
    
    func requestForAccessToLocalNotification(completion: ((Result<Bool, Error>) -> Void)? = nil) {
        let userNotification = UNUserNotificationCenter.current()
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert,.badge,.sound)
        userNotification.requestAuthorization(options: authOptions) { status, error in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(status))
            }
        }
    }
        
    
    ///Function for sending daily reminder with some random text
    func sendDailyNotification(){
        let sound = UNNotificationSound(named: UNNotificationSoundName("discord-notification.mp3"))
        let content = UNMutableNotificationContent()
        content.title = "Good Morning"
        content.subtitle = "Daily Reminder"
        content.body = getRandomNotificationMessage()
        content.sound = sound
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "userDailyNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send notification. Error: \(error.localizedDescription)")
            } else{
                print("Notification request added successfully")
            }
        }
    }
    
    ///Function called then user  reached 10k steps for current day
    func sendReachedStepObjectiveNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Congratulations"
        content.body = "You have reached 10 0000 steps count. Don't stop on this result"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Malkov.KS.FeelFit.fitnessApp.notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Did not complete to send notification. \(error.localizedDescription)")
            }
        }
    }

    private func getRandomNotificationMessage() -> String {
        let messages: [String] = [
            "Start your day off on the right foot by taking a step towards your fitness goals! Aim for 10,000 steps today and crush your step challenge.",
            "Every step counts! Keep pushing yourself to reach your daily goal of 10,000 steps and you'll be one step closer to a healthier you.",
            "Don't let excuses hold you back from reaching your fitness goals. Lace up your shoes, hit the pavement, and aim for 10,000 steps today!",
            "You're stronger than you think! Take on the challenge of completing 10,000 steps today and prove to yourself that you can do it.",
            "The journey to a healthier you starts with one step. Keep moving forward and make today a step closer to achieving your fitness goals.",
            "It's not about being perfect, it's about progress. Keep striving towards your goal of 10,000 steps and celebrate every step you take along the way.",
            "You're capable of more than you think! Push yourself to complete 10,000 steps today and you'll be amazed at what you can achieve.",
            "Don't just wish for it, work for it! Take on the challenge of completing 10,000 steps today and watch as you get closer to reaching your fitness goals.",
            "Small steps lead to big results. Make the commitment to complete 10,000 steps today and watch as you move closer to a healthier, happier you.",
            "Remember why you started! Keep pushing yourself to complete 10,000 steps today and stay motivated to achieve your fitness goals."
        ]
        let randomIndex = Int.random(in: 0..<messages.count)
        return messages[randomIndex]
    }
}


