//
//  CheckServiceAuthentication.swift
//  FeelFit
//
//  Created by Константин Малков on 11.05.2024.
//

import HealthKit
import UserNotifications
import Photos
import AVFoundation

struct EnableServiceStatus {
    var health: Bool = false
    var userHealth: Bool = false
    var media: Bool = false
    var camera: Bool = false
    var notification: Bool = false
}

class CheckServiceAuthentication {
    private let healthStore = HKHealthStore()
    
    func checkAccess() async -> EnableServiceStatus {
        var model = EnableServiceStatus()
        model.notification = await notificationRequestAccess()
        model.media = await mediaRequestAccess()
        model.camera = await cameraRequestAccess()
        model.userHealth = await userHealthRequestAccess()
        model.health = await healthRequestAccess()
        return model
    }
    
    private func notificationRequestAccess() async -> Bool {
        let center = UNUserNotificationCenter.current()
        
        let access = await center.notificationSettings()
        switch access.authorizationStatus {
            
        case .notDetermined, .denied:
            return false
        case .authorized, .provisional, .ephemeral:
            return true
        @unknown default:
            return false
        }
    }
    
    private func mediaRequestAccess() async -> Bool {
        let access = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        switch access {
            
        case .notDetermined, .restricted, .denied:
            return false
        case .authorized, .limited:
            return true
        @unknown default:
            return false
        }
    }
    
    private func cameraRequestAccess() async -> Bool {
        let access = await AVCaptureDevice.requestAccess(for: .video)
        switch access {
            
        case true:
            return true
        case false:
            return false
        }
    }
    
    private func userHealthRequestAccess() async -> Bool {
        let userCharTypes = Set(FFHealthDataUser.readDataTypes)
        let shareCharTypes = Set(FFHealthDataUser.shareDataTypes)
        do {
            try await healthStore.requestAuthorization(toShare: shareCharTypes, read: userCharTypes)
            return true
        } catch {
            return false
        }
    }
    
    private func healthRequestAccess() async -> Bool {
        let readTypes = Set(FFHealthData.readDataTypes)
        let shareTypes = Set(FFHealthData.shareDataTypes)
        do {
            try await healthStore.requestAuthorization(toShare: readTypes, read: shareTypes)
            return true
        } catch {
            return false
        }
    }
}
