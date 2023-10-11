//
//  FFNewsTableViewDelegate.swift
//  FeelFit
//
//  Created by Константин Малков on 26.09.2023.
//

import UIKit
import SafariServices

enum TableViewSelectedConfiguration {
    case copyLink
    case openImage
    case openLink
    case addToFavourite
    case shareNews
}

///Protocol used for tableViewDelegate when user long tap on cell and call contextMenu
protocol FFNewsTableViewCellDelegate: AnyObject {
    func selectedCell(indexPath: IndexPath,model: Articles,selectedCase: TableViewSelectedConfiguration?)
}
///Separated class tableview delegate
//class FFNewsTableViewDelegate: NSObject, UITableViewDelegate{
    
//    weak var delegate: FFNewsTableViewCellDelegate?
//    private var model = [Articles]()
//    let viewModel: FFNewsPageViewModel!
//    
//    init(with delegate: FFNewsTableViewCellDelegate? = nil,model: [Articles] = [Articles]()) {
//        self.model = model
//        self.viewModel = FFNewsPageViewModel(localModel: model)
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        viewModel.didSelectRow(at: indexPath)
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.frame.size.height/4
//    }
//    
//    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        return viewModel.contextMenuConfiguration(at: indexPath, point: point)
//    }
//}
