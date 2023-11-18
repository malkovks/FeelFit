//
//  FFNewsDetailViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 16.10.2023.
//

import UIKit
import RealmSwift
import SafariServices

class FFNewsDetailViewModel: Coordinating {
    var coordinator: Coordinator?
    
    var realm = try! Realm()
    
    func changeNewsStatus(model: FFNewsModelRealm){
        
    }
    
    func openLinkSafariViewController(view viewController: UIViewController, url: String){
        guard let url = URL(string: url) else { return }
        let vc = SFSafariViewController(url: url)
        viewController.present(vc, animated: true)
    }
    
    func openImageView(viewController: UIViewController, imageView: UIImageView?,urlImage: String?){
        let image = imageView?.image ?? UIImage(systemName: "photo.fill")!
        let url = urlImage ?? ""
        let vc = FFImageDetailsViewController(newsImage: image, imageURL: url)
        viewController.present(vc, animated: true)
    }
    
    func shareNews(view viewController: UIViewController, model: Articles){
        let title = model.title
        let url = model.url
        let activityVC = UIActivityViewController(activityItems: [title,url], applicationActivities: .none)
        viewController.present(activityVC, animated: true)
    }
    
    func setupNewsSourceButton(viewController: UIViewController,model: Articles) -> UIMenu{
        var actions: [ UIAction]{
            return [
                UIAction(title: "Share",image: UIImage(systemName: "square.and.arrow.up"),handler: { _ in
                    self.shareNews(view: viewController, model: model)
                }),
                UIAction(title: "Copy news link",image: UIImage(systemName: "link"),handler: { _ in
                    UIPasteboard.general.string = model.url
                }),
                UIAction(title: "Add to Favourite",image: UIImage(systemName: "heart"),handler: { _ in
                    FFNewsStoreManager.shared.saveNewsModel(model: model, status: true)
                }),
                UIAction(title: "Open news",image: UIImage(systemName: "safari"),handler: { _ in
                    self.openLinkSafariViewController(view: viewController, url: model.url)
                }),
            ]
        }
        var menu: UIMenu {
            return UIMenu(title: "Actions", subtitle: "Choose what's exactly do you want to do", image: UIImage(systemName: "gear")!, identifier: .edit, options: .displayAsPalette, preferredElementSize: .medium, children: actions)
        }
        return menu
    }
}
