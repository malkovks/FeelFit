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
}

///VIewModel setup protocol
protocol FFNewsViewModelType {
    var delegate: FFNewsPageDelegate? { get set }
    func requestData()
}
///View model for FFNewsPageViewController
final class FFNewsPageViewModel: FFNewsViewModelType {
    weak var delegate: FFNewsPageDelegate?
    private var localModel = Array<Articles>()
    
    ///function for request data from API
    func requestData() {
//        localModel.append(Articles(source: Source(id: "some id", name: "Some name"), author: "Some author", title: "Some title", description: "Some description", url: "www.news.com", urlToImage: nil, publishedAt: "20.10.2023", content: ""))
//        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            self.delegate?.didLoadData(model: self.localModel, error: nil)
//            print("End work with view model")
//        }
    }
    
    
}
