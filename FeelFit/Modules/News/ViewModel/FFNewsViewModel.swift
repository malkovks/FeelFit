//
//  ViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 19.09.2023.
//

import UIKit

///ViewModel delegate protocol
protocol FFNewsPageDelegate: AnyObject {
    func willLoadData()
    func didLoadData(model: [Articles]?,error: Error?)
    func selectedCell(indexPath: IndexPath,model: Articles,selectedCase: TableViewSelectedConfiguration?)
}

///ViewModel setup protocol
protocol FFNewsViewModelType {
    var delegate: FFNewsPageDelegate? { get set }
    func requestData(pageNumber: Int,type: String,filter: String)
}
///View model for FFNewsPageViewController
final class FFNewsPageViewModel: FFNewsViewModelType {
    
    var openController: ((IndexPath,Articles) -> Void)?
    
    weak var delegate: FFNewsPageDelegate?
//    weak var tableDelegate: FFNewsTableViewCellDelegate?
    
    
    var typeRequest: String = "fitness"
    var sortRequest: String = "publishedAt"
    var localeRequest: String = String(Locale.preferredLanguages.first!.prefix(2))
    
    var localModel = Array<Articles>()
    private var viewController: UIViewController?
    
    init(localModel: [Articles] = [Articles](),viewController: UIViewController = FFNewsPageViewController()){
        self.viewController = viewController
        self.localModel = localModel
    }
    
    
//MARK: - TableView functions
    ///function of choosing row at tableView and returning choosing model
    func didSelectRow(at indexPath: IndexPath){
        let selectedModel = localModel[indexPath.row]
        self.delegate?.selectedCell(indexPath: indexPath,model: selectedModel, selectedCase: .none)
    }
    
    func contextMenuConfiguration(at indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration {
        let model = localModel[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { suggestAction in
            let favouriteAction = UIAction(title: "Add To Favourite",image: UIImage(systemName: "heart")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath,model: model, selectedCase: .addToFavourite)
            }
            let copyAction = UIAction(title: "Copy Link",image: UIImage(systemName: "square.and.pencil")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath,model: model, selectedCase: .copyLink)
            }
            let openImageAction = UIAction(title: "Open Image",image: UIImage(systemName: "photo")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath,model: model, selectedCase: .openImage)
            }
            let openlinkAction = UIAction(title: "Open in Browser",image: UIImage(systemName: "safari")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath,model: model, selectedCase: .openLink)
            }
            let shareNewsAction = UIAction(title: "Share news",image: UIImage(systemName: "square.and.arrow.up")) { [unowned self] _ in
                self.delegate?.selectedCell(indexPath: indexPath,model: model, selectedCase: .shareNews)
            }
            return UIMenu(title: "",children: [favouriteAction,openlinkAction,copyAction,openImageAction,shareNewsAction])
        }
    }
    
    
    //MARK: - API Request
    ///function for request data from API
    func requestData(pageNumber: Int = 1,type: String,filter: String) {
        delegate?.willLoadData()
        let request = FFGetNewsRequest.shared
        request.getRequestResult(numberOfPage: pageNumber,requestType: type,requestSortType: filter,locale: localeRequest) { [weak self] result in
            switch result{
            case .success(let data):
                self?.delegate?.didLoadData(model: data, error: nil)
            case .failure(let error):
                self?.delegate?.didLoadData(model: nil, error: error)
            }
        }
    }
}
