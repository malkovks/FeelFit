//
//  ActionsWithUserImageView.swift
//  FeelFit
//
//  Created by Константин Малков on 27.03.2024.
//

import UIKit

protocol ActionsWithUserImageView: AnyObject {
    //добавить свойства которые мы обьявляем для работы с камерой и библиотекой
    //доделать расширения
    //оптимизировать под два класса
    func didTapOpenImagePicker(_ fileName: String,_ gesture: UITapGestureRecognizer)
    func openCamera()
    func checkAccessToCameraAndMedia(handler: (_ status: Bool) -> ())
    func didTapOpenUserImage(_ longGesture: UILongPressGestureRecognizer)
}

extension ActionsWithUserImageView where Self: UIViewController {
    func didTapOpenImagePicker(_ fileName: String,_ gesture: UITapGestureRecognizer){
        let alertController = UIAlertController(title: "What to do?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Open Camera", style: .default,handler: {  _ in
            print("Open camera")
        }))
        alertController.addAction(UIAlertAction(title: "Open Library", style: .default,handler: { _ in
            print("Open library")
        }))
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {  _ in
            print("Delete")
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}
