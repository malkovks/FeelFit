//
//  ProcessUserProfileImage.swift
//  FeelFit
//
//  Created by Константин Малков on 29.03.2024.
//

import UIKit
import PhotosUI

protocol HandlerUploadedImageProtocol: AnyObject {
    func checkIsImageSavedInManaged(fileName name: String, image: UIImage) -> UIImage?
    func askUserToSaveImageToStorage(_ image: UIImage)
}

extension HandlerUploadedImageProtocol where Self: UIViewController {
    
    func checkIsImageSavedInManaged(fileName name: String, image: UIImage) -> UIImage? {
        let manager = FFUserImageManager.shared
        let saveStatus = manager.isUserImageSavedInDirectory(name)
        if saveStatus {
            try! manager.deleteUserImage(name)
        }
        do {
            try manager.saveUserImage(image, fileName: name)
        } catch let error as UserImageErrorHandler {
            viewAlertController(text: error.errorDescription, controllerView: self.view)
        } catch {
            fatalError()
        }
        return image
    }
    
    func askUserToSaveImageToStorage(_ image: UIImage){
        let alertController = UIAlertController(title: nil, message: "Do you want to save captured photo?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}

