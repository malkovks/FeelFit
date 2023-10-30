//
//  FFExercisesViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

class FFExercisesViewController: UIViewController, SetupViewController {
    
    var viewModel: FFExercisesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
    }
    
    func setupView() {
        viewModel = FFExercisesViewModel()
        view.backgroundColor = .systemGray2
    }
    
    func setupNavigationController() {
        title = "Exercises"
    }
    
    
    


}
