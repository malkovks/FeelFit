//
//  FFNewsModelRealm.swift
//  FeelFit
//
//  Created by Константин Малков on 05.10.2023.
//

import Foundation
import RealmSwift

class FFNewsModelRealm : Object {
    @Persisted var newsSourceName: String
    @Persisted var newsTitle: String
    @Persisted var newsDescription: String?
    @Persisted var newsURL: String
    @Persisted var newsImageURL: String?
    @Persisted var newsPublishedAt: String?
    @Persisted var newsAuthor: String?
    @Persisted var newsContent: String?
    @Persisted var newsAddedFavouriteStatus: Bool = false
}
