//
//  FileManager + UIViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 04.02.2024.
//

import UIKit

extension UIViewController {
    func loadUserImageWithFileManager(_ partialName: String) -> UIImage? {
        let fileURL = getDocumentaryURL().appendingPathComponent(partialName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getDocumentaryURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let directory = paths.first!
        return directory
    }
}
