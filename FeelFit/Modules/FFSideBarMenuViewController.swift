//
//  FFSideBarMenuViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 19.09.2023.
//

import UIKit

class FFSideBarMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let menuItems = ["Sport News", "Exercises", "Health", "Plans", "User"]
    
    lazy var menuTableView: UITableView = {
       let table = UITableView()
        table.delegate = self
        table.dataSource = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed{
            removeFromParent()
        }
    }
    
    //MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
    //MARK: - Delegate
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true)
    }
    

}
