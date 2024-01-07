//
//  FFSearchPlanViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 07.01.2024.
//

import UIKit

class FFSearchPlanViewController: UIViewController, SetupViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupViewModel()
        
    }
    
    func setupView() {
        view.backgroundColor = .systemGroupedBackground
    }
    
    func setupNavigationController() {
        
        
        navigationItem.searchController = searchController
    }
    
    func setupViewModel() {
        
    }
    
    
}
