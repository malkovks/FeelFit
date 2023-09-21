//
//  FFNewsPageView.swift
//  FeelFit
//
//  Created by Константин Малков on 21.09.2023.
//

import UIKit

class FFNewsPageView: UIView, UITableViewDataSource {
    
    weak var delegate: FFNewsPageDelegate?
    
    var cellData = [Articles]()

    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "newsCell")
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        uploadData()
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func uploadData(){
//        delegate?.willLoadData()
//        let request = FFGetNewsRequest.shared
//        request.getRequest { [weak self] result in
//            switch result {
//            case .success(let data):
//                self?.cellData = data
//                DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
//                    self?.tableView.reloadData()
//                    self?.delegate?.didLoadData(model: nil, error: nil)
//                    print("success")
//                }
//            case .failure(let error):
//                DispatchQueue.main.async {
//                    self?.delegate?.didLoadData(model: nil, error: error)
//                    print("error")
//                }
//            }
//        }
//    }
    func uploadData(){
        let request = FFGetNewsRequest.shared
        request.getRequestResult { [weak self] result in
            switch result {
            case .success(let data):
                self?.cellData = data
                DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
                    self?.tableView.reloadData()
                    self?.delegate?.didLoadData(model: data, error: nil)
                    print("success uploading")
                }
            case .failure(let error):
                self?.delegate?.didLoadData(model: nil, error: error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupConstraints(){
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "newsCell")
        let data = cellData[indexPath.row]
        cell.textLabel?.text = data.title
        cell.detailTextLabel?.text = data.description
        guard let url = URL(string: data.urlToImage ?? "") else { return UITableViewCell() }
//        let dataImage = try! Data(contentsOf: url)
        
        cell.imageView?.image = UIImage(systemName: "trash")
        cell.imageView?.tintColor = FFResources.Colors.activeColor
        return cell
    }
    
    
}
