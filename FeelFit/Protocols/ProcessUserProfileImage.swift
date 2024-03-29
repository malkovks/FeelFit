//
//  ProcessUserProfileImage.swift
//  FeelFit
//
//  Created by Константин Малков on 29.03.2024.
//

import UIKit
import PhotosUI

protocol ProcessUserProfileImageProtocol: AnyObject {
    var fileName: String { get set }
    func convertSelectedImage(_ results: [PHPickerResult])
    func checkIsImageSavedInManaged(fileName name: String, image: UIImage)
    func askUserToSaveImageToStorage(_ image: UIImage)
}

extension ProcessUserProfileImageProtocol where Self: UIViewController {
    func convertSelectedImage(fileName name: String,_ results: [PHPickerResult]){
        guard let result = results.first else { return }
        let itemProvider = result.itemProvider
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image , error in
                guard let self = self else { return }
                guard let image = image as? UIImage else { return }
                checkIsImageSavedInManaged(fileName: name, image: image)
            }
        }
    }
    
    func checkIsImageSavedInManaged(fileName name: String, image: UIImage){
        let saveStatus = FFUserImageManager.shared.isUserImageSavedInDirectory(fileName)
        //Доделать эту функцию
        // подумать как нам после проверки передавать изображение
        //подумать насчет протоколов как с ними поступить
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
