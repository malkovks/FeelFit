//
//  FFUserImageManager.swift
//  FeelFit
//
//  Created by Константин Малков on 26.03.2024.
//

import UIKit

enum UserImageErrorHandler: Error {
    case notSaved
    case notConverted
    case notLoaded
    case notDeleted
}

extension UserImageErrorHandler: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notSaved:
            return "This image could not saved by some unexpected error"
        case .notConverted:
            return "Application can't convert this image. Try again later!"
        case .notLoaded:
            return "Can not load image from storage"
        case .notDeleted:
            return "Error deleting image from storage"
        }
    }
}

/// Class proccess, save ,load and delete users account image. It work with file manager
class FFUserImageManager {
    static let shared = FFUserImageManager()
    
    private init () {}
    
    private func getDocumentaryURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = paths.first!
        return directory
    }
    
    func saveUserImage(_ image: UIImage,fileName: String) throws {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return }
        let filesURL = getDocumentaryURL().appendingPathComponent(fileName)
        do {
            try data.write(to: filesURL)
            
        } catch {
            throw UserImageErrorHandler.notSaved
        }
    }
    
    func loadUserImage(_ userImageFileName: String ) throws -> UIImage? {
        
        let filesURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
        do {
            let imageData = try Data(contentsOf: filesURL)
            return UIImage(data: imageData)
        } catch {
            throw UserImageErrorHandler.notLoaded
        }
    }
    
    func deleteUserImage(_ userImageFileName: String) throws {
        let fileURL = getDocumentaryURL().appendingPathComponent(userImageFileName)
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            throw UserImageErrorHandler.notDeleted
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
