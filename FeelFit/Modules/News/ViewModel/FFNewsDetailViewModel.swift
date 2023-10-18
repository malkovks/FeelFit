//
//  FFNewsDetailViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 16.10.2023.
//

import UIKit
import RealmSwift

class FFNewsDetailViewModel: Coordinating {
    var coordinator: Coordinator?
    
    var realm = try! Realm()
    
    func changeNewsStatus(model: FFNewsModelRealm){
        
    }
}
