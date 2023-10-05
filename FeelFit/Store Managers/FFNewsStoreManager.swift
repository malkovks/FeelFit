//
//  FFNewsStoreManager.swift
//  FeelFit
//
//  Created by Константин Малков on 05.10.2023.
//

import RealmSwift
import UIKit


class FFNewsStoreManager {
    static let shared = FFNewsStoreManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func saveNewsModel(model: Articles, status: Bool){
        let newsModel = FFNewsModelRealm()
        newsModel.newsAddedFavouriteStatus = status
        newsModel.newsAuthor = model.author ?? nil
        newsModel.newsURL = model.url ?? "No URL"
        newsModel.newsTitle = model.title
        newsModel.newsContent = model.content ?? nil
        newsModel.newsDescription = model.description ?? nil
        newsModel.newsImageURL = model.urlToImage ?? nil
        newsModel.newsSourceName = model.source.name
        newsModel.newsPublishedAt = model.publishedAt
        DispatchQueue.main.async {
            try! self.realm.write({
                self.realm.add(newsModel)
                print("saved")
            })
        }
    }
    
    
    
    func deleteNewsModel(model: Articles,status: Bool){
        
        let newsModel = realm.objects(FFNewsModelRealm.self).filter("newsURL = '\(model.url)'")
        DispatchQueue.main.async {
            try! self.realm.write {
                self.realm.delete(newsModel)
                print("Deleted")
            }
        }
    }
    
    func deleteNewsModelRealm(model: FFNewsModelRealm){
        let model = realm.objects(FFNewsModelRealm.self).filter("newsURL ='\(model.newsURL)'")
        try! realm.write({
            realm.delete(model)
        })
    }
}
