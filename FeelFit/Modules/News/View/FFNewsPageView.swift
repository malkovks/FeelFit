//
//  FFNewsPageView.swift
//  FeelFit
//
//  Created by Константин Малков on 21.09.2023.
//

import UIKit


class FFNewsPageView: UIView, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: FFNewsPageDelegate?

    var cellData: [Articles]?

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(NewsPageTableViewCell.self, forCellReuseIdentifier: NewsPageTableViewCell.identifier)
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    //UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsPageTableViewCell.identifier, for: indexPath) as! NewsPageTableViewCell
        let data = cellData?[indexPath.row]
        cell.configureCell(model: data)
//        cell.textLabel?.text = data?.title
//        cell.detailTextLabel?.text = data?.description
////        let dataImage = try! Data(contentsOf: url)
//        
//        cell.imageView?.image = UIImage(systemName: "trash")
//        cell.imageView?.tintColor = FFResources.Colors.activeColor
        return cell
    }
    //TAbleView delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.size.height/4
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
