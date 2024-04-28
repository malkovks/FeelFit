//
//  PublicHandleRealmData.swift
//  FeelFit
//
//  Created by Константин Малков on 28.04.2024.
//

import Foundation
import RealmSwift

func collectRealmStorageWeight() -> String? {
    guard let realmURL = Realm.Configuration.defaultConfiguration.fileURL else { return nil  }
    let attribute = try! FileManager.default.attributesOfItem(atPath: realmURL.path)
    guard let size = attribute[.size] as? Int else { return nil }
    let textSize = String(describing: Double(size) / (1024 * 1024))
    return textSize
}
