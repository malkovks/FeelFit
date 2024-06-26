//
//  ActionsWithUserImageView.swift
//  FeelFit
//
//  Created by Константин Малков on 27.03.2024.
//

import UIKit
import PhotosUI

protocol ActionsWithUserImageView: AnyObject, HandleUserImageProtocol {
    
    /// property for serving UIImagePickerController. Using when need to open camera for taking a picture
    var cameraPickerController: UIImagePickerController! { get set }
    
    /// property for serving PHPickerViewController with default configuration. Using for open media files for selecting user's image
    var pickerViewController: PHPickerViewController! { get set }
    
    /// property for using haptic vibrations while doing some actions
    var feedbackGenerator: UIImpactFeedbackGenerator { get }
    
    
    /// Function set up default configuration include delegation for correct processing, displaying and taking picture from camera
    func setupCameraPickerController()
    
    /// Function set up default configuration for displaying, processing and returning media file
    func setupPickerViewController()
    
    /// Function open special controller for detail displaying user's image
    /// - Parameter longGesture: long press above 1 second for opening user image
    func didTapLongPressOnImage(_ longGesture: UILongPressGestureRecognizer)
    
    /// Function call alert for ordering to user what he can do with his profile image
    /// - Parameters:
    ///   - fileName: file name for storing image in file manager
    ///   - cameraPickerController: property of UIIMagePickerController
    ///   - pickerViewController: property of PHPickerViewController
    ///   - animated: animation boolean value
    ///   - gesture: tap gesture value
    func didTapOpenImagePicker(_ cameraPickerController: UIImagePickerController, _ pickerViewController: PHPickerViewController, animated: Bool ,_ gesture: UITapGestureRecognizer)
    
    func openMedia(_ pickerViewController: PHPickerViewController, animated: Bool)
    func openCamera(_ cameraPickerController: UIImagePickerController, animated: Bool)
    func deleteCurrentImage()
}

extension ActionsWithUserImageView where Self: UIViewController {
    
    
    
    var feedbackGenerator: UIImpactFeedbackGenerator {
        get {
            return UIImpactFeedbackGenerator(style: .medium)
        }
    }

    func didTapOpenImagePicker(_ cameraPickerController: UIImagePickerController, _ pickerViewController: PHPickerViewController, animated: Bool,_ gesture: UITapGestureRecognizer){
        feedbackGenerator.prepare()
        let alertController = UIAlertController(title: "What to do?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Open Camera", style: .default,handler: { [weak self]  _ in
            self?.openCamera(cameraPickerController, animated: animated)
        }))
        alertController.addAction(UIAlertAction(title: "Open Library", style: .default,handler: { [weak self] _ in
            self?.openMedia(pickerViewController, animated: animated)
        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteCurrentImage()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
    
    func openMedia(_ pickerViewController: PHPickerViewController, animated: Bool){
        feedbackGenerator.impactOccurred()
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite){
            
        case .notDetermined:
            FFMediaDataAccess.shared.requestPhotoLibraryAccess { [weak self] success in
                guard let self = self else { return }
                if success {
                    self.present(pickerViewController, animated: animated)
                } else {
                    viewAlertController(text: "You did not give access to media files. Шf you need, you can provide access to system components", controllerView: self.view)
                }
            }
        case .restricted:
            viewAlertController(text: "No access for application to media because parents control or profile configurations", controllerView: self.view)
        case .denied:
            viewAlertController(text: "You did not give access to media files. Check system settings for access", controllerView: self.view)
        case .authorized:
            present(pickerViewController, animated: animated)
        case .limited:
            present(pickerViewController, animated: animated)
        @unknown default:
            break
        }
       
    }
    
    func openCamera(_ cameraPickerController: UIImagePickerController, animated: Bool){
        feedbackGenerator.impactOccurred()
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            alertError(title: "Allow acces to camera in system Settings")
            return
        }
        present(cameraPickerController, animated: true)
    }
    
    func deleteCurrentImage(){
        feedbackGenerator.impactOccurred()
        do {
            try FFUserImageManager.shared.deleteUserImage(userImageFileName)
            userImage = nil
        } catch let error as UserImageErrorHandler {
            print(error.errorDescription!)
        } catch {
            fatalError()
        }
        
    }
    
    func didTapLongPressOnImage(_ longGesture: UILongPressGestureRecognizer){
        if longGesture.state == .began {
            
            let vc = FFImageDetailsViewController(newsImage: userImage, imageURL: "")
            present(vc, animated: true)
        }
    }
    
    func setupCameraPickerController(){
        cameraPickerController = UIImagePickerController()
        cameraPickerController.delegate = self as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
        cameraPickerController.sourceType = .camera
        cameraPickerController.allowsEditing = true
        cameraPickerController.showsCameraControls = true
        cameraPickerController.cameraCaptureMode = .photo
        
    }
    
    func setupPickerViewController() {
        let filter = PHPickerFilter.any(of: [.images,.livePhotos])
        var pickerConfiguration = PHPickerConfiguration(photoLibrary: .shared())
        pickerConfiguration.filter = filter
        pickerConfiguration.preferredAssetRepresentationMode = .automatic
        pickerConfiguration.selection = .continuousAndOrdered
        pickerConfiguration.selectionLimit = 1
        pickerConfiguration.mode = .default
        
        pickerViewController = PHPickerViewController(configuration: pickerConfiguration)
        pickerViewController.delegate = self as? any PHPickerViewControllerDelegate
    }
}
