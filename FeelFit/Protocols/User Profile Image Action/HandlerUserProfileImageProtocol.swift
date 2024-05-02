//
//  HandlerUserProfileImageProtocol.swift
//  FeelFit
//
//  Created by Константин Малков on 30.03.2024.
//

import UIKit
import PhotosUI


protocol HandlerUserProfileImageProtocol: ActionsWithUserImageView, HandlerUploadedImageProtocol {
    func handlerSelectedImage(_ results: [PHPickerResult],tableView table: UITableView)
    func handlerCapturedImage(_ info: [UIImagePickerController.InfoKey : Any], tableView table: UITableView)
}

extension HandlerUserProfileImageProtocol where Self: UIViewController {
    
    func handlerSelectedImage(_ results: [PHPickerResult],tableView table: UITableView){
        guard let result = results.first else { return }
        let itemProvider = result.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image , error in
                guard let self = self else { return }
                guard let image = image as? UIImage else { return }
                userImage = checkIsImageSavedInManaged(fileName: userImageFileName, image: image)
                DispatchQueue.main.async {
                    table.reloadData()
                }
            }
        }
    }
    
    func handlerCapturedImage(_ info: [UIImagePickerController.InfoKey : Any], tableView table: UITableView){
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userImage = editedImage
            askUserToSaveImageToStorage(editedImage)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage = originalImage
            askUserToSaveImageToStorage(originalImage)
        } else {
            viewAlertController(text: "Error getting captured image. Try again later", controllerView: self.view)
        }
        table.reloadData()
    }
}
