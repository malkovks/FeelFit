//
//  FFNewsPageView.swift
//  FeelFit
//
//  Created by Константин Малков on 21.09.2023.
//

import UIKit

class FFNewsPageView: UIView, UITableViewDataSource {
    
    

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "newsCell")
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints(){
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "newsCell")
        cell.textLabel?.text = "Cell text"
        cell.detailTextLabel?.text = "Subtitle text"
        cell.imageView?.image = UIImage(systemName: "trash")
        cell.imageView?.tintColor = FFResources.Colors.activeColor
        return cell
    }
    
    
}
