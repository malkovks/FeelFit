//
//  MediaFilesSupport.swift
//  FeelFit
//
//  Created by Константин Малков on 27.01.2024.
//

import AVFoundation
import Photos

///Function requesting access to media include photo, videos and etc
func returnPhotoLibraryAccessStatus(completionHandler: @escaping (_ success:Bool) -> ()){
    switch PHPhotoLibrary.authorizationStatus(for: .readWrite){
    case .authorized:
        completionHandler(true)
    case .notDetermined:
        requestPhotoLibraryAccess { success in
            completionHandler(success)
        }
    case .denied,.limited,.restricted:
        completionHandler(false)
    @unknown default:
        fatalError("Fatal error getting access to PHPhotoLibrary data")
    }
}

func requestPhotoLibraryAccess(completionHandler: @escaping (_ success: Bool) -> ()) {
    PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
        switch status {
        case .notDetermined,.denied,.restricted,.limited:
            completionHandler(false)
        case .authorized:
            completionHandler(true)
        @unknown default:
            fatalError("Error getting status access of PHPhoto Library")
        }
    }
}

///Function requesting access to Camera
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

func requestAccessForCamera(completionsHandler: @escaping (_ status: Bool) -> ()) {
    AVCaptureDevice.requestAccess(for: .video) { success in
        completionsHandler(success)
    }
}
