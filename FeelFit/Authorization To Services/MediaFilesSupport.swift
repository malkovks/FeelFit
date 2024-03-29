//
//  MediaFilesSupport.swift
//  FeelFit
//
//  Created by Константин Малков on 27.01.2024.
//

import AVFoundation
import Photos


/// Class for asking and getting access status of users allowing to use media and camera
class FFMediaDataAccess {
    
    static let shared = FFMediaDataAccess()
    
    private init() {}
    
    ///Function check access status to photo library and could request access to it. Return boolean status of requesting
    func returnPhotoLibraryAccessStatus(completionHandler: @escaping (_ success:Bool) -> ()){
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite){
        case .authorized:
            completionHandler(true)
        case .notDetermined:
            requestPhotoLibraryAccess { success in
                completionHandler(success)
            }
        case .denied,.limited,.restricted:
            requestPhotoLibraryAccess { success in
                completionHandler(success)
            }
        @unknown default:
            fatalError("Fatal error getting access to PHPhotoLibrary data")
        }
    }

    /// Function for creating asking access to users photo library and returning boolean status
    func requestPhotoLibraryAccess(completionHandler: @escaping (_ success: Bool) -> ()) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            switch status {
            case .notDetermined,.denied,.restricted:
                completionHandler(false)
            case .limited:
                completionHandler(true)
            case .authorized:
                completionHandler(true)
            @unknown default:
                fatalError("Error getting status access of PHPhoto Library")
            }
        }
    }

    ///Function return  access status of application
    func returnCameraAccessStatus(completionHandler: @escaping (_ success:Bool) ->()){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            requestAccessForCamera { status in
                completionHandler(status)
            }
        case .authorized:
            completionHandler(true)
        case .restricted, .denied:
            completionHandler(false)
        
            
            
        @unknown default:
            fatalError("Fatal error for getting status access for camera)")
        }
    }


    ///  Making users request for getting access to Camera
    /// - Parameter completionsHandler: return boolean value which return is user give access or not
    func requestAccessForCamera(completionsHandler: @escaping (_ status: Bool) -> ()) {
        AVCaptureDevice.requestAccess(for: .video) { success in
            completionsHandler(success)
        }
    }
}


