//
//  FFNewsTableViewDelegate.swift
//  FeelFit
//
//  Created by Константин Малков on 26.09.2023.
//

import UIKit
import SafariServices

enum TableViewDelegateSignal {
    case copyLink
    case openImage
    case openLink
    case addToFavourite
    case shareNews
}

///Protocol used for tableViewDelegate when user long tap on cell and call contextMenu
protocol FFNewsTableViewCellDelegate: AnyObject {
    func selectedCell(indexPath: IndexPath,selectedCase: TableViewDelegateSignal?)
}
///Separated class tableview delegate
class FFNewsTableViewDelegate: NSObject, UITableViewDelegate{
    
    weak var delegate: FFNewsTableViewCellDelegate?
    private var model = [Articles]()
    
    init(with delegate: FFNewsTableViewCellDelegate? = nil,model: [Articles] = [Articles]()) {
        self.delegate = delegate
        self.model = model
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.selectedCell(indexPath: indexPath, selectedCase: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height/4
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { suggestAction in
            let favouriteAction = UIAction(title: "Add To Favourite",image: UIImage(systemName: "heart")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath, selectedCase: .addToFavourite)
            }
            let copyAction = UIAction(title: "Copy Link",image: UIImage(systemName: "square.and.pencil")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath, selectedCase: .copyLink)
            }
            let openImageAction = UIAction(title: "Open Image",image: UIImage(systemName: "photo")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath, selectedCase: .openImage)
            }
            let openlinkAction = UIAction(title: "Open in Browser",image: UIImage(systemName: "safari")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath, selectedCase: .openLink)
            }
            let shareNewsAction = UIAction(title: "Share news",image: UIImage(systemName: "square.and.arrow.up")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath, selectedCase: .shareNews)
            }
            return UIMenu(title: "",children: [favouriteAction,openlinkAction,copyAction,openImageAction,shareNewsAction])
        }
    }
}
