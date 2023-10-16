//
//  FFNewsSetupRequestViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 10.10.2023.
//

import UIKit

class FFNewsSetupRequestViewController: UIViewController {
    var viewModel: FFNewsSettingViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel = FFNewsSettingViewModel()
        view.backgroundColor = FFResources.Colors.secondaryColor
        title = "Setup request"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapNextView))
    }
    

    @objc private func didTapNextView(){
        
    }

}
