//
//  FFCellSelectionViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 22.11.2023.
//

import UIKit

class FFCellSelectionViewController: UIViewController, SetupViewController {
    
    
    let titleText: String
    
    init(titleText: String) {
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupTableView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = FFResources.Colors.darkPurple
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellDetail")
        tableView.backgroundColor = .secondarySystemBackground
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        title = titleText
    }
}

extension FFCellSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDetail", for: indexPath)
        cell.textLabel?.text = "Text number is \(indexPath.row)"
        return cell
    }
    
    
}

extension FFCellSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension FFCellSelectionViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
