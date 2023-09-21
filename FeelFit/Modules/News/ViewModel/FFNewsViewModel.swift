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
    func didLoadData(model: [TestModel])
}

///VIewModel setup protocol
protocol FFNewsViewModelType {
    var delegate: FFNewsPageDelegate? { get set }
    func requestData()
}
///View model for FFNewsPageViewController
final class FFNewsPageViewModel: FFNewsViewModelType {
    weak var delegate: FFNewsPageDelegate?
    private var localModel = Array<TestModel>()
    
    ///function for request data from API
    func requestData() {
        print("Start work with view model")
        delegate?.willLoadData()
        let firstModel = TestModel(title: "First news", source: "BBC", description: "Some description", image: UIImage(systemName: "trash")!, newsLink: "www.apple.com", dataPublished: "21.09.2023")
        let secondModel = TestModel(title: "Second news", source: "Fox news", description: "Some description from Fox news", image: UIImage(systemName: "person")!, newsLink: "www.foxnews.com", dataPublished: "20.09.2023")
        let thirdModel = TestModel(title: "Third news", source: "CNN News", description: "Some CNN News", image: UIImage(systemName: "circle")!, newsLink: "www.cnn.com", dataPublished: "22.09.2023")
        localModel.append(firstModel)
        localModel.append(secondModel)
        localModel.append(thirdModel)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.delegate?.didLoadData(model: self.localModel)
            print("End work with view model")
        }
    }
    
    
}
