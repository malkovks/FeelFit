//
//  FFNewsPageDetailViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 06.10.2023.
//

import UIKit

class FFNewsPageDetailViewController: UIViewController {
    
    let model: Articles
    
    init(model: Articles) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        self.title = model.source.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        dump(model)
    }
    

    

}
