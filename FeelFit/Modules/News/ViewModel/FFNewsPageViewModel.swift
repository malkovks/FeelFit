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
    func selectedCell(indexPath: IndexPath,model: Articles,selectedCase: NewsTableViewSelectedConfiguration?)
}

///ViewModel setup protocol
protocol FFNewsViewModelType {
    var delegate: FFNewsPageDelegate? { get set }
    func requestData(pageNumber: Int,type: String,filter: String)
}

///View model for FFNewsPageViewController
final class FFNewsPageViewModel: FFNewsViewModelType, Coordinating {
    //delegate method for coordinator. Must be used when need to push or pop to view controller
    var coordinator: Coordinator?
    
    weak var delegate: FFNewsPageDelegate?
    
    
    var typeRequest: String = "fitness"
    var filterRequest: String = "publishedAt"
    var localeRequest: String = String(Locale.preferredLanguages.first!.prefix(2))
//MARK: - TableView functions
    ///function of choosing row at tableView and returning choosing model
    func didSelectRow(at indexPath: IndexPath, caseSetting: NewsTableViewSelectedConfiguration, model: [Articles]? = nil){
        guard let model = model else { return }
        let selectedModel = model[indexPath.row]
        switch caseSetting {
        case .shareNews :
            self.delegate?.selectedCell(indexPath: indexPath, model: selectedModel, selectedCase: .shareNews)
        case .addToFavourite:
            FFNewsStoreManager.shared.saveNewsModel(model: selectedModel, status: true)
            self.delegate?.selectedCell(indexPath: indexPath, model: selectedModel, selectedCase: caseSetting)
        case .copyLink:
            UIPasteboard.general.string = selectedModel.url
        case .rowSelected:
            self.delegate?.selectedCell(indexPath: indexPath, model: selectedModel, selectedCase: .rowSelected)
        case .openImage:
            self.delegate?.selectedCell(indexPath: indexPath, model: selectedModel, selectedCase: .openImage)
        case .openLink:
            self.delegate?.selectedCell(indexPath: indexPath, model: selectedModel, selectedCase: .openLink)
        }
    }
    ///Конфигурация для таблицы при зажатии на строку
    func contextMenuConfiguration(at indexPath: IndexPath, point: CGPoint,model: [Articles]) -> UIContextMenuConfiguration {
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil) { suggestAction in
            let favouriteAction = UIAction(title: "Add To Favourite",image: UIImage(systemName: "heart")) { [unowned self] _ in
                self.didSelectRow(at: indexPath, caseSetting: .addToFavourite,model: model)
            }
            let copyAction = UIAction(title: "Copy Link",image: UIImage(systemName: "square.and.pencil")) { [unowned self] _ in
                self.didSelectRow(at: indexPath, caseSetting: .copyLink,model: model)
            }
            let openImageAction = UIAction(title: "Open Image",image: UIImage(systemName: "photo")) { [unowned self] _ in
                self.didSelectRow(at: indexPath, caseSetting: .openImage,model: model)
            }
            let openlinkAction = UIAction(title: "Open in Browser",image: UIImage(systemName: "safari")) { [unowned self] _ in
                self.didSelectRow(at: indexPath, caseSetting: .openLink,model: model)
            }
            let shareNewsAction = UIAction(title: "Share news",image: UIImage(systemName: "square.and.arrow.up")) { [unowned self] _ in
                self.didSelectRow(at: indexPath, caseSetting: .shareNews,model: model)
            }
            return UIMenu(title: "",children: [favouriteAction,openlinkAction,copyAction,openImageAction,shareNewsAction])
        }
    }
    
    func heightForRowAt(view: UIView) -> CGFloat {
        return view.frame.size.height/4
    }
    
    func shareNews(view: UIViewController,model: Articles) -> UIActivityViewController {
        let newsTitle = model.title
        guard let newsURL = URL(string: model.url) else {
            return UIActivityViewController(activityItems: [], applicationActivities: nil)
        }
        let shareItems: [AnyObject] = [newsURL as AnyObject, newsTitle as AnyObject]
        let activityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.markupAsPDF,.assignToContact,.sharePlay]
        return activityViewController
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
    
    func refreshData(typeRequest: String, filterRequest: String, localeRequest: String) {
        self.typeRequest = typeRequest
        self.filterRequest = filterRequest
        self.localeRequest = localeRequest
        requestData(type: typeRequest, filter: filterRequest)
        UserDefaults.standard.setValue(typeRequest, forKey: "typeRequest")
        UserDefaults.standard.setValue(filterRequest, forKey: "filterRequest")
        UserDefaults.standard.setValue(localeRequest, forKey: "localeRequest")
    }
}
