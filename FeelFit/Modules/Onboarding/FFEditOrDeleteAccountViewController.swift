//
//  FFEditOrDeleteAccountViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 08.03.2024.
//

import UIKit

class FFEditOrDeleteAccountViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }


}

extension FFEditOrDeleteAccountViewController: SetupViewController {
    func setupView() {
        setupNavigationController()
        setupViewModel()
    }
    
    func setupNavigationController() {    }
    
    func setupViewModel() {    }
    
    
}

#Preview {
    let nav = UINavigationController(rootViewController: FFEditOrDeleteAccountViewController())
    nav.modalPresentationStyle = .fullScreen
    return nav
}
