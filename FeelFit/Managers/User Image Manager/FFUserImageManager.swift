//
//  FFUserImageManager.swift
//  FeelFit
//
//  Created by Константин Малков on 26.03.2024.
//

import UIKit


/// Class proccess, save ,load and delete users account image. It work with file manager
class FFUserImageManager {
    static let shared = FFUserImageManager()
    
    private init () {}
    
    private func getDocumentaryURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = paths.first!
        return directory
    }
    
    func saveUserImage(_ image: UIImage,fileName: String){
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let filesURL = getDocumentaryURL().appendingPathComponent(fileName)
        do {
            try data.write(to: filesURL)
            UserDefaults.standard.set(fileName, forKey: "userProfileFileName")
        } catch {
            fatalError("FFHealthUserProfileViewController.saveUserImage ==> Error saving to file url. Check the way to save data")
        }
    }
    
    func loadUserImage(_ userImageFileName: String ) -> UIImage? {
        let filesURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
        do {
            let imageData = try Data(contentsOf: filesURL)
            return UIImage(data: imageData)
        } catch {
            return nil
        }
    }
    
    func deleteUserImage(_ userImageFileName: String) -> UIImage? {
        let fileURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
            return UIImage(systemName: "person.crop.circle")!
        } catch {
            return nil
        }
    }
    
    
    
    func isUserImageSavedInDirectory(_ userImageFileName: String) -> Bool {
        let fileURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return true
        } else {
            return false
        }
    }}
