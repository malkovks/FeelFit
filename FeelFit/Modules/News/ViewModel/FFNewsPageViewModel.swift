//
//  ViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 19.09.2023.
//

import Foundation

protocol ViewModelDelegate: AnyObject {
    func didTapRegister(text:String)
}

final class ViewModel {
    
    var delegate: ViewModelDelegate?
    
    let user: Model
    
    init(user: Model){
        self.user = user
    }
    
    func fetchData(){
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            let message = "Test MVVM work correctly"
            DispatchQueue.main.asyncAfter(deadline: .now()){
                self.delegate?.didTapRegister(text: message)
            }
        }
    }
}
