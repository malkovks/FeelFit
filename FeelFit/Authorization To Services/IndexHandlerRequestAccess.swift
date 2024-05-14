//
//  IndexHandlerRequestAccess.swift
//  FeelFit
//
//  Created by Константин Малков on 14.05.2024.
//

import Foundation

class IndexHandlerRequestAccess {
    
    private let caseValue: Int
    
    init(caseValue: Int){
        self.caseValue = caseValue
    }
    
    func processCaseValue(){
        switch caseValue {
        case 0: requestAccessToNotification()
        case 1: requestAccessToCamera()
        case 2: requestAccessToMedia()
        case 3: requestAccessToHealth()
        case 4: requestAccessToUserHealth()
        default: break
        }
    }
    
    private func requestAccessToNotification(){
        FFSendUserNotifications.shared.requestForAccessToLocalNotification()
    }
    
    private func requestAccessToCamera(){
        FFMediaDataAccess.shared.requestAccessForCamera()
    }
    
    private func requestAccessToMedia(){
        FFMediaDataAccess.shared.requestPhotoLibraryAccess()
    }
    
    private func requestAccessToHealth(){
        FFHealthDataAccess.shared.requestForAccessToHealth()
    }
    
    private func requestAccessToUserHealth(){
        FFHealthDataAccess.shared.requestAccessToCharactersData()
    }
}
