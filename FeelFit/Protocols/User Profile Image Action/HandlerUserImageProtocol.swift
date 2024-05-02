//
//  HandlerUserImageProtocol.swift
//  FeelFit
//
//  Created by Константин Малков on 02.05.2024.
//

import UIKit

protocol HandleUserImageProtocol: AnyObject {
    
    /// user name storaged in file manager
    var userImageFileName: String { get }
    
    /// user image processed and loaded from file manager
    var userImage: UIImage? { get set }
}

extension HandleUserImageProtocol{
    var userImageFileName: String {
        get {
            return "userImage.jpeg"
        }
    }
    
    var userImage: UIImage? {
        get {
            do {
                let image = try FFUserImageManager.shared.loadUserImage(userImageFileName)
                return image
            } catch let error as UserImageErrorHandler {
                print(String(describing: error.errorDescription))
            } catch {
                print( "Critical error getting image!")
            }
            return UIImage(systemName: "person.circle")!.withConfiguration(UIImage.SymbolConfiguration(scale: .large))
        } set {
            guard let image = newValue else { return }
            do {
                try FFUserImageManager.shared.saveUserImage(image, fileName: userImageFileName)
            } catch let error as UserImageErrorHandler {
                print(String(describing: error.errorDescription))
            } catch {
                print( "Critical error getting image!")
            }
        }
    }
}
